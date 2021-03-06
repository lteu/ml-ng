function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% n =  size(X, 2);
preamble = ones(m,1);
X = [preamble,X];
Z2 = Theta1*X';
A2 = sigmoid(Z2);


preamble = ones(1,m);
A2 = [preamble;A2];
Z3 = Theta2*A2;
A3 = sigmoid(Z3);
h = A3;

Y = [];
for i = 1:m
	tmp = zeros(1,num_labels);
	tmp(y(i)) = 1;
	Y = [Y;tmp];
end

size(Y, 1);
size(Y, 2);

% original ans
% J = 1/m * (-Y * log(h) - (1-Y) * log(1-h)) + lambda/(2*m) * sum(theta(2:end).^2);

Theta1_unroll = Theta1(:,2:end)(:);
Theta2_unroll = Theta2(:,2:end)(:);
J = 1/m * sum(sum(-Y' .* log(h) - (1-Y') .* log(1-h))) + lambda/(2*m) * (sum(Theta1_unroll.^2) + sum(Theta2_unroll.^2));

% correct ans
% J = 1/m * sum(sum(-1 * Y' .* log(h)-(1-Y') .* log(1-h)));

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%


for i = 1:m
	x = X(i,:);

	z2 = Z2(:,i);
	a2 = A2(:,i);
	z3 = Z3(:,i);
	a3 = A3(:,i);

	yk = zeros(num_labels,1);
	yk(y(i)) = 1;

	d3 = a3 - yk;
	
	d2 =  Theta2'* d3.* [1;sigmoidGradient(z2)];

	d2 = d2(2:end);

	Theta1_grad = Theta1_grad + d2*x;
	Theta2_grad = Theta2_grad + d3*a2';
end


Theta1_grad = 1/m * Theta1_grad;
Theta2_grad = 1/m * Theta2_grad;




% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% size(Theta1_grad)
% size(Theta1)

Theta1_bias_free = Theta1;
Theta1_bias_free(:,1) = 0;
Theta1_grad = Theta1_grad + lambda/m * Theta1_bias_free;

Theta2_bias_free = Theta2;
Theta2_bias_free(:,1) = 0;
Theta2_grad = Theta2_grad + lambda/m * Theta2_bias_free;




% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
