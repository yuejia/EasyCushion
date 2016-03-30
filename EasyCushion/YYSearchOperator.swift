//
//  YYSearchOperator.swift
//  YYTools
//
//  Created by Yue Jia on 11/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation


class NSGAIIList
{
    var index: Int = 0
    var parent : NSGAIIList? = nil
    var child : NSGAIIList? = nil
    
    init(index: Int)
    {
        self.index = index
    }
    
    /* Insert an element X into the list at location specified by NODE */
    func insert (x: Int)
    {
        let temp = NSGAIIList(index: x)
        temp.child = self.child
        temp.parent = self
        
        if self.child != nil
        {
            self.child!.parent = temp
        }
        self.child = temp
    }
    
    /* Delete the node NODE from the list */
    func del() -> NSGAIIList
    {
        let temp = self.parent!;
        temp.child = self.child;
        
        if temp.child != nil
        {
            temp.child!.parent = temp
        }
        
        return (temp);
    }
}


class YYSearchOperator
{
    
    /* Function to assign rank and crowding distance to a population of size pop_size*/
    /* Deb's version rank.c */
    func assignRankAndCrowdingDistance (new_pop new_pop: YYPopulation)
    {
        var flag : Int
        var i : Int
        var end : Int
        var front_size : Int
        var rank=1
        var orig : NSGAIIList?
        var cur : NSGAIIList?
        var temp1 : NSGAIIList?
        var temp2 : NSGAIIList?
        var popsize = GlobalSearchSettings.PopulationSize
        
        orig = NSGAIIList(index: 0)
        cur = NSGAIIList(index: 0)
        front_size = 0
        
        orig!.index = -1;
        cur!.index = -1;
        temp1 = orig
        
        for var i=0; i<popsize; i++
        {
            temp1!.insert(i)
            temp1 = temp1!.child!
        }
        
        repeat
        {
            if orig!.child!.child == nil
            {
                new_pop.individuals[orig!.child!.index].rank = rank
                new_pop.individuals[orig!.child!.index].crowdDist = Double.infinity
                
                break
            }
            
            temp1 = orig!.child!
            cur!.insert (temp1!.index)
            front_size = 1
            temp2 = cur!.child!
            temp1 = temp1!.del()
            temp1 = temp1!.child!
            
            repeat
            {
                temp2 = cur!.child!
                repeat
                {
                    end = 0
                    flag = self.checkDominance (
                        a: new_pop.individuals[ temp1!.index ], b: new_pop.individuals[temp2!.index])
                    
                    if flag == 1
                    {
                        orig!.insert (temp2!.index)
                        temp2 = temp2!.del ()
                        front_size--
                        temp2 = temp2!.child!
                    }
                    
                    if flag == 0
                    {
                        temp2 = temp2!.child!
                    }
                    if flag == -1
                    {
                        end = 1
                    }
                    
                }
                    while end != 1 && temp2 != nil
                
                if  flag == 0 || flag == 1
                {
                    cur!.insert (temp1!.index)
                    front_size++
                    temp1 = temp1!.del ()
                }
                temp1 = temp1!.child
            }
                while temp1 != nil
            
            temp2 = cur!.child
            repeat
            {
                new_pop.individuals[temp2!.index].rank = rank
                temp2 = temp2!.child
            }
                while temp2 != nil
            
            self.assignCrowdingDistanceList (pop: new_pop, lst: cur!.child!, front_size: front_size)
            temp2 = cur!.child
            
            repeat
            {
                temp2 = temp2!.del()
                temp2 = temp2!.child
            }
                while cur!.child != nil
            
            rank+=1
        }
            while orig!.child != nil
    }
    
