function R_Mask = MIA_GrowPoint(inImage, pt, R_Mask, lowerBound, upperBound)

pt_x = pt(1);
pt_y = pt(2);

R_Mask(pt_x, pt_y) = true;

% Loop through rows
for i = 1:3
    
    % Loop through columns
    for j = 1:3
        
        % Calculate index relative to inPoint
        newPt_x = pt_x + (i - 2);
        newPt_y = pt_y + (j - 2);
        
        % Confirm new index is in the image
        if (newPt_x > 0 && newPt_x <= size(inImage,1) && newPt_y > 0 && newPt_y <= size(inImage,2) && ~R_Mask(newPt_x, newPt_y))
            
            % Compare intensity to bounds
            if (lowerBound <= inImage(newPt_x, newPt_y)) && (inImage(newPt_x, newPt_y) <= upperBound)
                
                % Do not recall function on self
                % TODO: find better way to avoid this conditional
                if (i ~= 2 || j~= 2)
                    R_Mask = MIA_GrowPoint(inImage, [newPt_x, newPt_y], R_Mask, lowerBound, upperBound);
                end
            end
        end
    end
end

end