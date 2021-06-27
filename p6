# Задача 1. Написать функцию, получающую 2 отсортированных массива A и B, и объединяющую их в одном отсортированном массиве C (length(C)=length(A)+length(B)=n). 
# Алгоритм должен иметь оценку сложности O(n). Функцию можно назвать merge. Реализовать 2 варианта этой функции:


function merge(A,B) # а) merge(A,B) - возвращает массив C
    C = collect(1:length(A)+length(B)) # dim C = dim A + dim B 
    if length(A)<length(B)  #если длинна массива A меньше
        s = 1
        for i in 1:length(A)
            if A[i] < B[i]
                C[s] = A[i]
                C[s+1] = B[i]
                s += 2
            end
        end

        for j in i:length(B) 
            C[j] = B[j]
        end

    else       #если длинна массива A больше
        s = 1
        for i in 1:length(B)
            if A[i] < B[i]  
                C[s] = A[i]
                C[s+1] = B[i]
                s += 2
            end
        end

        for j in i:length(A) # заполняем массив С оставшимися элементами из массива A
            C[j] = A[j]
        end
    end

    return C # возвращаем отсортированный массив С, состоящий из элементов массивов A и B
end


function merge!(A,B,C) :: Vector{T} where T  # б) merge!(A,B,C) - используется внешний массив C (поэтому в конце имени функции и поставлен восклицательный знак).
  
    # Далее делаем все аналогично пункту a
    if length(A)<length(B) 
        k = 1
        for i in 1:length(A)
            if A[i] < B[i]
                C[k] = A[i]
                C[k+1] = B[i]
                k += 2
            end
        end

        for j in i:length(B)
            C[j] = B[j]
        end
    else
        k = 1
        for i in 1:length(B)
            if A[i] < B[i]
                C[k] = A[i]
                C[k+1] = B[i]
                k += 2
            end
        end

        for j in i:length(A)
            C[j] = A[j]
        end
    end

    return C
end

#Задача 2. Написать функцию, выполняющую частичную сортировку. А именно, функция получает некоторый массив A и некоторое значение b, 
#и переставляет элементы в массивае A так, что бы в нём сначала шли все элементы, меньшие b, затем - все, равные b, и затем, наконец, 
# все большие b. Алгоритм должен иметь оценку сложности O(n). Реализовать следующие 2 варианта этой функции:

#а) c использованием 3-х вспомогательных массивов (с последующим их объединением в один);

function partsort_a(A,b)

    A1 = collect(1:length(A))
    A2 = collect(1:length(A))
    A3 = collect(1:length(A)) 
    a1 = a2 = a3 = 1

    for i in 1:length(A)
        if b > A[i]     
            A1[a1] = A[i]
            a1 += 1
        elseif b == A[i] 
            A2[a2] = A[i]
            a2 += 1
        else              
            A3[a3] = A[i]
            a3 += 1
        end
    end

    return append!(append!(V1,V2),V3) # Возвращаем новый массив, состоящий ищ массивов А1, А2, А3
end

#б) без использования вспомогательного массива (все перемещения элементов должны осуществляться в переделах одного массива).
# Указание для варианта б). Ввести переменные `l,m,k` и воспользоваться инвариантом цикла: `A[1:l]<b && A[l+1:m]== b && A[k+1:n]>b` `(n=length(A))`.

function  partsort_b(A,b)
    l = 0
    m = 1
    k = length(A)
    for i in 1:length(A) 
        if A[i] < b
            l += 1
    end

    while m != length(A) || check_sort(A,b) == false # сортируем массив
        if A[mod(m,length(A))] == b                  # берем остаток от деления на длинну массива, т.к можем не отсортировать массив с одного захода
            A[mod(m,length(A))],A[mod(m,length(A))+1] = A[mod(m,length(A))+1],A[mod(m,length(A))] 
            m += 1
        end

        if A[k] > b 
            A[k],A[k-1] = A[k-1],A[k]
            k -= 1
            if k < 0         # Если мы не смогли отсортировать массив с одного захода, то 
                k +=length(A) # прибавляем длинну массива, чтобы не выйти за пределы индексации
            end
        end
    end 

    return A
end

function check_sort(A,b) # проверка на отсортированность массива
    vail = 0
    flag = true
    for i in 1:length(A)-1
         if A[i] == b 
            vail = i
            if  A[vail] > A[i] # проверяем, что справа от элемента  равного b нет элемента, который меньше  b
                flag  =  false
            end
            if A[vail] < A[length(A)-i]  # проверяем, что слева от элемента  равного b нет элемента, который , больше  b
                flag  =  false
            end
        elseif A[i] > b     # проверяем, что справа от элемента  большего b нет элемента, который меньше  b
            if A[i] < b
                flag = false
            end   
        end
    end
    return flag
end

# Задача 3. Написать функцию, выполняющую частичную сортировку. А именно, функция получает некоторый массив A и некотрое значение b, и переставляет элементы в массивае A так, 
# чтобы в нём сначала шли все элементы, меньшие или равные b, а затем - все большие b. Алгоритм должен иметь оценку сложности O(n).


function partsort_a(A,b)
    while i < length(A) || check_sort(A,b) == false # # сортируем массив (check_sort(A,b) - см. Задача 2)
        if b < A[i]     
            if mod(i,length(A)) == 0 
                A[0],A[1] = A[1],A[0]
            else  
                A[mod(i,length(A))],A[ mod(i,length(A))-1] = A[ mod(i,length(A))-1],A[mod(i,length(A))] # берем остаток от деления на длинну массива, т.к можем не отсортировать массив с одного захода
        end
    end    
    return A
end
# Задача 4. Написать функию, для заданного натурального числа n возвращающую массив всех биномиальных коэффициентов порядка n.

function binomial_coeff(n::Int)
    a = zeros(Int64, n+1) # создаем пустой массив с длинной равной (n+1)
    a[0] = 1
    a[1] = 1
    for _ in 2:n # в данном случае не используется параметр-счетчик
        t = a[1]
        for i in 2:n+1 
            b = a[i]
            a[i] = t + a[i]
            t = b
        end
    end
    return a  # возвращающую массив, состоящий из всех биномиальных коэффициентов порядка n.
end