    /* Routine for usual non-domination checking
     It will return the following values
     1 if a dominates b
     -1 if b dominates a
     0 if both a and b are non-dominated */
    // Deb's dominance.c
    func checkDominance (a a: YYIndividual , b: YYIndividual) -> Int
    {
        var i : Int
        var flag1: Int
        var flag2: Int
        var nobj = GlobalSearchSettings.NumberOfObjectives
        flag1 = 0
        flag2 = 0
        
        if a.constr_violation < 0 && b.constr_violation < 0
        {
            if a.constr_violation > b.constr_violation
            {
                return 1
            }
            else
            {
                if a.constr_violation < b.constr_violation
                {
                    return -1
                }
                else
                {
                    return 0
                }
            }
        }
        else
        {
            if a.constr_violation < 0 && b.constr_violation == 0
            {
                return -1
            }
            else
            {
                if a.constr_violation == 0 && b.constr_violation < 0
                {
                    return  1
                }
                else
                {
                    for var i = 0 ; i < nobj ; i++
                    {
                        if a.obj[i] < b.obj[i]
                        {
                            flag1 = 1
                        }
                        else
                        {
                            if a.obj[i] > b.obj[i]
                            {
                                flag2 = 1
                            }
                        }
                    }
                    if flag1==1 && flag2==0
                    {
                        return 1
                    }
                    else
                    {
                        if flag1==0 && flag2==1
                        {
                            return -1
                        }
                        else
                        {
                            return 0
                        }
                    }
                }
            }
        }
    }
    
    /* Routine to compute crowding distance based on ojbective function values when the population in in the form of a list */
    func assignCrowdingDistanceList (pop pop : YYPopulation , lst : NSGAIIList, front_size: Int )
    {
        var obj_array : [[Int]]
        
        var dist : [Int]
        var  i: Int
        var  j: Int
        var nobj = GlobalSearchSettings.NumberOfObjectives
        
        var temp: NSGAIIList?
        
        temp = lst
        
        if front_size==1
        {
            pop.individuals[lst.index].crowdDist = Double.infinity
            return
        }
        if front_size==2
        {
            pop.individuals[lst.index].crowdDist = Double.infinity
            pop.individuals[lst.child!.index].crowdDist = Double.infinity
            return
        }
        obj_array = [[Int]]()
        dist = [Int]()
        for var i = 0; i < nobj; i++
        {
            var tmpFront = [Int]()
            
            for var k = 0 ; k < front_size ; k++
            {
                tmpFront.append(0)
            }
            
            obj_array.append( tmpFront )
        }
        
        for var j = 0; j < front_size; j++
        {
            dist.append(temp!.index)
            temp = temp!.child
        }
        
        self.assignCrowdingDistance (pop: pop, dist: dist, obj_array: &obj_array, front_size: front_size)
    }
    
    
    /* Routine to compute crowding distance based on objective function values when the population in in the form of an array */
    func assignCrowdingDistanceIndices (pop pop:YYPopulation ,  c1: Int,  c2 : Int)
    {
        var obj_array: [[Int]]
        var dist : [Int]
        var  i : Int
        var j : Int
        var front_size : Int
        var nobj = GlobalSearchSettings.NumberOfObjectives
        
        front_size = c2-c1+1;
        if front_size==1
        {
            pop.individuals[c1].crowdDist = Double.infinity
            return
        }
        if (front_size==2)
        {
            pop.individuals[c1].crowdDist = Double.infinity
            pop.individuals[c2].crowdDist = Double.infinity
            return
        }
        
        obj_array = [[Int]]()
        dist = [Int]()
        
        for var i=0; i < nobj; i++
        {
            var tmpFront = [Int]()
            
            for var k = 0 ; k < front_size ; k++
            {
                tmpFront.append(0)
            }
            
            obj_array.append( tmpFront )
        }
        var tc1 = c1
        for var j=0; j<front_size; j++
        {
            dist.append(tc1++)
            
        }
        self.assignCrowdingDistance (pop: pop, dist: dist, obj_array: &obj_array, front_size: front_size)
    }
    
    
    /* Routine to compute crowding distances */
    //
    
