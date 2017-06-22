clc;
clear;
close all;

%% Problem Difinition

CostFunction = @(x) MinOne(x);
nVar = 100; % number of variables
varSize =   [1 nVar];

%% GA Parameters

maxIt = 100;
nPop = 20; %population size

pc = 0.8; %Crossover percentage
nc = 2*round(pc*nPop/2); 

pm = 0.3; %mutation percentage
nm = round(pm * nPop);

%% Initialization

empty_individual.position = [];
empty_individual.cost = [];

pop = repmat(empty_individual,nPop,1);

for i=1:nPop
    
   %initialize position
   pop(i).position = randi([0 1],varSize);
   
   %Evaluation
   pop(i).cost = CostFunction(pop(i).position);  
   
end

%Sort Population

costs = [pop.cost];
[costs,sortOrder] = sort(costs);
pop = pop(sortOrder);

%Store best solution

bestSol = pop(1);

%Array to hold best cost values

bestCost = zeros(maxIt,1);

%% Main Loop

for i=1:maxIt
    
    %Crossover
    
    popc = repmat(empty_individual,nc/2,2);
    for k=1:nc/2
       
        %select first parent
        
        i1 = randi([1 nPop]);
        p1 = pop(i1);
        
        %Select second parent
        
        i2 = randi([1 nPop]);
        p2 = pop(i2);
        
        %Apply Crossover
        
        [popc(k,1).position,popc(k,2).position] = SinglePointCrossover(p1.position,p2.position);
        
        %Evaluation
        
        popc(k,1).cost = CostFunction(popc(k,1).position);
        popc(k,2).cost = CostFunction(popc(k,2).position);  
        
    end
    popc = popc(:);
    
    %Mutation
    
    popm = repmat(empty_individual,nm,1);
    
    for k=1:nm 
      %select parent
      
      l = randi([1 nPop]);
      p = pop(l);
      
      %Apply mutation
      
      popm(k).position = Mutate(p.position);
      
      %Evaluation
   
      popm(k).cost = CostFunction(popm(k).position);
    end
    
    W =[pop
        popc 
        popm];
    
       %Sort population
       
       costs = [W.cost];
       [costs,sortOrder] = sort(costs);
       W = W(sortOrder);
       
       pop = W(1:nPop);
       
       %Store best solution ever found
       bestSol = pop(1);
       
       %Store best cost ever found
       bestCost(i) = bestSol.cost;
       
       %Show iteration information
       disp(['Iteration ' num2str(i) ':best cost = ' num2str(bestCost(i))]);
end

%% Results

figure;
plot(bestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Cost');


