extends Resource
class_name LinkedList

var head: LinkedObject = null
var tail: LinkedObject = null

var size: int = 0

func _init(data_list: Array):
	if not data_list:
		return
	
	for data in data_list:
		push_front(data)

func get_forward_string():
	var ll_str = ""
	var itr = head
	
	if not itr.next:
		ll_str = str(itr.data)
	
	while itr:
		ll_str += str(itr.data)
		if itr.next:
			ll_str += "<-->"
		itr = itr.next
	
	return(ll_str)

func get_forward_list():
	var list = []
	
	var itr = head
	while itr:
		list.append(itr.data)
		itr = itr.next
	
	return list

func push_front(data):
	var object = LinkedObject.new(data)
	
	# If linked list is empty
	if not head:
		head = object
		tail = object
		self.size += 1
		return
	
	object.prev = tail
	tail.next = object
	tail = object
	self.size += 1

func push_back(data):
	var object = LinkedObject.new(data)
	
	# If linked list is empty
	if not head:
		head = object
		tail = object
		self.size += 1
		return
	
	object.next = head
	head.prev = object
	head = object
	self.size += 1

func insert_at_index(index, data):
	var object = LinkedObject.new(data)
	
	if index < 0 or index > self.size - 1:
		print("Can't add to linked list. Index is out of range")
		return
	
	if index == 0:
		push_back(data)
		self.size += 1
		return
	elif index == self.size - 1:
		push_front(data)
		self.size += 1
		return
	
	var itr = head
	var itr_index = 0
	while itr:
		if itr_index == index - 1:
			object.prev = itr
			object.next = itr.next
			itr.next.prev = object
			itr.next = object
			
			self.size += 1
			return
		itr_index += 1
		itr = itr.next