    func assignCrowdingDistance (pop pop: YYPopulation , dist: [Int], inout obj_array: [[Int]], front_size: Int )
    {
        var  i: Int
        var  j: Int
        var nobj = GlobalSearchSettings.NumberOfObjectives
        for var i=0 ; i < nobj ; i++
        {
            for var j=0 ; j < front_size ; j++
            {
                obj_array[i][j] = dist[j]
            }
            self.quicksortFrontObj (pop: pop, objcount: i, obj_array: &obj_array[i], obj_array_size: front_size)
        }
        for var j=0 ; j < front_size; j++
        {
            pop.individuals[dist[j]].crowdDist = 0.0
        }
        for var i=0; i < nobj; i++
        {
            pop.individuals[obj_array[i][0]].crowdDist = Double.infinity
        }
        for var i=0; i < nobj; i++
        {
            for var j = 1; j < front_size - 1 ; j++
            {
                if pop.individuals[obj_array[i][j]].crowdDist != Double.infinity
                {
                    if (pop.individuals[obj_array[i][front_size-1]].obj[i] == pop.individuals[obj_array[i][0]].obj[i])
                    {
                        pop.individuals[obj_array[i][j]].crowdDist += 0.0
                    }
                    else
                    {
                        pop.individuals[obj_array[i][j]].crowdDist += (pop.individuals[obj_array[i][j+1]].obj[i] - pop.individuals[obj_array[i][j-1]].obj[i])/(pop.individuals[obj_array[i][front_size-1]].obj[i] - pop.individuals[obj_array[i][0]].obj[i])
                    }
                }
            }
        }
        for var j=0; j<front_size; j++
        {
            if pop.individuals[dist[j]].crowdDist != Double.infinity
            {
                pop.individuals[dist[j]].crowdDist = (pop.individuals[dist[j]].crowdDist) / Double(nobj)
            }
        }
    }
    
    /* Randomized quick sort routine to sort a population based on a particular objective chosen */
    func quicksortFrontObj(pop pop: YYPopulation, objcount : Int , inout obj_array : [Int],  obj_array_size : Int)
    {
        self.qSortFrontObj (pop: pop, objcount: objcount, obj_array: &obj_array, left: 0, right: obj_array_size-1)
    }
    
    
    /* Actual implementation of the randomized quick sort used to sort a population based on a particular objective chosen */
    func qSortFrontObj(pop pop: YYPopulation,  objcount : Int,  inout obj_array:[Int],  left : Int,  right : Int)
    {
        var index : Int
        var  temp : Int
        var i : Int
        var j : Int
        
        var pivot : Double
        
        if left < right
        {
            index = self.rnd (low: left, high: right)
            temp = obj_array[right]
            obj_array[right] = obj_array[index]
            obj_array[index] = temp
            pivot = pop.individuals[obj_array[right]].obj[objcount]
            i = left-1
            for var j=left; j<right; j++
            {
                if pop.individuals[obj_array[j]].obj[objcount] <= pivot
                {
                    i+=1
                    temp = obj_array[j]
                    obj_array[j] = obj_array[i]
                    obj_array[i] = temp
                }
            }
            index=i+1
            temp = obj_array[index]
            obj_array[index] = obj_array[right]
            obj_array[right] = temp
            self.qSortFrontObj (pop: pop, objcount: objcount, obj_array: &obj_array, left: left, right: index-1)
            self.qSortFrontObj (pop: pop, objcount: objcount, obj_array: &obj_array, left: index+1, right: right)
        }
    }
    
    /* Randomized quick sort routine to sort a population based on crowding distance */
    func quicksortDist(pop pop: YYPopulation , inout dist : [Int],  front_size : Int)
    {
        self.qSortDist (pop: pop, dist: &dist, left: 0, right: front_size-1)
    }
    
    /* Actual implementation of the randomized quick sort used to sort a population based on crowding distance */
    func qSortDist(pop pop: YYPopulation, inout dist: [Int] ,  left : Int,  right : Int)
    {
        var index : Int
        var temp : Int
        var i : Int
        var j : Int
        var pivot : Double
        
        
        if left < right
        {
            index = self.rnd (low: left, high: right)
            temp = dist[right]
            dist[right] = dist[index]
            dist[index] = temp
            pivot = pop.individuals[dist[right]].crowdDist
            i = left-1
            for var j=left; j<right; j++
            {
                if (pop.individuals[dist[j]].crowdDist <= pivot)
                {
                    i+=1;
                    temp = dist[j];
                    dist[j] = dist[i];
                    dist[i] = temp;
                }
            }
            index=i+1
            temp = dist[index];
            dist[index] = dist[right];
            dist[right] = temp;
            self.qSortDist (pop: pop, dist: &dist, left: left, right: index-1)
            self.qSortDist (pop: pop, dist: &dist, left: index+1, right: right)
        }
    }
    
    
    
    /* Fetch a single random integer between low and high including the bounds */
    func rnd (low low : Int,  high: Int) -> Int
    {
        var  res : Int
        if low >= high
        {
            res = low
        }
        else
        {
            
            res = Int(arc4random_uniform( UInt32(high) - UInt32(low) + 1) + UInt32(low))
            
            if (res > high)
            {
                res = high
            }
        }
        return res
    }
    
