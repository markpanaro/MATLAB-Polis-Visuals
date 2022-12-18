% Visualizing Artifact Data from the Excavations at Polis Data Set

% Imports from the data set the seven columns that can be best visualized
ImportPolisData;


% Visualize Artifact Material Types
% Remove missing data
[TypeData,missingIndices2] = rmmissing(PolisData,"DataVariables","MaterialType");

% Display results
figure

% Plot cleaned data
histogram(PolisData.MaterialType(~missingIndices2),"ShowOthers","on",...
    "FaceColor",[0 114 189]/255,"FaceAlpha",1,"DisplayName","Cleaned data")
hold on

% Plot removed missing entries
histogram(PolisData.MaterialType(missingIndices2),"ShowOthers","on",...
    "FaceColor",[145 145 145]/255,"FaceAlpha",1,...
    "DisplayName","Removed missing entries")
title("Number of removed missing entries: " + nnz(missingIndices2))

hold off
legend
xlabel("MaterialType")


% Output count of all items within the data set
% summary(TypeData.MaterialType)

% Create initial pie chart
% pie(TypeData.MaterialType)
% xlabel("PartType")
% title("PartType")

% Define array of category keywords
typeCats = ["Terracotta" "Bone" "Carbon" "Bronze" "Ceramic" "Charcoal" "Clay" ...
    "Copper" "Glass" "Iron" "Limestone" "Marble" "Metal" "Plaster" "Shell" "Slag" "Stone"];

TypeData.MaterialType = CategorizeData(TypeData.MaterialType, typeCats);

% Clean removed categories from the set
TypeData.MaterialType = removecats(TypeData.MaterialType);

% Output a final summary
summary(TypeData.MaterialType)

% Generate Pie Chart
figure
pie(TypeData.MaterialType)
title("Material Types of Polis Artifacts",'FontSize',22)
fontsize(gcf,"scale",.70)


% Select context to visualize from the list
context = 'B.D7:t19-2000';

% Create matrix of containing all data from given context and clean
contextMatrix = TypeData(TypeData.ContextThree == context,:);
contextMatrix.MaterialType = removecats(contextMatrix.MaterialType);

figure
pie(contextMatrix.MaterialType)
title("Material Types of Context " + context,'FontSize',22)
fontsize(gcf,"scale",.70)


% Visualize Material Type Per Context
% Define array of category keywords
catCats = ["Architectural Misc" "Architectural Stone" "Architectural Terracotta" "Bone, Ivory, Shell" ...
    "Bronze" "Glass" "Iron" "Miscellaneous Ceramic" "Mosaic Tesserae" "Numismatics" "Organic" "Pottery" ...
    "Slag" "Stone Objects" "Terracotta Figurines" "Terracotta Lamps"];

TypeData.MaterialCategory = CategorizeData(TypeData.MaterialCategory, catCats);

TypeData.MaterialCategory = removecats(TypeData.MaterialCategory);

summary(TypeData.MaterialCategory)

figure
pie(TypeData.MaterialCategory)
title("Categories of Polis Artifacts",'FontSize',22)
fontsize(gcf,"scale",.70)


% Visualizing Sizes of Terracotta Statuettes
% Create set of terracotta statuettes
statuettes = TypeData(TypeData.MaterialCategory == "Terracotta Figurines",:);
% Remove missing data
[newTable,missingIndices] = rmmissing(statuettes,...
    "DataVariables",["PartWidth","PartThickness","PartHeight"]);

% Display results
figure
% Get locations of missing data
indicesForPlot = ismissing(statuettes.PartWidth);
mask = missingIndices & ~indicesForPlot;

% Plot cleaned data
plot(find(~missingIndices),newTable.PartWidth,"Color",[0 114 189]/255,...
    "LineWidth",1.5,"DisplayName","Cleaned data")
hold on

% Plot data in rows where other variables contain missing entries
plot(find(mask),statuettes.PartWidth(mask),"x","Color",[64 64 64]/255,...
    "DisplayName","Removed by other variables")

% Plot removed missing entries
x2 = repelem(find(indicesForPlot),3);
y = repmat([ylim(gca) missing]',nnz(indicesForPlot),1);
plot(x2,y,"Color",[145 145 145]/255,"DisplayName","Removed missing entries")
title("Number of removed missing entries: " + nnz(indicesForPlot))

hold off
legend
ylabel("PartWidth")
clear indicesForPlot mask x2 y
newTable = newTable(newTable.PartWidth < 30,:);
newTable = newTable(newTable.PartHeight < 30,:);

%newTable = rmoutliers(newTable.PartWidth);
%newTable = rmoutliers(newTable.PartHeight);

figure
s = scatter(newTable.PartWidth,newTable.PartHeight);
line = lsline;
title("Sizes of Terracotta Figurines")
xlabel("Part Width (cm)")
ylabel("Part Height (cm)")
line.Color = 'c';
s.Marker = "diamond";


function toCategorize = CategorizeData(toCategorize, categories)

for x = 1:length(toCategorize)
    str = string(toCategorize(x));
    
    % Check str against typeCats: If substring is found, assign MaterialType at x 
    % to that category and continue 
    for item = categories
        if contains(str,item) 
            toCategorize(x) = categorical(item);
            continue
        end
    end
    
    % If MaterialType at x is not a defined category, assign it to other
    if ~(any(categories(:) == string(toCategorize(x))))
        toCategorize(x) = categorical("Other");
    end
end

toCategorize = removecats(toCategorize);

end