extends Node

const SSEnum = preload("res://scripts/enums/SSEnum.gd");

class StructChest:
	var Name: String
	var ChestType: SSEnum.Chest 
	var Life: int
	var Rate: int

class StructChestObject:
	var ChestType: SSEnum.Chest 
	var ChestModel: Variant
	var Life: int
	var Location: Vector3i
	var Rotation: Vector3i
	var Scale: Vector3i

class StructChallenge:
	var Name: String
	var Slot1: String
	var Slot2: String
	var Slot3: String
	var Slot4: String

class StructCurrency:
	var Name: String
	var Cash: int
	var Diamond: int
	var Sapphire: int
	var Topaz: int
	var Ruby: int
	var Emerald: int
	var Amethyst: int
	var Onyx: int
