def smo_simplified(X, y, C, tol, max_passes, kernel, s):

    # number of training points
    n = len(y)

    # initialization
    a = np.zeros((n, 1)) # column vector w/ num_rows = ynum_rows
    b = 0

    passes = 0
    while (passes < max_passes):
        num_changed_alphas = 0
        for i in range(0, n):
            Ei = discriminant_function(a, y, X, b, X[:, i], kernel, s) - y[i]
            if ((y[i]*Ei < -tol and a[i] < C) or (y[i]*Ei > tol and a[i] > 0)):
                
                # select j ~= i randomly
                temp = np.random.permutation(n)
                j = temp[0]
                if (j == i):
                    j = temp[2]
                
                Ej = discriminant_function(a, y, X, b, X[:, j], kernel, s) - y[j]

                ai = a[i]
                aj = a[j]

                # calculate L and H
                if (y[i] != y[j]):
                    L = max(0, aj - ai)
                    H = min(C, C + aj - ai)
                else:
                    L = max(0, ai + aj - C)
                    H = min(C, ai + aj)
                if (L == H):
                    continue

                eta = 2 * np.dot(X[:, i].T, X[:, j]).sum() - np.dot(X[:, i].T, X[:, i]).sum() - np.dot(X[:, j].T, X[:, j]).sum()
                if (eta >= 0):
                    continue

                # calculate a[j] and clip
                a[j] = a[j] - y[j] * (Ei - Ej) / eta
                if (a[j] > H):
                    a[j] = H
                elif (a[j] < L):
                    a[j] = L
                
                if abs(a[j] - a[i]) < 1e-5:
                    continue

                # calculate a[i]
                a[i] = a[i] + y[i]*y[j]*(aj - a[j])

                # compute b
                b1 = b - Ei - y[i] * (a[i] - ai) * np.dot(X[:, i].T, X[:, i]).sum() - y[j] * (a[j] - aj) * np.dot(X[:, i].T, X[:, j]).sum()
                b2 = b - Ej - y[i] * (a[i] - ai) * np.dot(X[:, i].T, X[:, j]).sum() - y[j] * (a[j] - aj) * np.dot(X[:, j].T, X[:, j]).sum()
                if (0 < a[i] < C):
                    b = b1
                elif (0 < a[j] < C):
                    b = b2
                else:
                    b = (b1 + b2)/2
                
                num_changed_alphas += 1
        
        if num_changed_alphas == 0:
            passes = passes + 1
        else:
            passes = 0

        return a, b
 
        

 def smo_simplified_gaussian(X, y, C, tol, max_passes):

    # number of training points
    n = len(y)

    # initialization
    a = np.zeros((n, 1)) # column vector w/ num_rows = ynum_rows
    b = 0

    passes = 0
    while (passes < max_passes):
        num_changed_alphas = 0
        for i in range(0, n):
            Ei = discriminant_function(a, y, X, b, X[:, i]) - y[i]
            if ((y[i]*Ei < -tol and a[i] < C) or (y[i]*Ei > tol and a[i] > 0)):
                
                # select j ~= i randomly
                temp = np.random.permutation(n)
                j = temp[0]
                if (j == i):
                    j = temp[2]
                
                Ej = discriminant_function(a, y, X, b, X[:, j]) - y[j]

                ai = a[i]
                aj = a[j]

                # calculate L and H
                if (y[i] != y[j]):
                    L = max(0, aj - ai)
                    H = min(C, C + aj - ai)
                else:
                    L = max(0, ai + aj - C)
                    H = min(C, ai + aj)
                if (L == H):
                    continue

                # eta = 2 * np.dot(X[:, i].T, X[:, j]).sum() - np.dot(X[:, i].T, X[:, i]).sum() - np.dot(X[:, j].T, X[:, j]).sum()
                
                eta = 2 * gaussian_kernel(X[:, i], X[:, j]) - gaussian_kernel(X[:, i], X[:, i]) - gaussian_kernel(X[:, j], X[:, j])

                if (eta >= 0):
                    continue

                # calculate a[j] and clip
                a[j] = a[j] - y[j] * (Ei - Ej) / eta
                if (a[j] > H):
                    a[j] = H
                elif (a[j] < L):
                    a[j] = L
                
                if abs(a[j] - a[i]) < 1e-5:
                    continue

                # calculate a[i]
                a[i] = a[i] + y[i]*y[j]*(aj - a[j])

                # compute b
                b1 = b - Ei - y[i] * (a[i] - ai) * gaussian_kernel(X[:, i], X[:, i]) - y[j] * (a[j] - aj) * gaussian_kernel(X[:, i], X[:, j])
                b2 = b - Ej - y[i] * (a[i] - ai) * gaussian_kernel(X[:, i], X[:, j]) - y[j] * (a[j] - aj) * gaussian_kernel(X[:, j], X[:, j])
                if (0 < a[i] < C):
                    b = b1
                elif (0 < a[j] < C):
                    b = b2
                else:
                    b = (b1 + b2)/2
                
                num_changed_alphas += 1
        
        if num_changed_alphas == 0:
            passes = passes + 1
        else:
            passes = 0

        return a, b

    def discriminant_function(a, y, x, b, xquery, kernel):
        f = b
        n = len(y)
        for i in range(0, n):
            f = f + a[i] * y[i] * kernel.call_kernel(x[:, i], xquery)
        return f

    def smo_simplified(X, y, C, tol, max_passes, kernel):

        # number of training points
        n = len(y)

        # initialization
        a = np.zeros((n, 1)) # column vector w/ num_rows = ynum_rows
        b = 0

        passes = 0
        while (passes < max_passes):
            num_changed_alphas = 0
            for i in range(0, n):
                Ei = discriminant_function(a, y, X, b, X[:, i], kernel) - y[i]
                if ((y[i]*Ei < -tol and a[i] < C) or (y[i]*Ei > tol and a[i] > 0)):
                    
                    # select j ~= i randomly
                    temp = np.random.permutation(n)
                    j = temp[0]
                    if (j == i):
                        j = temp[2]
                    
                    Ej = discriminant_function(a, y, X, b, X[:, j], kernel, s) - y[j]

                    ai = a[i]
                    aj = a[j]

                    # calculate L and H
                    if (y[i] != y[j]):
                        L = max(0, aj - ai)
                        H = min(C, C + aj - ai)
                    else:
                        L = max(0, ai + aj - C)
                        H = min(C, ai + aj)
                    if (L == H):
                        continue

                    eta = 2 * kernel.call_kernel(X[:, i].T, X[:, j]) - kernel.call_kernel(X[:, i].T, X[:, i]) - kernel.call_kernel(X[:, j].T, X[:, j])
                    if (eta >= 0):
                        continue

                    # calculate a[j] and clip
                    a[j] = a[j] - y[j] * (Ei - Ej) / eta
                    if (a[j] > H):
                        a[j] = H
                    elif (a[j] < L):
                        a[j] = L
                    
                    if abs(a[j] - a[i]) < 1e-5:
                        continue

                    # calculate a[i]
                    a[i] = a[i] + y[i]*y[j]*(aj - a[j])

                    # compute b
                    b1 = b - Ei - y[i] * (a[i] - ai) * kernel.call_kernel(X[:, i].T, X[:, i]) - y[j] * (a[j] - aj) * kernel.call_kernel(X[:, i].T, X[:, j])
                    b2 = b - Ej - y[i] * (a[i] - ai) * kernel.call_kernel(X[:, i].T, X[:, j]) - y[j] * (a[j] - aj) * kernel.call_kernel(X[:, j].T, X[:, j])
                    if (0 < a[i] < C):
                        b = b1
                    elif (0 < a[j] < C):
                        b = b2
                    else:
                        b = (b1 + b2)/2
                    
                    num_changed_alphas += 1
            
            if num_changed_alphas == 0:
                passes = passes + 1
            else:
                passes = 0

            return a, b
 