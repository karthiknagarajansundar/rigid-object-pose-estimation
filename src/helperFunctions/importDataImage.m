function[U u bounding_boxes poses img] =  importDataImage
    addpath('data\');
    filesStruct = dir('data\*.*');
    dataStruct = filesStruct(3:11); imgStruct = filesStruct(12:end);
    for i = 1:9
        data{i} = load(dataStruct(i).name); % U u bounding_boxes poses
        img{i} = imread(imgStruct(i).name);
    end
    
    for obj_idx = 1:7
        for img_idx = 1:9
            X = data{img_idx}.U{obj_idx};
            U{obj_idx,img_idx}=(X - repmat(mean(X,2) ,[1 size(X,2)]));
            u{obj_idx,img_idx}=data{img_idx}.u{obj_idx};
            bounding_boxes{obj_idx,img_idx} = data{img_idx}.bounding_boxes{obj_idx};
            poses{obj_idx,img_idx} = data{img_idx}.poses{obj_idx};
        end
    end
end



