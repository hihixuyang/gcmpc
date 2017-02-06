function obj = set_constraint(obj, h_x, h_u, g, c_type)
%SET_CONSTRAINTS Set constraint matrices Hx, Hu and g
%
%    Input(s):
%    (1) obj    - GCMPC class instance
%    (2) h_x    - Constraint state matrix
%    (3) h_y    - Constraint control input matrix
%    (4) g      - Constraint affine term
%    (5) c_type - Constraint type from ConstraintTypeEnum (optional)
%
%    Author(s):
%    (1) Carlos M. Massera
%
%    Note(s):
%    (1) Resulting constraint is of the form Hx x_k + Hu u_k + g <= 0

    if ~obj.is_system_set
        error('System matrices not set, define them before the constraint')
    end
    
    if obj.is_constraint_set
         warning('Constraint definition is replaced, make sure your code is correct')
    end
    
    if nargin <= 4
        c_type = ConstraintTypeEnum.standard;
    end
    
    % Get constraint size
    n_c = size(h_x, 1);
    
    % Check matricies consistency
    if size(h_x, 2) ~= obj.n_x
        error('Hx matrix size does not match A matrix');
    end
    
    if size(h_u, 1) ~= n_c
        error('Hu matrix size does not match Hx matrix');
    end
    
    if size(h_u, 2) ~= obj.n_u
        error('Hu matrix size does not match Bu matrix');
    end
    
    if size(g, 1) ~= n_c
        error('g vector size does not match Hc matrix');
    end
    
    if size(g, 2) ~= 1
        error('g is not a vector');
    end
    
    if (c_type == ConstraintTypeEnum.standard) || ...
       (c_type == ConstraintTypeEnum.robust_invariant)
        obj.constraint_type = c_type;
    else
        error('Invalid constraint type')
    end
    
    % Set instance variables
    obj.h_x = h_x;
    obj.h_u = h_u;
    obj.g = g;
    obj.n_c = n_c;
    obj.is_constraint_set = true;
end
