function [circularBuffer, maxElement] = addToBuffer(circularBuffer, newElement, maxSize)
    % Adds a new element to a circular buffer, removing the oldest if full.
    % 
    % Inputs:
    % - circularBuffer: Current state of the buffer (2D array).
    % - newElement: New column vector to add to the buffer.
    % - maxSize: Maximum allowed size of the buffer.
    % 
    % Outputs:
    % - circularBuffer: Updated buffer after adding the new element.
    % - maxElement: Column in the buffer with the highest value in the first row.
    
    % Calculate the available space in the buffer
    availableSpace = maxSize - length(circularBuffer);

    if availableSpace > 0
        % If the buffer is not full, add the new element
        circularBuffer = [circularBuffer, newElement];
    else
        % If the buffer is full, remove the oldest elements and add the new one
        circularBuffer = [circularBuffer(:,(2-availableSpace):end), newElement];
    end

    % Determine the column with the maximum value in the first row
    maxElement = getMaxElement(circularBuffer);
end

function maxElement = getMaxElement(circularBuffer)
    % Returns the column with the highest value in the first row.
    %
    % Inputs:
    % - circularBuffer: Buffer to search (2D array).
    %
    % Outputs:
    % - maxElement: Column vector with the highest value in the first row.

    [~, maxIndex] = max(circularBuffer(1,:));
    maxElement = circularBuffer(:, maxIndex);
end