    // Mark: selection.c
    
    /* Routine for tournament selection, it creates a new_pop from old_pop by performing tournament selection and the crossover */
    func selectionAndCrossover (old_pop old_pop : YYPopulation ) -> YYPopulation
    {
        var a1 = [Int]()
        var a2 = [Int] ()
        var temp : Int
        var i : Int
        var rand : Int
        var parent1 : YYIndividual
        var parent2 : YYIndividual
        var popsize =  GlobalSearchSettings.PopulationSize
        var newInds = [YYIndividual]()
        for var i=0; i < popsize; i++
        {
            a1.append(i)
            a2.append(i)
        }
        
        for var i=0; i < popsize; i++
        {
            rand = Int.random(i, upper: popsize)
            temp = a1[rand]
            a1[rand] = a1[i]
            a1[i] = temp
            rand = Int.random(i, upper: popsize)
            temp = a2[rand];
            a2[rand] = a2[i];
            a2[i] = temp;
        }
        
        for var i=0; i<popsize; i+=4
        {
            parent1 = tournament (ind1: old_pop.individuals[a1[i]], ind2: old_pop.individuals[a1[i+1]])
            parent2 = tournament (ind1: old_pop.individuals[a1[i+2]], ind2: old_pop.individuals[a1[i+3]])
            
            //   crossover (parent1, parent2, new_pop.individuals[i], new_pop.individuals[i+1])
            var ind3 : YYIndividual
            var ind4 : YYIndividual
            
            (ind3, ind4) = self.crossover(ind1: parent1, ind2: parent2)
            newInds.append(ind3)
            newInds.append(ind4)
            
            parent1 = tournament (ind1: old_pop.individuals[a2[i]], ind2: old_pop.individuals[a2[i+1]])
            parent2 = tournament (ind1: old_pop.individuals[a2[i+2]], ind2: old_pop.individuals[a2[i+3]])
            
            //   crossover (parent1, parent2, new_pop.individuals[i+2], &new_pop.individuals[i+3])
            
            (ind3, ind4) = self.crossover(ind1: parent1, ind2: parent2)
            newInds.append(ind3)
            newInds.append(ind4)
        }
        
        return YYPopulation(individuals: newInds)
        
    }
    
    func crossover (ind1 ind1:YYIndividual, ind2:YYIndividual) -> (YYIndividual, YYIndividual)
    {
        
        var ind3 = ( ind1 as! DiscussionOrder ).copy()
        var ind4 = ( ind2 as! DiscussionOrder ).copy()
        
        
        //TODO: Crossover rate 0.5
        YYMutationOperator.swapGeneForIndividual(ind3)
        //  YYMutationOperator.swapGeneForIndividual(ind4)
        
        //     YYMutationOperator.mutationCrossoverIndividual(ind3)
        YYMutationOperator.mutationCrossoverIndividual(ind4)
        
        
        return (ind3, ind4)
    }
    
    func mutationPopulation(pop pop : YYPopulation )
    {
        for ind in pop.individuals
        {
            YYMutationOperator.swapGeneForIndividual(ind)
        }
    }
    
    /* Routine for binary tournament */
    func tournament (ind1 ind1:YYIndividual, ind2:YYIndividual) -> YYIndividual
    {
        var flag: Int
        flag = self.checkDominance (a: ind1, b: ind2)
        if flag == 1
        {
            return ind1
        }
        if flag == -1
        {
            return (ind2);
        }
        if ind1.crowdDist > ind2.crowdDist
        {
            return ind1
        }
        if ind2.crowdDist > ind1.crowdDist
        {
            return ind2
        }
        if Double.random(0.0, upper: 1.0) <= 0.5
        {
            return ind1
        }
        else
        {
            return ind2
        }
    }
    
    //Mark: merge
    
    /* Routine to merge two populations into one */
    // The original ones are copied,
    // But I didn't do copy
    func merge(pop1 pop1 : YYPopulation,  pop2 : YYPopulation ) -> YYPopulation
    {
        return YYPopulation(individuals: (pop1.individuals + pop2.individuals) )
    }
    
    //Mark: fillInd
    
