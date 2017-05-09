package com.ryanwirth.pelletquest.world.ai
{
	import com.ryanwirth.pelletquest.world.Direction;
	import com.ryanwirth.pelletquest.world.entity.Entity;
	import com.ryanwirth.pelletquest.world.map.MapManager;
	import com.ryanwirth.pelletquest.world.PlayerManager;
	
	/**
	 * ...
	 * @author Ryan Wirth
	 */
	public class AIPathfinder extends AI
	{
		private var heuristic:Function = heuristicManhattan;
		private var allNodes:Vector.<AIPathfinderNode>;
		
		public function AIPathfinder(entity:Entity)
		{
			super(entity);
		}
		
		/**
		 * Phil Chertok's implementation of A* Pathfinding in AS3.
		 * Includes some minor modifications to ensure node objects are properly orphaned/cleaned up.
		 */
		override public function findPath():String
		{
			allNodes = new Vector.<AIPathfinderNode>();
			
			var destinationNode:AIPathfinderNode = new AIPathfinderNode(PlayerManager.PLAYER.X_TILE, PlayerManager.PLAYER.Y_TILE);
			var startingNode:AIPathfinderNode = new AIPathfinderNode(X_TILE, Y_TILE);
			var openNodes:Vector.<AIPathfinderNode> = new Vector.<AIPathfinderNode>();
			var closedNodes:Vector.<AIPathfinderNode> = new Vector.<AIPathfinderNode>();
			var currentNode:AIPathfinderNode = startingNode;
			var testNode:AIPathfinderNode;
			var connectedNodes:Vector.<AIPathfinderNode>;
			var travelCost:Number = 1.0;
			var g:Number;
			var h:Number;
			var f:Number;
			
			allNodes.push(startingNode, destinationNode);
			
			currentNode.g = 0;
			currentNode.h = heuristic(currentNode, destinationNode, travelCost);
			currentNode.f = currentNode.g + currentNode.h;
			
			var l:int = openNodes.length;
			var i:int;
			
			while (!areNodesEqual(currentNode, destinationNode))
			{
				connectedNodes = connectedNodeFunction(currentNode);
				l = connectedNodes.length;
				for (i = 0; i < l; ++i)
				{
					testNode = connectedNodes[i];
					if (areNodesEqual(testNode, currentNode) || testNode.traversable == false) continue;
					g = currentNode.g + travelCost;
					h = heuristic(testNode, destinationNode, travelCost);
					f = g + h;
					if (isOpen(testNode, openNodes) || isOpen(testNode, closedNodes))
					{
						if (testNode.f > f)
						{
							
							testNode.f = f;
							testNode.g = g;
							testNode.h = h;
							testNode.parentNode = currentNode;
						}
					}
					else
					{
						testNode.f = f;
						testNode.g = g;
						testNode.h = h;
						testNode.parentNode = currentNode;
						openNodes.push(testNode);
					}
				}
				closedNodes.push(currentNode);
				if (openNodes.length == 0)
				{
					return "";
				}
				openNodes.sort(sortNodesByF);
				currentNode = openNodes.shift();
			}
			
			// We are on the player, don't move!
			if (currentNode.parentNode == null) return "";
			
			// Trace the nodes back from the destination node to ONE BEFORE the startingNode!
			var targetNode:AIPathfinderNode = currentNode;
			while (true)
			{
				// If the parent of the targetNode is where the entity is, stop tracing.
				if (targetNode.parentNode == startingNode) break;
				
				// Get the targetNode's parent (back up the chain).
				targetNode = targetNode.parentNode;
			}
			
			// We now have our parent!
			var direction:String = "";
			
			if (targetNode.x < X_TILE) direction = Direction.LEFT;
			else if (targetNode.x > X_TILE) direction = Direction.RIGHT;
			else if (targetNode.y < Y_TILE) direction = Direction.UP;
			else if (targetNode.y > Y_TILE) direction = Direction.DOWN;
			
			// Dispose of all the nodes!
			for (i = 0, l = allNodes.length; i < l; i++)
			{
				allNodes[i].parentNode = null;
				allNodes[i] = null;
			}
			allNodes = null;
			openNodes = null;
			closedNodes = null;
			targetNode = null;
			testNode = null;
			currentNode = null;
			destinationNode = null;
			startingNode = null;
			connectedNodes = null;
			
			return direction;
		}
		
		/**
		 * Finds all the walkable nodes adjacent to the provided one.
		 * @param	node The starting node.
		 * @return A vector containing adjacent, walkable nodes.
		 */
		private function connectedNodeFunction(node:AIPathfinderNode):Vector.<AIPathfinderNode>
		{
			var vec:Vector.<AIPathfinderNode> = new Vector.<AIPathfinderNode>();
			if (MapManager.isTileWalkable(node.x - 1, node.y)) vec.push(new AIPathfinderNode(node.x - 1, node.y, node));
			if (MapManager.isTileWalkable(node.x + 1, node.y)) vec.push(new AIPathfinderNode(node.x + 1, node.y, node));
			if (MapManager.isTileWalkable(node.x, node.y - 1)) vec.push(new AIPathfinderNode(node.x, node.y - 1, node));
			if (MapManager.isTileWalkable(node.x, node.y + 1)) vec.push(new AIPathfinderNode(node.x, node.y + 1, node));
			
			// Make sure we keep track of all the nodes we create!
			for (var i:int = 0, l:int = vec.length; i < l; i++) allNodes.push(vec[i]);
			
			return vec;
		}
		
		/**
		 * Determines if two nodes represent the same tile - that is, they have the same x- and y-coordinates.
		 * @param	node1 The first node to check.
		 * @param	node2 The second node to check.
		 * @return True if both nodes have the same coordinates, false if not.
		 */
		private function areNodesEqual(node1:AIPathfinderNode, node2:AIPathfinderNode):Boolean
		{
			if (node1.x == node2.x && node1.y == node2.y) return true;
			else return false;
		}
		
		/**
		 * Sorts nodes by their f heuristic value.
		 * @param	node1 The first node to check.
		 * @param	node2 The second node to check.
		 * @return -1 if node1 comes first, 1 if node2 comes first, 0 otherwise.
		 */
		private function sortNodesByF(node1:AIPathfinderNode, node2:AIPathfinderNode):int
		{
			if (node1.f < node2.f) return -1;
			else if (node1.f > node2.f) return 1;
			else return 0;
		}
		
		/**
		 * Determines if the specified node is represented within the vector.
		 * @param	node The node to check for.
		 * @param	vec The vector to check within.
		 * @return True if the node is found in the vector, false if not.
		 */
		private function isOpen(node:AIPathfinderNode, vec:Vector.<AIPathfinderNode>):Boolean
		{
			for (var i:int = 0, l:int = vec.length; i < l; i++)
				if (areNodesEqual(node, vec[i])) return true;
			return false;
		}
		
		/**
		 * Calculates the Manhattan distance between node and destinationNode.
		 * @param	node The starting node.
		 * @param	destinationNode The "goal" node.
		 * @param	cost The cost of traversing this path.
		 * @return The calculated Manhattan distance between the two nodes.
		 */
		public function heuristicManhattan(node:AIPathfinderNode, destinationNode:AIPathfinderNode, cost:Number = 1.0):Number
		{
			return Math.abs(node.x - destinationNode.x) * cost + Math.abs(node.y - destinationNode.y) * cost;
		}
	
	}

}