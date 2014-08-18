import struct

class nshead():

	format = "BBI16sIII"
	magic_num = 0xfb709394

	def __init__(self, log_id = 0, provider = "pynshead", body_len = 0):
		self.id = 0
		self.version = 0
		self.log_id = log_id
		self.provider = provider
		self.reversed = 0
		self.body_len = body_len
		self.struct = struct.Struct(self.format)
		self.size = self.struct.size

	def frombin(self, bin):
		(self.id, self.version, self.log_id, self.provider, magic_num,
				self.reversed, self.body_len) = self.struct.unpack(bin)
		if magic_num != self.magic_num:
			raise UserWarning("magic_num check fail")

		self.provider = self.provider.strip('\0')

	def tobin(self):
		return self.struct.pack(self.id, self.version, self.log_id,
				self.provider, self.magic_num, self.reversed, self.body_len)