    /* Routine to perform non-dominated sorting */
    func fillNondominatedSort (mixed_pop mixed_pop: YYPopulation) -> YYPopulation
    {
        
        var flag:Int
        var i : Int
        var j : Int
        var end : Int
        var front_size : Int
        var archieve_size : Int
        var rank=1
        var pool: NSGAIIList?
        var elite: NSGAIIList?
        var temp1 : NSGAIIList?
        var temp2 : NSGAIIList?
        var popsize = GlobalSearchSettings.PopulationSize
        var new_inds = [YYIndividual]()
        
        pool = NSGAIIList(index: -1)
        elite = NSGAIIList(index: -1)
        
        front_size = 0
        archieve_size=0
        temp1 = pool
        
        // add placehodler in tmp ind
        let tmp_ind = YYIndividual()
        for var i=0; i < popsize; i++
        {
            new_inds.append(tmp_ind)
        }
        var new_pop = YYPopulation(individuals: new_inds)
        
        //
        
        for var i=0; i < 2*popsize; i++
        {
            temp1!.insert (i)
            temp1 = temp1!.child
        }
        i=0
        repeat
        {
            temp1 = pool!.child
            elite!.insert(temp1!.index)
            front_size = 1
            
            temp2 = elite!.child
            temp1 = temp1!.del()
            temp1 = temp1!.child
            repeat
            {
                temp2 = elite!.child
                if temp1==nil
                {
                    break
                }
                repeat
                {
                    end = 0
                    flag = self.checkDominance (a: mixed_pop.individuals[ temp1!.index ], b: mixed_pop.individuals[temp2!.index])
                    
                    
                    if flag == 1
                    {
                        pool!.insert (temp2!.index)
                        temp2 = temp2!.del()
                        front_size--
                        temp2 = temp2!.child;
                    }
                    if flag == 0
                    {
                        temp2 = temp2!.child
                    }
                    if flag == -1
                    {
                        end = 1
                    }
                }while end != 1 && temp2 != nil
                
                if flag == 0 || flag == 1
                {
                    elite!.insert (temp1!.index)
                    front_size++
                    temp1 = temp1!.del()
                }
                temp1 = temp1!.child
            }
                while temp1 != nil
            temp2 = elite!.child
            j=i
            if  (archieve_size+front_size) <= popsize
            {
                repeat
                {
                    let currInd = mixed_pop.individuals[temp2!.index] as! DiscussionOrder
                    new_pop.individuals[i]=currInd.copy()
                    new_pop.individuals[i].rank = rank
                    archieve_size+=1
                    temp2 = temp2!.child
                    i+=1
                }
                    while temp2 != nil
                self.assignCrowdingDistanceIndices (pop: new_pop, c1: j, c2: i-1)
                rank+=1
            }
            else
            {
                self.crowdingFill (mixed_pop: mixed_pop, new_pop: new_pop, count: i, front_size: front_size, elite: elite!);
                archieve_size = popsize
                for var j=i; j<popsize; j++
                {
                    new_pop.individuals[j].rank = rank;
                }
            }
            temp2 = elite!.child
            repeat
            {
                temp2 = temp2!.del ()
                temp2 = temp2!.child
            }
                while elite!.child !=  nil
        }
            while archieve_size < popsize
        
        return new_pop
    }
    
    /* Routine to fill a population with individuals in the decreasing order of crowding distance */
    func crowdingFill (mixed_pop mixed_pop: YYPopulation, new_pop: YYPopulation,  count: Int , front_size: Int , elite: NSGAIIList)
    {
        var dist : [Int]
        var temp : NSGAIIList?
        var popsize = GlobalSearchSettings.PopulationSize
        var i: Int
        var j: Int
        
        self.assignCrowdingDistanceList (pop: mixed_pop, lst: elite.child!, front_size: front_size);
        dist = [Int]()
        
        temp = elite.child;
        
        for var j=0; j<front_size; j++
        {
            dist.append(temp!.index)
            temp = temp!.child;
        }
        
        self.quicksortDist (pop: mixed_pop, dist: &dist, front_size: front_size)
        for var i=count, j=front_size-1; i < popsize; i++, j--
        {
            let ind =  mixed_pop.individuals[dist[j]] as! DiscussionOrder
            new_pop.individuals[i] = ind.copy()
        }
        
    }
    
    
}