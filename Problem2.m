clc
clear
isParallel=0;
addpath('./TriangleRayIntersection')
sizeTerrain=500;
height=80;
%[terrainPoints,faces,vertices,X,Y]=generate2DTerrain(sizeTerrain);
[terrainPoints,faces,vertices,X,Y]=generate2DStepTerrain(sizeTerrain);
if isParallel==1
    p = gcp('nocreate');
    if isempty(p)
        parpool;
    end
end
figure(1)
clf
hold on;
surf(X,Y,terrainPoints,'FaceColor','w')
daspect([1,1,1])
view([45,45])
d(size(terrainPoints,1),size(terrainPoints,2))=0;
pi_v(size(terrainPoints,1),size(terrainPoints,2))=0;
for i=2:sizeTerrain
    d(1,i)=inf;
    d(2,i)=inf;
end
isOtherSizeReached=0;
for f=1:10
    for i=1:sizeTerrain
        for j=1:sizeTerrain
            gi=i;
            gj=j;
            orig_i=[X(1,gi),Y(1,gi),height];
            [visibleFaces_i,visibleVerticesSizes_i] = calcVisibility(orig_i,vertices,faces,terrainPoints,isParallel);
            
            orig_j=[X(1,gj),Y(1,gj),height];
            [visibleFaces_j,visibleVerticesSizes_j] = calcVisibility(orig_j,vertices,faces,terrainPoints,isParallel);
            
            bw(size(terrainPoints,1),size(terrainPoints,2))=0;
            bw=logical(bw);
            for h=1:size(visibleVerticesSizes_i,1)
                if visibleVerticesSizes_i(h,1)>1
                    x_h=vertices(h,2);
                    y_h=vertices(h,1);
                    bw(x_h,y_h)=1;
                end
            end
            for h=1:size(visibleVerticesSizes_j,1)
                if visibleVerticesSizes_j(h,1)>1
                    x_h=vertices(h,2);
                    y_h=vertices(h,1);
                    bw(x_h,y_h)=1;
                end
            end
            CC = bwconncomp(bw);
            
            for o=1:size(CC.PixelIdxList,2)
                minVal=getMinInPatch(CC.PixelIdxList{1,o},d,terrainPoints);
                patch=CC.PixelIdxList{1,o};
                for m=1:size(patch,1)
                    yp=floor((patch(m,1)+1)/size(terrainPoints,1));
                    xp=mod(patch(m,1)+1,2)+1;
                    if d(xp,yp)>minVal+1
                        d(xp,yp)=minVal+1;
                        pi_v(xp,yp)=i;
                        if yp==sizeTerrain
                            isOtherSizeReached=1;
                            disp('FOUND')
                            break;
                        end
                    end
                end
                if isOtherSizeReached==1
                    break;
                end
            end
            if isOtherSizeReached==1
                    break;
                end
        end
        if isOtherSizeReached==1
                    break;
                end
    end
    if isOtherSizeReached==1
                    break;
                end
end
