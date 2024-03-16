
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c5 11 80       	mov    $0x8011c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 30 10 80       	mov    $0x80103080,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 7f 10 80       	push   $0x80107f00
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 45 45 00 00       	call   801045a0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 7f 10 80       	push   $0x80107f07
80100097:	50                   	push   %eax
80100098:	e8 d3 43 00 00       	call   80104470 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 87 46 00 00       	call   80104770 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 a9 45 00 00       	call   80104710 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 43 00 00       	call   801044b0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 6f 21 00 00       	call   80102300 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 7f 10 80       	push   $0x80107f0e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 8d 43 00 00       	call   80104550 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 27 21 00 00       	jmp    80102300 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 7f 10 80       	push   $0x80107f1f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 4c 43 00 00       	call   80104550 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 fc 42 00 00       	call   80104510 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 50 45 00 00       	call   80104770 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 9f 44 00 00       	jmp    80104710 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 7f 10 80       	push   $0x80107f26
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 cb 44 00 00       	call   80104770 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 3e 3f 00 00       	call   80104210 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 b9 36 00 00       	call   801039a0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 15 44 00 00       	call   80104710 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 bf 43 00 00       	call   80104710 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 72 25 00 00       	call   80102910 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 7f 10 80       	push   $0x80107f2d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 e7 88 10 80 	movl   $0x801088e7,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 f3 41 00 00       	call   801045c0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 7f 10 80       	push   $0x80107f41
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 51 61 00 00       	call   80106570 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 66 60 00 00       	call   80106570 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 5a 60 00 00       	call   80106570 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 4e 60 00 00       	call   80106570 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 7a 43 00 00       	call   801048d0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 c5 42 00 00       	call   80104830 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 45 7f 10 80       	push   $0x80107f45
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 dc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 c0 41 00 00       	call   80104770 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 27 41 00 00       	call   80104710 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 ae 11 00 00       	call   801017a0 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 70 7f 10 80 	movzbl -0x7fef8090(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 83 3f 00 00       	call   80104770 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 58 7f 10 80       	mov    $0x80107f58,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 b0 3e 00 00       	call   80104710 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 5f 7f 10 80       	push   $0x80107f5f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 d8 3e 00 00       	call   80104770 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 3b 3d 00 00       	call   80104710 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 9d 39 00 00       	jmp    801043b0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 87 38 00 00       	call   801042d0 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 68 7f 10 80       	push   $0x80107f68
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 2b 3b 00 00       	call   801045a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 02 1a 00 00       	call   801024a0 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 df 2e 00 00       	call   801039a0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 b4 22 00 00       	call   80102d80 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 e9 15 00 00       	call   801020c0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 21 0f 00 00       	call   80101a30 <iunlockput>
    end_op();
80100b0f:	e8 dc 22 00 00       	call   80102df0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 57 6c 00 00       	call   80107790 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 08 6a 00 00       	call   801075b0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 e2 68 00 00       	call   801074c0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 aa 0e 00 00       	call   80101ab0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 f0 6a 00 00       	call   80107710 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 9a 21 00 00       	call   80102df0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 49 69 00 00       	call   801075b0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 a8 6b 00 00       	call   80107830 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 58 3d 00 00       	call   80104a30 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 44 3d 00 00       	call   80104a30 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 03 6d 00 00       	call   80107a00 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 fa 69 00 00       	call   80107710 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 98 6c 00 00       	call   80107a00 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 4a 3c 00 00       	call   801049f0 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 5e 65 00 00       	call   80107330 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 36 69 00 00       	call   80107710 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 07 20 00 00       	call   80102df0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 81 7f 10 80       	push   $0x80107f81
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 8d 7f 10 80       	push   $0x80107f8d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 7b 37 00 00       	call   801045a0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 2a 39 00 00       	call   80104770 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 9a 38 00 00       	call   80104710 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 81 38 00 00       	call   80104710 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 bc 38 00 00       	call   80104770 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 3f 38 00 00       	call   80104710 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 94 7f 10 80       	push   $0x80107f94
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 6a 38 00 00       	call   80104770 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 cf 37 00 00       	call   80104710 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 9d 37 00 00       	jmp    80104710 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 03 1e 00 00       	call   80102d80 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 48 09 00 00       	call   801018d0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 59 1e 00 00       	jmp    80102df0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 a2 25 00 00       	call   80103550 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 9c 7f 10 80       	push   $0x80107f9c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 b6 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 89 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 80 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 51 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 54 0a 00 00       	call   80101ab0 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 0d 08 00 00       	call   80101880 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 5e 26 00 00       	jmp    801036f0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 a6 7f 10 80       	push   $0x80107fa6
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 77 07 00 00       	call   80101880 <iunlock>
      end_op();
80101109:	e8 e2 1c 00 00       	call   80102df0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 4d 1c 00 00       	call   80102d80 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 62 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 60 0a 00 00       	call   80101bb0 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 1b 07 00 00       	call   80101880 <iunlock>
      end_op();
80101165:	e8 86 1c 00 00       	call   80102df0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 af 7f 10 80       	push   $0x80107faf
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 42 24 00 00       	jmp    801035f0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 b5 7f 10 80       	push   $0x80107fb5
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011bf:	90                   	nop

801011c0 <fileseek>:

void fileseek(struct file *f, uint offset){
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  if(f) {
801011c6:	85 c0                	test   %eax,%eax
801011c8:	74 06                	je     801011d0 <fileseek+0x10>
    f->off = offset;
801011ca:	8b 55 0c             	mov    0xc(%ebp),%edx
801011cd:	89 50 14             	mov    %edx,0x14(%eax)
  }
}
801011d0:	5d                   	pop    %ebp
801011d1:	c3                   	ret    
801011d2:	66 90                	xchg   %ax,%ax
801011d4:	66 90                	xchg   %ax,%ax
801011d6:	66 90                	xchg   %ax,%ax
801011d8:	66 90                	xchg   %ax,%ax
801011da:	66 90                	xchg   %ax,%ax
801011dc:	66 90                	xchg   %ax,%ax
801011de:	66 90                	xchg   %ax,%ax

801011e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011e0:	55                   	push   %ebp
801011e1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011e3:	89 d0                	mov    %edx,%eax
801011e5:	c1 e8 0c             	shr    $0xc,%eax
801011e8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ee:	89 e5                	mov    %esp,%ebp
801011f0:	56                   	push   %esi
801011f1:	53                   	push   %ebx
801011f2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011f4:	83 ec 08             	sub    $0x8,%esp
801011f7:	50                   	push   %eax
801011f8:	51                   	push   %ecx
801011f9:	e8 d2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011fe:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101200:	c1 fb 03             	sar    $0x3,%ebx
80101203:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101206:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101208:	83 e1 07             	and    $0x7,%ecx
8010120b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101210:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101216:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101218:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010121d:	85 c1                	test   %eax,%ecx
8010121f:	74 23                	je     80101244 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101221:	f7 d0                	not    %eax
  log_write(bp);
80101223:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101226:	21 c8                	and    %ecx,%eax
80101228:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010122c:	56                   	push   %esi
8010122d:	e8 2e 1d 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101232:	89 34 24             	mov    %esi,(%esp)
80101235:	e8 b6 ef ff ff       	call   801001f0 <brelse>
}
8010123a:	83 c4 10             	add    $0x10,%esp
8010123d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101240:	5b                   	pop    %ebx
80101241:	5e                   	pop    %esi
80101242:	5d                   	pop    %ebp
80101243:	c3                   	ret    
    panic("freeing free block");
80101244:	83 ec 0c             	sub    $0xc,%esp
80101247:	68 bf 7f 10 80       	push   $0x80107fbf
8010124c:	e8 2f f1 ff ff       	call   80100380 <panic>
80101251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010125f:	90                   	nop

80101260 <balloc>:
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101269:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010126f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101272:	85 c9                	test   %ecx,%ecx
80101274:	0f 84 87 00 00 00    	je     80101301 <balloc+0xa1>
8010127a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101281:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101284:	83 ec 08             	sub    $0x8,%esp
80101287:	89 f0                	mov    %esi,%eax
80101289:	c1 f8 0c             	sar    $0xc,%eax
8010128c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101292:	50                   	push   %eax
80101293:	ff 75 d8             	push   -0x28(%ebp)
80101296:	e8 35 ee ff ff       	call   801000d0 <bread>
8010129b:	83 c4 10             	add    $0x10,%esp
8010129e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012a1:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801012a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012a9:	31 c0                	xor    %eax,%eax
801012ab:	eb 2f                	jmp    801012dc <balloc+0x7c>
801012ad:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012b0:	89 c1                	mov    %eax,%ecx
801012b2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012ba:	83 e1 07             	and    $0x7,%ecx
801012bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012bf:	89 c1                	mov    %eax,%ecx
801012c1:	c1 f9 03             	sar    $0x3,%ecx
801012c4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012c9:	89 fa                	mov    %edi,%edx
801012cb:	85 df                	test   %ebx,%edi
801012cd:	74 41                	je     80101310 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012cf:	83 c0 01             	add    $0x1,%eax
801012d2:	83 c6 01             	add    $0x1,%esi
801012d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012da:	74 05                	je     801012e1 <balloc+0x81>
801012dc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012df:	77 cf                	ja     801012b0 <balloc+0x50>
    brelse(bp);
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	ff 75 e4             	push   -0x1c(%ebp)
801012e7:	e8 04 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012ec:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012f3:	83 c4 10             	add    $0x10,%esp
801012f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012f9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012ff:	77 80                	ja     80101281 <balloc+0x21>
  panic("balloc: out of blocks");
80101301:	83 ec 0c             	sub    $0xc,%esp
80101304:	68 d2 7f 10 80       	push   $0x80107fd2
80101309:	e8 72 f0 ff ff       	call   80100380 <panic>
8010130e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101310:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101313:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101316:	09 da                	or     %ebx,%edx
80101318:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010131c:	57                   	push   %edi
8010131d:	e8 3e 1c 00 00       	call   80102f60 <log_write>
        brelse(bp);
80101322:	89 3c 24             	mov    %edi,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010132a:	58                   	pop    %eax
8010132b:	5a                   	pop    %edx
8010132c:	56                   	push   %esi
8010132d:	ff 75 d8             	push   -0x28(%ebp)
80101330:	e8 9b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101335:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101338:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010133a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010133d:	68 00 02 00 00       	push   $0x200
80101342:	6a 00                	push   $0x0
80101344:	50                   	push   %eax
80101345:	e8 e6 34 00 00       	call   80104830 <memset>
  log_write(bp);
8010134a:	89 1c 24             	mov    %ebx,(%esp)
8010134d:	e8 0e 1c 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101352:	89 1c 24             	mov    %ebx,(%esp)
80101355:	e8 96 ee ff ff       	call   801001f0 <brelse>
}
8010135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135d:	89 f0                	mov    %esi,%eax
8010135f:	5b                   	pop    %ebx
80101360:	5e                   	pop    %esi
80101361:	5f                   	pop    %edi
80101362:	5d                   	pop    %ebp
80101363:	c3                   	ret    
80101364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010136f:	90                   	nop

80101370 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	89 c7                	mov    %eax,%edi
80101376:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101377:	31 f6                	xor    %esi,%esi
{
80101379:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010137f:	83 ec 28             	sub    $0x28,%esp
80101382:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101385:	68 60 09 11 80       	push   $0x80110960
8010138a:	e8 e1 33 00 00       	call   80104770 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101392:	83 c4 10             	add    $0x10,%esp
80101395:	eb 1b                	jmp    801013b2 <iget+0x42>
80101397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010139e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a0:	39 3b                	cmp    %edi,(%ebx)
801013a2:	74 6c                	je     80101410 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013aa:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013b0:	73 26                	jae    801013d8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013b2:	8b 43 08             	mov    0x8(%ebx),%eax
801013b5:	85 c0                	test   %eax,%eax
801013b7:	7f e7                	jg     801013a0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013b9:	85 f6                	test   %esi,%esi
801013bb:	75 e7                	jne    801013a4 <iget+0x34>
801013bd:	85 c0                	test   %eax,%eax
801013bf:	75 76                	jne    80101437 <iget+0xc7>
801013c1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013c3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013c9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013cf:	72 e1                	jb     801013b2 <iget+0x42>
801013d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013d8:	85 f6                	test   %esi,%esi
801013da:	74 79                	je     80101455 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013dc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013df:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013e1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013e4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013eb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013f2:	68 60 09 11 80       	push   $0x80110960
801013f7:	e8 14 33 00 00       	call   80104710 <release>

  return ip;
801013fc:	83 c4 10             	add    $0x10,%esp
}
801013ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101402:	89 f0                	mov    %esi,%eax
80101404:	5b                   	pop    %ebx
80101405:	5e                   	pop    %esi
80101406:	5f                   	pop    %edi
80101407:	5d                   	pop    %ebp
80101408:	c3                   	ret    
80101409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101410:	39 53 04             	cmp    %edx,0x4(%ebx)
80101413:	75 8f                	jne    801013a4 <iget+0x34>
      release(&icache.lock);
80101415:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101418:	83 c0 01             	add    $0x1,%eax
      return ip;
8010141b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010141d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101422:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101425:	e8 e6 32 00 00       	call   80104710 <release>
      return ip;
8010142a:	83 c4 10             	add    $0x10,%esp
}
8010142d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101430:	89 f0                	mov    %esi,%eax
80101432:	5b                   	pop    %ebx
80101433:	5e                   	pop    %esi
80101434:	5f                   	pop    %edi
80101435:	5d                   	pop    %ebp
80101436:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101437:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010143d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101443:	73 10                	jae    80101455 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101445:	8b 43 08             	mov    0x8(%ebx),%eax
80101448:	85 c0                	test   %eax,%eax
8010144a:	0f 8f 50 ff ff ff    	jg     801013a0 <iget+0x30>
80101450:	e9 68 ff ff ff       	jmp    801013bd <iget+0x4d>
    panic("iget: no inodes");
80101455:	83 ec 0c             	sub    $0xc,%esp
80101458:	68 e8 7f 10 80       	push   $0x80107fe8
8010145d:	e8 1e ef ff ff       	call   80100380 <panic>
80101462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret    
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 86 fd ff ff       	call   80101260 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 76 1a 00 00       	call   80102f60 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 61 fd ff ff       	call   80101260 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 3e fd ff ff       	call   80101260 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret    
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 f8 7f 10 80       	push   $0x80107ff8
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 6a 33 00 00       	call   801048d0 <memmove>
  brelse(bp);
80101566:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101569:	83 c4 10             	add    $0x10,%esp
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010157e:	66 90                	xchg   %ax,%ax

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 0b 80 10 80       	push   $0x8010800b
80101591:	68 60 09 11 80       	push   $0x80110960
80101596:	e8 05 30 00 00       	call   801045a0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 12 80 10 80       	push   $0x80108012
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 bc 2e 00 00       	call   80104470 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 25 11 80       	push   $0x801125b4
801015dc:	e8 ef 32 00 00       	call   801048d0 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 25 11 80    	push   0x801125cc
801015ef:	ff 35 c8 25 11 80    	push   0x801125c8
801015f5:	ff 35 c4 25 11 80    	push   0x801125c4
801015fb:	ff 35 c0 25 11 80    	push   0x801125c0
80101601:	ff 35 bc 25 11 80    	push   0x801125bc
80101607:	ff 35 b8 25 11 80    	push   0x801125b8
8010160d:	ff 35 b4 25 11 80    	push   0x801125b4
80101613:	68 78 80 10 80       	push   $0x80108078
80101618:	e8 83 f0 ff ff       	call   801006a0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave  
80101624:	c3                   	ret    
80101625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010162c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010165d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016a9:	6a 40                	push   $0x40
801016ab:	6a 00                	push   $0x0
801016ad:	51                   	push   %ecx
801016ae:	e8 7d 31 00 00       	call   80104830 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 9b 18 00 00       	call   80102f60 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 90 fc ff ff       	jmp    80101370 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 18 80 10 80       	push   $0x80108018
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 7a 31 00 00       	call   801048d0 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 02 18 00 00       	call   80102f60 <log_write>
  brelse(bp);
8010175e:	89 75 08             	mov    %esi,0x8(%ebp)
80101761:	83 c4 10             	add    $0x10,%esp
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 09 11 80       	push   $0x80110960
8010177f:	e8 ec 2f 00 00       	call   80104770 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010178f:	e8 7c 2f 00 00       	call   80104710 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave  
8010179a:	c3                   	ret    
8010179b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010179f:	90                   	nop

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 e9 2c 00 00       	call   801044b0 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret    
801017d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017df:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 93 30 00 00       	call   801048d0 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 30 80 10 80       	push   $0x80108030
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 2a 80 10 80       	push   $0x8010802a
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010187b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010187f:	90                   	nop

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 b8 2c 00 00       	call   80104550 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 5c 2c 00 00       	jmp    80104510 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 3f 80 10 80       	push   $0x8010803f
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 cb 2b 00 00       	call   801044b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 11 2c 00 00       	call   80104510 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101906:	e8 65 2e 00 00       	call   80104770 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 eb 2d 00 00       	jmp    80104710 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 09 11 80       	push   $0x80110960
80101930:	e8 3b 2e 00 00       	call   80104770 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010193f:	e8 cc 2d 00 00       	call   80104710 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 cf                	mov    %ecx,%edi
8010195a:	eb 0b                	jmp    80101967 <iput+0x97>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 fe                	cmp    %edi,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 03                	mov    (%ebx),%eax
8010196f:	e8 6c f8 ff ff       	call   801011e0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101986:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101989:	85 c0                	test   %eax,%eax
8010198b:	75 2d                	jne    801019ba <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101990:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101997:	53                   	push   %ebx
80101998:	e8 53 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199d:	31 c0                	xor    %eax,%eax
8010199f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a3:	89 1c 24             	mov    %ebx,(%esp)
801019a6:	e8 45 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ab:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b2:	83 c4 10             	add    $0x10,%esp
801019b5:	e9 3c ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019ba:	83 ec 08             	sub    $0x8,%esp
801019bd:	50                   	push   %eax
801019be:	ff 33                	push   (%ebx)
801019c0:	e8 0b e7 ff ff       	call   801000d0 <bread>
801019c5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019c8:	83 c4 10             	add    $0x10,%esp
801019cb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019d4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d7:	89 cf                	mov    %ecx,%edi
801019d9:	eb 0c                	jmp    801019e7 <iput+0x117>
801019db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019df:	90                   	nop
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 f7                	cmp    %esi,%edi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 ec f7 ff ff       	call   801011e0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	83 ec 0c             	sub    $0xc,%esp
801019f9:	ff 75 e4             	push   -0x1c(%ebp)
801019fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ff:	e8 ec e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a04:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0a:	8b 03                	mov    (%ebx),%eax
80101a0c:	e8 cf f7 ff ff       	call   801011e0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a11:	83 c4 10             	add    $0x10,%esp
80101a14:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1b:	00 00 00 
80101a1e:	e9 6a ff ff ff       	jmp    8010198d <iput+0xbd>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 08 2b 00 00       	call   80104550 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 b1 2a 00 00       	call   80104510 <releasesleep>
  iput(ip);
80101a5f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a62:	83 c4 10             	add    $0x10,%esp
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 3f 80 10 80       	push   $0x8010803f
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret    
80101aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aaf:	90                   	nop

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ac5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ad0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ad3:	0f 84 a7 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101adc:	8b 40 58             	mov    0x58(%eax),%eax
80101adf:	39 c6                	cmp    %eax,%esi
80101ae1:	0f 87 ba 00 00 00    	ja     80101ba1 <readi+0xf1>
80101ae7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aea:	31 c9                	xor    %ecx,%ecx
80101aec:	89 da                	mov    %ebx,%edx
80101aee:	01 f2                	add    %esi,%edx
80101af0:	0f 92 c1             	setb   %cl
80101af3:	89 cf                	mov    %ecx,%edi
80101af5:	0f 82 a6 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101afb:	89 c1                	mov    %eax,%ecx
80101afd:	29 f1                	sub    %esi,%ecx
80101aff:	39 d0                	cmp    %edx,%eax
80101b01:	0f 43 cb             	cmovae %ebx,%ecx
80101b04:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b07:	85 c9                	test   %ecx,%ecx
80101b09:	74 67                	je     80101b72 <readi+0xc2>
80101b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 f2                	mov    %esi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f0                	mov    %esi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b40:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b42:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b46:	39 d9                	cmp    %ebx,%ecx
80101b48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b4b:	83 c4 0c             	add    $0xc,%esp
80101b4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	01 df                	add    %ebx,%edi
80101b51:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 74 2d 00 00       	call   801048d0 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	83 c4 10             	add    $0x10,%esp
80101b6d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b70:	77 9e                	ja     80101b10 <readi+0x60>
  }
  return n;
80101b72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b78:	5b                   	pop    %ebx
80101b79:	5e                   	pop    %esi
80101b7a:	5f                   	pop    %edi
80101b7b:	5d                   	pop    %ebp
80101b7c:	c3                   	ret    
80101b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e0                	jmp    *%eax
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb cd                	jmp    80101b75 <readi+0xc5>
80101ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101baf:	90                   	nop

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bbf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bcd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bd0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bd3:	0f 84 b7 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bdf:	0f 87 e7 00 00 00    	ja     80101ccc <writei+0x11c>
80101be5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101be8:	31 d2                	xor    %edx,%edx
80101bea:	89 f8                	mov    %edi,%eax
80101bec:	01 f0                	add    %esi,%eax
80101bee:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bf1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bf6:	0f 87 d0 00 00 00    	ja     80101ccc <writei+0x11c>
80101bfc:	85 d2                	test   %edx,%edx
80101bfe:	0f 85 c8 00 00 00    	jne    80101ccc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c0b:	85 ff                	test   %edi,%edi
80101c0d:	74 72                	je     80101c81 <writei+0xd1>
80101c0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c13:	89 f2                	mov    %esi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f8                	mov    %edi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 37                	push   (%edi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c2f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c32:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f0                	mov    %esi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c40:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c44:	39 d9                	cmp    %ebx,%ecx
80101c46:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c49:	83 c4 0c             	add    $0xc,%esp
80101c4c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c4f:	ff 75 dc             	push   -0x24(%ebp)
80101c52:	50                   	push   %eax
80101c53:	e8 78 2c 00 00       	call   801048d0 <memmove>
    log_write(bp);
80101c58:	89 3c 24             	mov    %edi,(%esp)
80101c5b:	e8 00 13 00 00       	call   80102f60 <log_write>
    brelse(bp);
80101c60:	89 3c 24             	mov    %edi,(%esp)
80101c63:	e8 88 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c68:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6b:	83 c4 10             	add    $0x10,%esp
80101c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c71:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c74:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c77:	77 97                	ja     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c7c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c7f:	77 37                	ja     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c87:	5b                   	pop    %ebx
80101c88:	5e                   	pop    %esi
80101c89:	5f                   	pop    %edi
80101c8a:	5d                   	pop    %ebp
80101c8b:	c3                   	ret    
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 32                	ja     80101ccc <writei+0x11c>
80101c9a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 27                	je     80101ccc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cbb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cc1:	50                   	push   %eax
80101cc2:	e8 29 fa ff ff       	call   801016f0 <iupdate>
80101cc7:	83 c4 10             	add    $0x10,%esp
80101cca:	eb b5                	jmp    80101c81 <writei+0xd1>
      return -1;
80101ccc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cd1:	eb b1                	jmp    80101c84 <writei+0xd4>
80101cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ce0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ce6:	6a 0e                	push   $0xe
80101ce8:	ff 75 0c             	push   0xc(%ebp)
80101ceb:	ff 75 08             	push   0x8(%ebp)
80101cee:	e8 4d 2c 00 00       	call   80104940 <strncmp>
}
80101cf3:	c9                   	leave  
80101cf4:	c3                   	ret    
80101cf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d00 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	83 ec 1c             	sub    $0x1c,%esp
80101d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d0c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d11:	0f 85 85 00 00 00    	jne    80101d9c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d17:	8b 53 58             	mov    0x58(%ebx),%edx
80101d1a:	31 ff                	xor    %edi,%edi
80101d1c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d1f:	85 d2                	test   %edx,%edx
80101d21:	74 3e                	je     80101d61 <dirlookup+0x61>
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d28:	6a 10                	push   $0x10
80101d2a:	57                   	push   %edi
80101d2b:	56                   	push   %esi
80101d2c:	53                   	push   %ebx
80101d2d:	e8 7e fd ff ff       	call   80101ab0 <readi>
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	83 f8 10             	cmp    $0x10,%eax
80101d38:	75 55                	jne    80101d8f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d3f:	74 18                	je     80101d59 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d41:	83 ec 04             	sub    $0x4,%esp
80101d44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d47:	6a 0e                	push   $0xe
80101d49:	50                   	push   %eax
80101d4a:	ff 75 0c             	push   0xc(%ebp)
80101d4d:	e8 ee 2b 00 00       	call   80104940 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d52:	83 c4 10             	add    $0x10,%esp
80101d55:	85 c0                	test   %eax,%eax
80101d57:	74 17                	je     80101d70 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d59:	83 c7 10             	add    $0x10,%edi
80101d5c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d5f:	72 c7                	jb     80101d28 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d64:	31 c0                	xor    %eax,%eax
}
80101d66:	5b                   	pop    %ebx
80101d67:	5e                   	pop    %esi
80101d68:	5f                   	pop    %edi
80101d69:	5d                   	pop    %ebp
80101d6a:	c3                   	ret    
80101d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop
      if(poff)
80101d70:	8b 45 10             	mov    0x10(%ebp),%eax
80101d73:	85 c0                	test   %eax,%eax
80101d75:	74 05                	je     80101d7c <dirlookup+0x7c>
        *poff = off;
80101d77:	8b 45 10             	mov    0x10(%ebp),%eax
80101d7a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d7c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d80:	8b 03                	mov    (%ebx),%eax
80101d82:	e8 e9 f5 ff ff       	call   80101370 <iget>
}
80101d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d8a:	5b                   	pop    %ebx
80101d8b:	5e                   	pop    %esi
80101d8c:	5f                   	pop    %edi
80101d8d:	5d                   	pop    %ebp
80101d8e:	c3                   	ret    
      panic("dirlookup read");
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	68 59 80 10 80       	push   $0x80108059
80101d97:	e8 e4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d9c:	83 ec 0c             	sub    $0xc,%esp
80101d9f:	68 47 80 10 80       	push   $0x80108047
80101da4:	e8 d7 e5 ff ff       	call   80100380 <panic>
80101da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101db0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	89 c3                	mov    %eax,%ebx
80101db8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dbb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dbe:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101dc4:	0f 84 64 01 00 00    	je     80101f2e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dca:	e8 d1 1b 00 00       	call   801039a0 <myproc>
  acquire(&icache.lock);
80101dcf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dd2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dd5:	68 60 09 11 80       	push   $0x80110960
80101dda:	e8 91 29 00 00       	call   80104770 <acquire>
  ip->ref++;
80101ddf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101de3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dea:	e8 21 29 00 00       	call   80104710 <release>
80101def:	83 c4 10             	add    $0x10,%esp
80101df2:	eb 07                	jmp    80101dfb <namex+0x4b>
80101df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101df8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101dfb:	0f b6 03             	movzbl (%ebx),%eax
80101dfe:	3c 2f                	cmp    $0x2f,%al
80101e00:	74 f6                	je     80101df8 <namex+0x48>
  if(*path == 0)
80101e02:	84 c0                	test   %al,%al
80101e04:	0f 84 06 01 00 00    	je     80101f10 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e0a:	0f b6 03             	movzbl (%ebx),%eax
80101e0d:	84 c0                	test   %al,%al
80101e0f:	0f 84 10 01 00 00    	je     80101f25 <namex+0x175>
80101e15:	89 df                	mov    %ebx,%edi
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	0f 84 06 01 00 00    	je     80101f25 <namex+0x175>
80101e1f:	90                   	nop
80101e20:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e24:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e27:	3c 2f                	cmp    $0x2f,%al
80101e29:	74 04                	je     80101e2f <namex+0x7f>
80101e2b:	84 c0                	test   %al,%al
80101e2d:	75 f1                	jne    80101e20 <namex+0x70>
  len = path - s;
80101e2f:	89 f8                	mov    %edi,%eax
80101e31:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e33:	83 f8 0d             	cmp    $0xd,%eax
80101e36:	0f 8e ac 00 00 00    	jle    80101ee8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e3c:	83 ec 04             	sub    $0x4,%esp
80101e3f:	6a 0e                	push   $0xe
80101e41:	53                   	push   %ebx
    path++;
80101e42:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e44:	ff 75 e4             	push   -0x1c(%ebp)
80101e47:	e8 84 2a 00 00       	call   801048d0 <memmove>
80101e4c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e4f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e52:	75 0c                	jne    80101e60 <namex+0xb0>
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e5b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e5e:	74 f8                	je     80101e58 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e60:	83 ec 0c             	sub    $0xc,%esp
80101e63:	56                   	push   %esi
80101e64:	e8 37 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e69:	83 c4 10             	add    $0x10,%esp
80101e6c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e71:	0f 85 cd 00 00 00    	jne    80101f44 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 09                	je     80101e87 <namex+0xd7>
80101e7e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e81:	0f 84 22 01 00 00    	je     80101fa9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e87:	83 ec 04             	sub    $0x4,%esp
80101e8a:	6a 00                	push   $0x0
80101e8c:	ff 75 e4             	push   -0x1c(%ebp)
80101e8f:	56                   	push   %esi
80101e90:	e8 6b fe ff ff       	call   80101d00 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e98:	83 c4 10             	add    $0x10,%esp
80101e9b:	89 c7                	mov    %eax,%edi
80101e9d:	85 c0                	test   %eax,%eax
80101e9f:	0f 84 e1 00 00 00    	je     80101f86 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101eab:	52                   	push   %edx
80101eac:	e8 9f 26 00 00       	call   80104550 <holdingsleep>
80101eb1:	83 c4 10             	add    $0x10,%esp
80101eb4:	85 c0                	test   %eax,%eax
80101eb6:	0f 84 30 01 00 00    	je     80101fec <namex+0x23c>
80101ebc:	8b 56 08             	mov    0x8(%esi),%edx
80101ebf:	85 d2                	test   %edx,%edx
80101ec1:	0f 8e 25 01 00 00    	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101ec7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eca:	83 ec 0c             	sub    $0xc,%esp
80101ecd:	52                   	push   %edx
80101ece:	e8 3d 26 00 00       	call   80104510 <releasesleep>
  iput(ip);
80101ed3:	89 34 24             	mov    %esi,(%esp)
80101ed6:	89 fe                	mov    %edi,%esi
80101ed8:	e8 f3 f9 ff ff       	call   801018d0 <iput>
80101edd:	83 c4 10             	add    $0x10,%esp
80101ee0:	e9 16 ff ff ff       	jmp    80101dfb <namex+0x4b>
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ee8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101eeb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101eee:	83 ec 04             	sub    $0x4,%esp
80101ef1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ef4:	50                   	push   %eax
80101ef5:	53                   	push   %ebx
    name[len] = 0;
80101ef6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ef8:	ff 75 e4             	push   -0x1c(%ebp)
80101efb:	e8 d0 29 00 00       	call   801048d0 <memmove>
    name[len] = 0;
80101f00:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f03:	83 c4 10             	add    $0x10,%esp
80101f06:	c6 02 00             	movb   $0x0,(%edx)
80101f09:	e9 41 ff ff ff       	jmp    80101e4f <namex+0x9f>
80101f0e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f10:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f13:	85 c0                	test   %eax,%eax
80101f15:	0f 85 be 00 00 00    	jne    80101fd9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1e:	89 f0                	mov    %esi,%eax
80101f20:	5b                   	pop    %ebx
80101f21:	5e                   	pop    %esi
80101f22:	5f                   	pop    %edi
80101f23:	5d                   	pop    %ebp
80101f24:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f28:	89 df                	mov    %ebx,%edi
80101f2a:	31 c0                	xor    %eax,%eax
80101f2c:	eb c0                	jmp    80101eee <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f2e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f33:	b8 01 00 00 00       	mov    $0x1,%eax
80101f38:	e8 33 f4 ff ff       	call   80101370 <iget>
80101f3d:	89 c6                	mov    %eax,%esi
80101f3f:	e9 b7 fe ff ff       	jmp    80101dfb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f44:	83 ec 0c             	sub    $0xc,%esp
80101f47:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f4a:	53                   	push   %ebx
80101f4b:	e8 00 26 00 00       	call   80104550 <holdingsleep>
80101f50:	83 c4 10             	add    $0x10,%esp
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 84 91 00 00 00    	je     80101fec <namex+0x23c>
80101f5b:	8b 46 08             	mov    0x8(%esi),%eax
80101f5e:	85 c0                	test   %eax,%eax
80101f60:	0f 8e 86 00 00 00    	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	53                   	push   %ebx
80101f6a:	e8 a1 25 00 00       	call   80104510 <releasesleep>
  iput(ip);
80101f6f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f72:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f74:	e8 57 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f79:	83 c4 10             	add    $0x10,%esp
}
80101f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7f:	89 f0                	mov    %esi,%eax
80101f81:	5b                   	pop    %ebx
80101f82:	5e                   	pop    %esi
80101f83:	5f                   	pop    %edi
80101f84:	5d                   	pop    %ebp
80101f85:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f86:	83 ec 0c             	sub    $0xc,%esp
80101f89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f8c:	52                   	push   %edx
80101f8d:	e8 be 25 00 00       	call   80104550 <holdingsleep>
80101f92:	83 c4 10             	add    $0x10,%esp
80101f95:	85 c0                	test   %eax,%eax
80101f97:	74 53                	je     80101fec <namex+0x23c>
80101f99:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f9c:	85 c9                	test   %ecx,%ecx
80101f9e:	7e 4c                	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101fa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	52                   	push   %edx
80101fa7:	eb c1                	jmp    80101f6a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fa9:	83 ec 0c             	sub    $0xc,%esp
80101fac:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101faf:	53                   	push   %ebx
80101fb0:	e8 9b 25 00 00       	call   80104550 <holdingsleep>
80101fb5:	83 c4 10             	add    $0x10,%esp
80101fb8:	85 c0                	test   %eax,%eax
80101fba:	74 30                	je     80101fec <namex+0x23c>
80101fbc:	8b 7e 08             	mov    0x8(%esi),%edi
80101fbf:	85 ff                	test   %edi,%edi
80101fc1:	7e 29                	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101fc3:	83 ec 0c             	sub    $0xc,%esp
80101fc6:	53                   	push   %ebx
80101fc7:	e8 44 25 00 00       	call   80104510 <releasesleep>
}
80101fcc:	83 c4 10             	add    $0x10,%esp
}
80101fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd2:	89 f0                	mov    %esi,%eax
80101fd4:	5b                   	pop    %ebx
80101fd5:	5e                   	pop    %esi
80101fd6:	5f                   	pop    %edi
80101fd7:	5d                   	pop    %ebp
80101fd8:	c3                   	ret    
    iput(ip);
80101fd9:	83 ec 0c             	sub    $0xc,%esp
80101fdc:	56                   	push   %esi
    return 0;
80101fdd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fdf:	e8 ec f8 ff ff       	call   801018d0 <iput>
    return 0;
80101fe4:	83 c4 10             	add    $0x10,%esp
80101fe7:	e9 2f ff ff ff       	jmp    80101f1b <namex+0x16b>
    panic("iunlock");
80101fec:	83 ec 0c             	sub    $0xc,%esp
80101fef:	68 3f 80 10 80       	push   $0x8010803f
80101ff4:	e8 87 e3 ff ff       	call   80100380 <panic>
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102000 <dirlink>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 20             	sub    $0x20,%esp
80102009:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010200c:	6a 00                	push   $0x0
8010200e:	ff 75 0c             	push   0xc(%ebp)
80102011:	53                   	push   %ebx
80102012:	e8 e9 fc ff ff       	call   80101d00 <dirlookup>
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
8010201c:	75 67                	jne    80102085 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010201e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102021:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102024:	85 ff                	test   %edi,%edi
80102026:	74 29                	je     80102051 <dirlink+0x51>
80102028:	31 ff                	xor    %edi,%edi
8010202a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010202d:	eb 09                	jmp    80102038 <dirlink+0x38>
8010202f:	90                   	nop
80102030:	83 c7 10             	add    $0x10,%edi
80102033:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102036:	73 19                	jae    80102051 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102038:	6a 10                	push   $0x10
8010203a:	57                   	push   %edi
8010203b:	56                   	push   %esi
8010203c:	53                   	push   %ebx
8010203d:	e8 6e fa ff ff       	call   80101ab0 <readi>
80102042:	83 c4 10             	add    $0x10,%esp
80102045:	83 f8 10             	cmp    $0x10,%eax
80102048:	75 4e                	jne    80102098 <dirlink+0x98>
    if(de.inum == 0)
8010204a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010204f:	75 df                	jne    80102030 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102051:	83 ec 04             	sub    $0x4,%esp
80102054:	8d 45 da             	lea    -0x26(%ebp),%eax
80102057:	6a 0e                	push   $0xe
80102059:	ff 75 0c             	push   0xc(%ebp)
8010205c:	50                   	push   %eax
8010205d:	e8 2e 29 00 00       	call   80104990 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102062:	6a 10                	push   $0x10
  de.inum = inum;
80102064:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102067:	57                   	push   %edi
80102068:	56                   	push   %esi
80102069:	53                   	push   %ebx
  de.inum = inum;
8010206a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010206e:	e8 3d fb ff ff       	call   80101bb0 <writei>
80102073:	83 c4 20             	add    $0x20,%esp
80102076:	83 f8 10             	cmp    $0x10,%eax
80102079:	75 2a                	jne    801020a5 <dirlink+0xa5>
  return 0;
8010207b:	31 c0                	xor    %eax,%eax
}
8010207d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102080:	5b                   	pop    %ebx
80102081:	5e                   	pop    %esi
80102082:	5f                   	pop    %edi
80102083:	5d                   	pop    %ebp
80102084:	c3                   	ret    
    iput(ip);
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	50                   	push   %eax
80102089:	e8 42 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010208e:	83 c4 10             	add    $0x10,%esp
80102091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102096:	eb e5                	jmp    8010207d <dirlink+0x7d>
      panic("dirlink read");
80102098:	83 ec 0c             	sub    $0xc,%esp
8010209b:	68 68 80 10 80       	push   $0x80108068
801020a0:	e8 db e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020a5:	83 ec 0c             	sub    $0xc,%esp
801020a8:	68 52 86 10 80       	push   $0x80108652
801020ad:	e8 ce e2 ff ff       	call   80100380 <panic>
801020b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020c0 <namei>:

struct inode*
namei(char *path)
{
801020c0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020c1:	31 d2                	xor    %edx,%edx
{
801020c3:	89 e5                	mov    %esp,%ebp
801020c5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020c8:	8b 45 08             	mov    0x8(%ebp),%eax
801020cb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ce:	e8 dd fc ff ff       	call   80101db0 <namex>
}
801020d3:	c9                   	leave  
801020d4:	c3                   	ret    
801020d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020e0:	55                   	push   %ebp
  return namex(path, 1, name);
801020e1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020e6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ee:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020ef:	e9 bc fc ff ff       	jmp    80101db0 <namex>
801020f4:	66 90                	xchg   %ax,%ax
801020f6:	66 90                	xchg   %ax,%ax
801020f8:	66 90                	xchg   %ax,%ax
801020fa:	66 90                	xchg   %ax,%ax
801020fc:	66 90                	xchg   %ax,%ax
801020fe:	66 90                	xchg   %ax,%ax

80102100 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102109:	85 c0                	test   %eax,%eax
8010210b:	0f 84 b4 00 00 00    	je     801021c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102111:	8b 70 08             	mov    0x8(%eax),%esi
80102114:	89 c3                	mov    %eax,%ebx
80102116:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010211c:	0f 87 96 00 00 00    	ja     801021b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102122:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010212e:	66 90                	xchg   %ax,%ax
80102130:	89 ca                	mov    %ecx,%edx
80102132:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102133:	83 e0 c0             	and    $0xffffffc0,%eax
80102136:	3c 40                	cmp    $0x40,%al
80102138:	75 f6                	jne    80102130 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010213a:	31 ff                	xor    %edi,%edi
8010213c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102141:	89 f8                	mov    %edi,%eax
80102143:	ee                   	out    %al,(%dx)
80102144:	b8 01 00 00 00       	mov    $0x1,%eax
80102149:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010214e:	ee                   	out    %al,(%dx)
8010214f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102154:	89 f0                	mov    %esi,%eax
80102156:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102157:	89 f0                	mov    %esi,%eax
80102159:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010215e:	c1 f8 08             	sar    $0x8,%eax
80102161:	ee                   	out    %al,(%dx)
80102162:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102167:	89 f8                	mov    %edi,%eax
80102169:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010216a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010216e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102173:	c1 e0 04             	shl    $0x4,%eax
80102176:	83 e0 10             	and    $0x10,%eax
80102179:	83 c8 e0             	or     $0xffffffe0,%eax
8010217c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010217d:	f6 03 04             	testb  $0x4,(%ebx)
80102180:	75 16                	jne    80102198 <idestart+0x98>
80102182:	b8 20 00 00 00       	mov    $0x20,%eax
80102187:	89 ca                	mov    %ecx,%edx
80102189:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010218a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218d:	5b                   	pop    %ebx
8010218e:	5e                   	pop    %esi
8010218f:	5f                   	pop    %edi
80102190:	5d                   	pop    %ebp
80102191:	c3                   	ret    
80102192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102198:	b8 30 00 00 00       	mov    $0x30,%eax
8010219d:	89 ca                	mov    %ecx,%edx
8010219f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ad:	fc                   	cld    
801021ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b3:	5b                   	pop    %ebx
801021b4:	5e                   	pop    %esi
801021b5:	5f                   	pop    %edi
801021b6:	5d                   	pop    %ebp
801021b7:	c3                   	ret    
    panic("incorrect blockno");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 d4 80 10 80       	push   $0x801080d4
801021c0:	e8 bb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	68 cb 80 10 80       	push   $0x801080cb
801021cd:	e8 ae e1 ff ff       	call   80100380 <panic>
801021d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021e0 <ideinit>:
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021e6:	68 e6 80 10 80       	push   $0x801080e6
801021eb:	68 00 26 11 80       	push   $0x80112600
801021f0:	e8 ab 23 00 00       	call   801045a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021f5:	58                   	pop    %eax
801021f6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021fb:	5a                   	pop    %edx
801021fc:	83 e8 01             	sub    $0x1,%eax
801021ff:	50                   	push   %eax
80102200:	6a 0e                	push   $0xe
80102202:	e8 99 02 00 00       	call   801024a0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102207:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010220a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220f:	90                   	nop
80102210:	ec                   	in     (%dx),%al
80102211:	83 e0 c0             	and    $0xffffffc0,%eax
80102214:	3c 40                	cmp    $0x40,%al
80102216:	75 f8                	jne    80102210 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102218:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010221d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102222:	ee                   	out    %al,(%dx)
80102223:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102228:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222d:	eb 06                	jmp    80102235 <ideinit+0x55>
8010222f:	90                   	nop
  for(i=0; i<1000; i++){
80102230:	83 e9 01             	sub    $0x1,%ecx
80102233:	74 0f                	je     80102244 <ideinit+0x64>
80102235:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102236:	84 c0                	test   %al,%al
80102238:	74 f6                	je     80102230 <ideinit+0x50>
      havedisk1 = 1;
8010223a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102241:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102244:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102249:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010224e:	ee                   	out    %al,(%dx)
}
8010224f:	c9                   	leave  
80102250:	c3                   	ret    
80102251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010225f:	90                   	nop

80102260 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	57                   	push   %edi
80102264:	56                   	push   %esi
80102265:	53                   	push   %ebx
80102266:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102269:	68 00 26 11 80       	push   $0x80112600
8010226e:	e8 fd 24 00 00       	call   80104770 <acquire>

  if((b = idequeue) == 0){
80102273:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102279:	83 c4 10             	add    $0x10,%esp
8010227c:	85 db                	test   %ebx,%ebx
8010227e:	74 63                	je     801022e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102280:	8b 43 58             	mov    0x58(%ebx),%eax
80102283:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102288:	8b 33                	mov    (%ebx),%esi
8010228a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102290:	75 2f                	jne    801022c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102292:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229e:	66 90                	xchg   %ax,%ax
801022a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022a1:	89 c1                	mov    %eax,%ecx
801022a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022a6:	80 f9 40             	cmp    $0x40,%cl
801022a9:	75 f5                	jne    801022a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022ab:	a8 21                	test   $0x21,%al
801022ad:	75 12                	jne    801022c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022bc:	fc                   	cld    
801022bd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022bf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022c7:	83 ce 02             	or     $0x2,%esi
801022ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022cc:	53                   	push   %ebx
801022cd:	e8 fe 1f 00 00       	call   801042d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022d2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022d7:	83 c4 10             	add    $0x10,%esp
801022da:	85 c0                	test   %eax,%eax
801022dc:	74 05                	je     801022e3 <ideintr+0x83>
    idestart(idequeue);
801022de:	e8 1d fe ff ff       	call   80102100 <idestart>
    release(&idelock);
801022e3:	83 ec 0c             	sub    $0xc,%esp
801022e6:	68 00 26 11 80       	push   $0x80112600
801022eb:	e8 20 24 00 00       	call   80104710 <release>

  release(&idelock);
}
801022f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022f3:	5b                   	pop    %ebx
801022f4:	5e                   	pop    %esi
801022f5:	5f                   	pop    %edi
801022f6:	5d                   	pop    %ebp
801022f7:	c3                   	ret    
801022f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ff:	90                   	nop

80102300 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 10             	sub    $0x10,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010230a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010230d:	50                   	push   %eax
8010230e:	e8 3d 22 00 00       	call   80104550 <holdingsleep>
80102313:	83 c4 10             	add    $0x10,%esp
80102316:	85 c0                	test   %eax,%eax
80102318:	0f 84 c3 00 00 00    	je     801023e1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 e0 06             	and    $0x6,%eax
80102323:	83 f8 02             	cmp    $0x2,%eax
80102326:	0f 84 a8 00 00 00    	je     801023d4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010232c:	8b 53 04             	mov    0x4(%ebx),%edx
8010232f:	85 d2                	test   %edx,%edx
80102331:	74 0d                	je     80102340 <iderw+0x40>
80102333:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102338:	85 c0                	test   %eax,%eax
8010233a:	0f 84 87 00 00 00    	je     801023c7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 00 26 11 80       	push   $0x80112600
80102348:	e8 23 24 00 00       	call   80104770 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010234d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102352:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102359:	83 c4 10             	add    $0x10,%esp
8010235c:	85 c0                	test   %eax,%eax
8010235e:	74 60                	je     801023c0 <iderw+0xc0>
80102360:	89 c2                	mov    %eax,%edx
80102362:	8b 40 58             	mov    0x58(%eax),%eax
80102365:	85 c0                	test   %eax,%eax
80102367:	75 f7                	jne    80102360 <iderw+0x60>
80102369:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010236c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010236e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102374:	74 3a                	je     801023b0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102376:	8b 03                	mov    (%ebx),%eax
80102378:	83 e0 06             	and    $0x6,%eax
8010237b:	83 f8 02             	cmp    $0x2,%eax
8010237e:	74 1b                	je     8010239b <iderw+0x9b>
    sleep(b, &idelock);
80102380:	83 ec 08             	sub    $0x8,%esp
80102383:	68 00 26 11 80       	push   $0x80112600
80102388:	53                   	push   %ebx
80102389:	e8 82 1e 00 00       	call   80104210 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 c4 10             	add    $0x10,%esp
80102393:	83 e0 06             	and    $0x6,%eax
80102396:	83 f8 02             	cmp    $0x2,%eax
80102399:	75 e5                	jne    80102380 <iderw+0x80>
  }


  release(&idelock);
8010239b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
801023a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023a5:	c9                   	leave  
  release(&idelock);
801023a6:	e9 65 23 00 00       	jmp    80104710 <release>
801023ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023af:	90                   	nop
    idestart(b);
801023b0:	89 d8                	mov    %ebx,%eax
801023b2:	e8 49 fd ff ff       	call   80102100 <idestart>
801023b7:	eb bd                	jmp    80102376 <iderw+0x76>
801023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023c5:	eb a5                	jmp    8010236c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023c7:	83 ec 0c             	sub    $0xc,%esp
801023ca:	68 15 81 10 80       	push   $0x80108115
801023cf:	e8 ac df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 00 81 10 80       	push   $0x80108100
801023dc:	e8 9f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023e1:	83 ec 0c             	sub    $0xc,%esp
801023e4:	68 ea 80 10 80       	push   $0x801080ea
801023e9:	e8 92 df ff ff       	call   80100380 <panic>
801023ee:	66 90                	xchg   %ax,%ax

801023f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023f1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023f8:	00 c0 fe 
{
801023fb:	89 e5                	mov    %esp,%ebp
801023fd:	56                   	push   %esi
801023fe:	53                   	push   %ebx
  ioapic->reg = reg;
801023ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102406:	00 00 00 
  return ioapic->data;
80102409:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010240f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102412:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102418:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010241e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102425:	c1 ee 10             	shr    $0x10,%esi
80102428:	89 f0                	mov    %esi,%eax
8010242a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010242d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102430:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102433:	39 c2                	cmp    %eax,%edx
80102435:	74 16                	je     8010244d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 34 81 10 80       	push   $0x80108134
8010243f:	e8 5c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010244a:	83 c4 10             	add    $0x10,%esp
8010244d:	83 c6 21             	add    $0x21,%esi
{
80102450:	ba 10 00 00 00       	mov    $0x10,%edx
80102455:	b8 20 00 00 00       	mov    $0x20,%eax
8010245a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102460:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102462:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102464:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010246a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010246d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102473:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102476:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102479:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010247c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010247e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102484:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010248b:	39 f0                	cmp    %esi,%eax
8010248d:	75 d1                	jne    80102460 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010248f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102492:	5b                   	pop    %ebx
80102493:	5e                   	pop    %esi
80102494:	5d                   	pop    %ebp
80102495:	c3                   	ret    
80102496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010249d:	8d 76 00             	lea    0x0(%esi),%esi

801024a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024a0:	55                   	push   %ebp
  ioapic->reg = reg;
801024a1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801024a7:	89 e5                	mov    %esp,%ebp
801024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ac:	8d 50 20             	lea    0x20(%eax),%edx
801024af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024c6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801024d1:	5d                   	pop    %ebp
801024d2:	c3                   	ret    
801024d3:	66 90                	xchg   %ax,%ax
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 04             	sub    $0x4,%esp
801024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024f0:	75 76                	jne    80102568 <kfree+0x88>
801024f2:	81 fb d0 c5 11 80    	cmp    $0x8011c5d0,%ebx
801024f8:	72 6e                	jb     80102568 <kfree+0x88>
801024fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102500:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102505:	77 61                	ja     80102568 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102507:	83 ec 04             	sub    $0x4,%esp
8010250a:	68 00 10 00 00       	push   $0x1000
8010250f:	6a 01                	push   $0x1
80102511:	53                   	push   %ebx
80102512:	e8 19 23 00 00       	call   80104830 <memset>

  if(kmem.use_lock)
80102517:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	85 d2                	test   %edx,%edx
80102522:	75 1c                	jne    80102540 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102524:	a1 78 26 11 80       	mov    0x80112678,%eax
80102529:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010252b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102530:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102536:	85 c0                	test   %eax,%eax
80102538:	75 1e                	jne    80102558 <kfree+0x78>
    release(&kmem.lock);
}
8010253a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010253d:	c9                   	leave  
8010253e:	c3                   	ret    
8010253f:	90                   	nop
    acquire(&kmem.lock);
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	68 40 26 11 80       	push   $0x80112640
80102548:	e8 23 22 00 00       	call   80104770 <acquire>
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	eb d2                	jmp    80102524 <kfree+0x44>
80102552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102558:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010255f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102562:	c9                   	leave  
    release(&kmem.lock);
80102563:	e9 a8 21 00 00       	jmp    80104710 <release>
    panic("kfree");
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	68 66 81 10 80       	push   $0x80108166
80102570:	e8 0b de ff ff       	call   80100380 <panic>
80102575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102580 <freerange>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102584:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102587:	8b 75 0c             	mov    0xc(%ebp),%esi
8010258a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010258b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102591:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102597:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010259d:	39 de                	cmp    %ebx,%esi
8010259f:	72 23                	jb     801025c4 <freerange+0x44>
801025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 23 ff ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 f3                	cmp    %esi,%ebx
801025c2:	76 e4                	jbe    801025a8 <freerange+0x28>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025d7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025da:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ed:	39 de                	cmp    %ebx,%esi
801025ef:	72 23                	jb     80102614 <kinit2+0x44>
801025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 d3 fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kinit1>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
80102635:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102638:	83 ec 08             	sub    $0x8,%esp
8010263b:	68 6c 81 10 80       	push   $0x8010816c
80102640:	68 40 26 11 80       	push   $0x80112640
80102645:	e8 56 1f 00 00       	call   801045a0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102650:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102657:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010265a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102660:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102666:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010266c:	39 de                	cmp    %ebx,%esi
8010266e:	72 1c                	jb     8010268c <kinit1+0x5c>
    kfree(p);
80102670:	83 ec 0c             	sub    $0xc,%esp
80102673:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102679:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010267f:	50                   	push   %eax
80102680:	e8 5b fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102685:	83 c4 10             	add    $0x10,%esp
80102688:	39 de                	cmp    %ebx,%esi
8010268a:	73 e4                	jae    80102670 <kinit1+0x40>
}
8010268c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010268f:	5b                   	pop    %ebx
80102690:	5e                   	pop    %esi
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010269a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026a0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026a0:	a1 74 26 11 80       	mov    0x80112674,%eax
801026a5:	85 c0                	test   %eax,%eax
801026a7:	75 1f                	jne    801026c8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026a9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801026ae:	85 c0                	test   %eax,%eax
801026b0:	74 0e                	je     801026c0 <kalloc+0x20>
    kmem.freelist = r->next;
801026b2:	8b 10                	mov    (%eax),%edx
801026b4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801026ba:	c3                   	ret    
801026bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026bf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026c0:	c3                   	ret    
801026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026c8:	55                   	push   %ebp
801026c9:	89 e5                	mov    %esp,%ebp
801026cb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ce:	68 40 26 11 80       	push   $0x80112640
801026d3:	e8 98 20 00 00       	call   80104770 <acquire>
  r = kmem.freelist;
801026d8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026dd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026e3:	83 c4 10             	add    $0x10,%esp
801026e6:	85 c0                	test   %eax,%eax
801026e8:	74 08                	je     801026f2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ea:	8b 08                	mov    (%eax),%ecx
801026ec:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026f2:	85 d2                	test   %edx,%edx
801026f4:	74 16                	je     8010270c <kalloc+0x6c>
    release(&kmem.lock);
801026f6:	83 ec 0c             	sub    $0xc,%esp
801026f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026fc:	68 40 26 11 80       	push   $0x80112640
80102701:	e8 0a 20 00 00       	call   80104710 <release>
  return (char*)r;
80102706:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102709:	83 c4 10             	add    $0x10,%esp
}
8010270c:	c9                   	leave  
8010270d:	c3                   	ret    
8010270e:	66 90                	xchg   %ax,%ax

80102710 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102710:	ba 64 00 00 00       	mov    $0x64,%edx
80102715:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102716:	a8 01                	test   $0x1,%al
80102718:	0f 84 c2 00 00 00    	je     801027e0 <kbdgetc+0xd0>
{
8010271e:	55                   	push   %ebp
8010271f:	ba 60 00 00 00       	mov    $0x60,%edx
80102724:	89 e5                	mov    %esp,%ebp
80102726:	53                   	push   %ebx
80102727:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102728:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010272e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102731:	3c e0                	cmp    $0xe0,%al
80102733:	74 5b                	je     80102790 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102735:	89 da                	mov    %ebx,%edx
80102737:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010273a:	84 c0                	test   %al,%al
8010273c:	78 62                	js     801027a0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010273e:	85 d2                	test   %edx,%edx
80102740:	74 09                	je     8010274b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102742:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102745:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102748:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010274b:	0f b6 91 a0 82 10 80 	movzbl -0x7fef7d60(%ecx),%edx
  shift ^= togglecode[data];
80102752:	0f b6 81 a0 81 10 80 	movzbl -0x7fef7e60(%ecx),%eax
  shift |= shiftcode[data];
80102759:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010275b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010275f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102765:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102768:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010276b:	8b 04 85 80 81 10 80 	mov    -0x7fef7e80(,%eax,4),%eax
80102772:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102776:	74 0b                	je     80102783 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102778:	8d 50 9f             	lea    -0x61(%eax),%edx
8010277b:	83 fa 19             	cmp    $0x19,%edx
8010277e:	77 48                	ja     801027c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102780:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102783:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102786:	c9                   	leave  
80102787:	c3                   	ret    
80102788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278f:	90                   	nop
    shift |= E0ESC;
80102790:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102793:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102795:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010279b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279e:	c9                   	leave  
8010279f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801027a0:	83 e0 7f             	and    $0x7f,%eax
801027a3:	85 d2                	test   %edx,%edx
801027a5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027a8:	0f b6 81 a0 82 10 80 	movzbl -0x7fef7d60(%ecx),%eax
801027af:	83 c8 40             	or     $0x40,%eax
801027b2:	0f b6 c0             	movzbl %al,%eax
801027b5:	f7 d0                	not    %eax
801027b7:	21 d8                	and    %ebx,%eax
}
801027b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027bc:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027c1:	31 c0                	xor    %eax,%eax
}
801027c3:	c9                   	leave  
801027c4:	c3                   	ret    
801027c5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027cb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d1:	c9                   	leave  
      c += 'a' - 'A';
801027d2:	83 f9 1a             	cmp    $0x1a,%ecx
801027d5:	0f 42 c2             	cmovb  %edx,%eax
}
801027d8:	c3                   	ret    
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027e5:	c3                   	ret    
801027e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ed:	8d 76 00             	lea    0x0(%esi),%esi

801027f0 <kbdintr>:

void
kbdintr(void)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027f6:	68 10 27 10 80       	push   $0x80102710
801027fb:	e8 80 e0 ff ff       	call   80100880 <consoleintr>
}
80102800:	83 c4 10             	add    $0x10,%esp
80102803:	c9                   	leave  
80102804:	c3                   	ret    
80102805:	66 90                	xchg   %ax,%ax
80102807:	66 90                	xchg   %ax,%ax
80102809:	66 90                	xchg   %ax,%ax
8010280b:	66 90                	xchg   %ax,%ax
8010280d:	66 90                	xchg   %ax,%ax
8010280f:	90                   	nop

80102810 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102810:	a1 80 26 11 80       	mov    0x80112680,%eax
80102815:	85 c0                	test   %eax,%eax
80102817:	0f 84 cb 00 00 00    	je     801028e8 <lapicinit+0xd8>
  lapic[index] = value;
8010281d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102824:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010283e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010284b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102858:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102865:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010286b:	8b 50 30             	mov    0x30(%eax),%edx
8010286e:	c1 ea 10             	shr    $0x10,%edx
80102871:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102877:	75 77                	jne    801028f0 <lapicinit+0xe0>
  lapic[index] = value;
80102879:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102880:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102883:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102886:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102890:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102893:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010289a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028a7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028c1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028c4:	8b 50 20             	mov    0x20(%eax),%edx
801028c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ce:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028d0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028d6:	80 e6 10             	and    $0x10,%dh
801028d9:	75 f5                	jne    801028d0 <lapicinit+0xc0>
  lapic[index] = value;
801028db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028e2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028e8:	c3                   	ret    
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028f0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028f7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028fa:	8b 50 20             	mov    0x20(%eax),%edx
}
801028fd:	e9 77 ff ff ff       	jmp    80102879 <lapicinit+0x69>
80102902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102910 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102910:	a1 80 26 11 80       	mov    0x80112680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 07                	je     80102920 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102919:	8b 40 20             	mov    0x20(%eax),%eax
8010291c:	c1 e8 18             	shr    $0x18,%eax
8010291f:	c3                   	ret    
    return 0;
80102920:	31 c0                	xor    %eax,%eax
}
80102922:	c3                   	ret    
80102923:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102930 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102930:	a1 80 26 11 80       	mov    0x80112680,%eax
80102935:	85 c0                	test   %eax,%eax
80102937:	74 0d                	je     80102946 <lapiceoi+0x16>
  lapic[index] = value;
80102939:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102940:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102943:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102946:	c3                   	ret    
80102947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294e:	66 90                	xchg   %ax,%ax

80102950 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102950:	c3                   	ret    
80102951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295f:	90                   	nop

80102960 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102960:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102961:	b8 0f 00 00 00       	mov    $0xf,%eax
80102966:	ba 70 00 00 00       	mov    $0x70,%edx
8010296b:	89 e5                	mov    %esp,%ebp
8010296d:	53                   	push   %ebx
8010296e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102971:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102974:	ee                   	out    %al,(%dx)
80102975:	b8 0a 00 00 00       	mov    $0xa,%eax
8010297a:	ba 71 00 00 00       	mov    $0x71,%edx
8010297f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102980:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102982:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102985:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010298b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010298d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102990:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102992:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102995:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102998:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010299e:	a1 80 26 11 80       	mov    0x80112680,%eax
801029a3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029b3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029c0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029cc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029cf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029d8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ed:	c9                   	leave  
801029ee:	c3                   	ret    
801029ef:	90                   	nop

801029f0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029f0:	55                   	push   %ebp
801029f1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029f6:	ba 70 00 00 00       	mov    $0x70,%edx
801029fb:	89 e5                	mov    %esp,%ebp
801029fd:	57                   	push   %edi
801029fe:	56                   	push   %esi
801029ff:	53                   	push   %ebx
80102a00:	83 ec 4c             	sub    $0x4c,%esp
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	ba 71 00 00 00       	mov    $0x71,%edx
80102a09:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a0a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a12:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a15:	8d 76 00             	lea    0x0(%esi),%esi
80102a18:	31 c0                	xor    %eax,%eax
80102a1a:	89 da                	mov    %ebx,%edx
80102a1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a22:	89 ca                	mov    %ecx,%edx
80102a24:	ec                   	in     (%dx),%al
80102a25:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a28:	89 da                	mov    %ebx,%edx
80102a2a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a30:	89 ca                	mov    %ecx,%edx
80102a32:	ec                   	in     (%dx),%al
80102a33:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a36:	89 da                	mov    %ebx,%edx
80102a38:	b8 04 00 00 00       	mov    $0x4,%eax
80102a3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3e:	89 ca                	mov    %ecx,%edx
80102a40:	ec                   	in     (%dx),%al
80102a41:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a44:	89 da                	mov    %ebx,%edx
80102a46:	b8 07 00 00 00       	mov    $0x7,%eax
80102a4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4c:	89 ca                	mov    %ecx,%edx
80102a4e:	ec                   	in     (%dx),%al
80102a4f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a52:	89 da                	mov    %ebx,%edx
80102a54:	b8 08 00 00 00       	mov    $0x8,%eax
80102a59:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5a:	89 ca                	mov    %ecx,%edx
80102a5c:	ec                   	in     (%dx),%al
80102a5d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5f:	89 da                	mov    %ebx,%edx
80102a61:	b8 09 00 00 00       	mov    $0x9,%eax
80102a66:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a67:	89 ca                	mov    %ecx,%edx
80102a69:	ec                   	in     (%dx),%al
80102a6a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6c:	89 da                	mov    %ebx,%edx
80102a6e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a74:	89 ca                	mov    %ecx,%edx
80102a76:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a77:	84 c0                	test   %al,%al
80102a79:	78 9d                	js     80102a18 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a7b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a7f:	89 fa                	mov    %edi,%edx
80102a81:	0f b6 fa             	movzbl %dl,%edi
80102a84:	89 f2                	mov    %esi,%edx
80102a86:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a89:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a8d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a90:	89 da                	mov    %ebx,%edx
80102a92:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a95:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a98:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a9c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a9f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aa2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102aa6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102aa9:	31 c0                	xor    %eax,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al
80102aaf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab2:	89 da                	mov    %ebx,%edx
80102ab4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ab7:	b8 02 00 00 00       	mov    $0x2,%eax
80102abc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abd:	89 ca                	mov    %ecx,%edx
80102abf:	ec                   	in     (%dx),%al
80102ac0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac3:	89 da                	mov    %ebx,%edx
80102ac5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ac8:	b8 04 00 00 00       	mov    $0x4,%eax
80102acd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ace:	89 ca                	mov    %ecx,%edx
80102ad0:	ec                   	in     (%dx),%al
80102ad1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad4:	89 da                	mov    %ebx,%edx
80102ad6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ad9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ade:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102adf:	89 ca                	mov    %ecx,%edx
80102ae1:	ec                   	in     (%dx),%al
80102ae2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae5:	89 da                	mov    %ebx,%edx
80102ae7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aea:	b8 08 00 00 00       	mov    $0x8,%eax
80102aef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af0:	89 ca                	mov    %ecx,%edx
80102af2:	ec                   	in     (%dx),%al
80102af3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af6:	89 da                	mov    %ebx,%edx
80102af8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102afb:	b8 09 00 00 00       	mov    $0x9,%eax
80102b00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b01:	89 ca                	mov    %ecx,%edx
80102b03:	ec                   	in     (%dx),%al
80102b04:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b07:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b0d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b10:	6a 18                	push   $0x18
80102b12:	50                   	push   %eax
80102b13:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b16:	50                   	push   %eax
80102b17:	e8 64 1d 00 00       	call   80104880 <memcmp>
80102b1c:	83 c4 10             	add    $0x10,%esp
80102b1f:	85 c0                	test   %eax,%eax
80102b21:	0f 85 f1 fe ff ff    	jne    80102a18 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b27:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b2b:	75 78                	jne    80102ba5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b30:	89 c2                	mov    %eax,%edx
80102b32:	83 e0 0f             	and    $0xf,%eax
80102b35:	c1 ea 04             	shr    $0x4,%edx
80102b38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b41:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b44:	89 c2                	mov    %eax,%edx
80102b46:	83 e0 0f             	and    $0xf,%eax
80102b49:	c1 ea 04             	shr    $0x4,%edx
80102b4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b52:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b55:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b58:	89 c2                	mov    %eax,%edx
80102b5a:	83 e0 0f             	and    $0xf,%eax
80102b5d:	c1 ea 04             	shr    $0x4,%edx
80102b60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b66:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b6c:	89 c2                	mov    %eax,%edx
80102b6e:	83 e0 0f             	and    $0xf,%eax
80102b71:	c1 ea 04             	shr    $0x4,%edx
80102b74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b80:	89 c2                	mov    %eax,%edx
80102b82:	83 e0 0f             	and    $0xf,%eax
80102b85:	c1 ea 04             	shr    $0x4,%edx
80102b88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b91:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b94:	89 c2                	mov    %eax,%edx
80102b96:	83 e0 0f             	and    $0xf,%eax
80102b99:	c1 ea 04             	shr    $0x4,%edx
80102b9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ba5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ba8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bab:	89 06                	mov    %eax,(%esi)
80102bad:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bb0:	89 46 04             	mov    %eax,0x4(%esi)
80102bb3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bb6:	89 46 08             	mov    %eax,0x8(%esi)
80102bb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bbc:	89 46 0c             	mov    %eax,0xc(%esi)
80102bbf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bc2:	89 46 10             	mov    %eax,0x10(%esi)
80102bc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bc8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bcb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bd5:	5b                   	pop    %ebx
80102bd6:	5e                   	pop    %esi
80102bd7:	5f                   	pop    %edi
80102bd8:	5d                   	pop    %ebp
80102bd9:	c3                   	ret    
80102bda:	66 90                	xchg   %ax,%ax
80102bdc:	66 90                	xchg   %ax,%ax
80102bde:	66 90                	xchg   %ax,%ax

80102be0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102be0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102be6:	85 c9                	test   %ecx,%ecx
80102be8:	0f 8e 8a 00 00 00    	jle    80102c78 <install_trans+0x98>
{
80102bee:	55                   	push   %ebp
80102bef:	89 e5                	mov    %esp,%ebp
80102bf1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bf2:	31 ff                	xor    %edi,%edi
{
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 0c             	sub    $0xc,%esp
80102bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c00:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c05:	83 ec 08             	sub    $0x8,%esp
80102c08:	01 f8                	add    %edi,%eax
80102c0a:	83 c0 01             	add    $0x1,%eax
80102c0d:	50                   	push   %eax
80102c0e:	ff 35 e4 26 11 80    	push   0x801126e4
80102c14:	e8 b7 d4 ff ff       	call   801000d0 <bread>
80102c19:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1b:	58                   	pop    %eax
80102c1c:	5a                   	pop    %edx
80102c1d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c24:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c2a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2d:	e8 9e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c32:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c35:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c37:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3a:	68 00 02 00 00       	push   $0x200
80102c3f:	50                   	push   %eax
80102c40:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c43:	50                   	push   %eax
80102c44:	e8 87 1c 00 00       	call   801048d0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 5f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c51:	89 34 24             	mov    %esi,(%esp)
80102c54:	e8 97 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 8f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c61:	83 c4 10             	add    $0x10,%esp
80102c64:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c6a:	7f 94                	jg     80102c00 <install_trans+0x20>
  }
}
80102c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c6f:	5b                   	pop    %ebx
80102c70:	5e                   	pop    %esi
80102c71:	5f                   	pop    %edi
80102c72:	5d                   	pop    %ebp
80102c73:	c3                   	ret    
80102c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c78:	c3                   	ret    
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	53                   	push   %ebx
80102c84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c87:	ff 35 d4 26 11 80    	push   0x801126d4
80102c8d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c93:	e8 38 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c98:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c9b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c9d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102ca2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	7e 19                	jle    80102cc2 <write_head+0x42>
80102ca9:	31 d2                	xor    %edx,%edx
80102cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cb0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102cb7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cbb:	83 c2 01             	add    $0x1,%edx
80102cbe:	39 d0                	cmp    %edx,%eax
80102cc0:	75 ee                	jne    80102cb0 <write_head+0x30>
  }
  bwrite(buf);
80102cc2:	83 ec 0c             	sub    $0xc,%esp
80102cc5:	53                   	push   %ebx
80102cc6:	e8 e5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ccb:	89 1c 24             	mov    %ebx,(%esp)
80102cce:	e8 1d d5 ff ff       	call   801001f0 <brelse>
}
80102cd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cd6:	83 c4 10             	add    $0x10,%esp
80102cd9:	c9                   	leave  
80102cda:	c3                   	ret    
80102cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cdf:	90                   	nop

80102ce0 <initlog>:
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	53                   	push   %ebx
80102ce4:	83 ec 2c             	sub    $0x2c,%esp
80102ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cea:	68 a0 83 10 80       	push   $0x801083a0
80102cef:	68 a0 26 11 80       	push   $0x801126a0
80102cf4:	e8 a7 18 00 00       	call   801045a0 <initlock>
  readsb(dev, &sb);
80102cf9:	58                   	pop    %eax
80102cfa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 3b e8 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d08:	59                   	pop    %ecx
  log.dev = dev;
80102d09:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102d0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d12:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d17:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d1d:	5a                   	pop    %edx
80102d1e:	50                   	push   %eax
80102d1f:	53                   	push   %ebx
80102d20:	e8 ab d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d25:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d28:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d2b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d31:	85 db                	test   %ebx,%ebx
80102d33:	7e 1d                	jle    80102d52 <initlog+0x72>
80102d35:	31 d2                	xor    %edx,%edx
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d40:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d44:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d4b:	83 c2 01             	add    $0x1,%edx
80102d4e:	39 d3                	cmp    %edx,%ebx
80102d50:	75 ee                	jne    80102d40 <initlog+0x60>
  brelse(buf);
80102d52:	83 ec 0c             	sub    $0xc,%esp
80102d55:	50                   	push   %eax
80102d56:	e8 95 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d5b:	e8 80 fe ff ff       	call   80102be0 <install_trans>
  log.lh.n = 0;
80102d60:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d67:	00 00 00 
  write_head(); // clear the log
80102d6a:	e8 11 ff ff ff       	call   80102c80 <write_head>
}
80102d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d72:	83 c4 10             	add    $0x10,%esp
80102d75:	c9                   	leave  
80102d76:	c3                   	ret    
80102d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d86:	68 a0 26 11 80       	push   $0x801126a0
80102d8b:	e8 e0 19 00 00       	call   80104770 <acquire>
80102d90:	83 c4 10             	add    $0x10,%esp
80102d93:	eb 18                	jmp    80102dad <begin_op+0x2d>
80102d95:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d98:	83 ec 08             	sub    $0x8,%esp
80102d9b:	68 a0 26 11 80       	push   $0x801126a0
80102da0:	68 a0 26 11 80       	push   $0x801126a0
80102da5:	e8 66 14 00 00       	call   80104210 <sleep>
80102daa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dad:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102db2:	85 c0                	test   %eax,%eax
80102db4:	75 e2                	jne    80102d98 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102db6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dbb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102dc1:	83 c0 01             	add    $0x1,%eax
80102dc4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dc7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dca:	83 fa 1e             	cmp    $0x1e,%edx
80102dcd:	7f c9                	jg     80102d98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dcf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dd2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102dd7:	68 a0 26 11 80       	push   $0x801126a0
80102ddc:	e8 2f 19 00 00       	call   80104710 <release>
      break;
    }
  }
}
80102de1:	83 c4 10             	add    $0x10,%esp
80102de4:	c9                   	leave  
80102de5:	c3                   	ret    
80102de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ded:	8d 76 00             	lea    0x0(%esi),%esi

80102df0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	57                   	push   %edi
80102df4:	56                   	push   %esi
80102df5:	53                   	push   %ebx
80102df6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102df9:	68 a0 26 11 80       	push   $0x801126a0
80102dfe:	e8 6d 19 00 00       	call   80104770 <acquire>
  log.outstanding -= 1;
80102e03:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102e08:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102e0e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e11:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e14:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e1a:	85 f6                	test   %esi,%esi
80102e1c:	0f 85 22 01 00 00    	jne    80102f44 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e22:	85 db                	test   %ebx,%ebx
80102e24:	0f 85 f6 00 00 00    	jne    80102f20 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e2a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e31:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e34:	83 ec 0c             	sub    $0xc,%esp
80102e37:	68 a0 26 11 80       	push   $0x801126a0
80102e3c:	e8 cf 18 00 00       	call   80104710 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e41:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e47:	83 c4 10             	add    $0x10,%esp
80102e4a:	85 c9                	test   %ecx,%ecx
80102e4c:	7f 42                	jg     80102e90 <end_op+0xa0>
    acquire(&log.lock);
80102e4e:	83 ec 0c             	sub    $0xc,%esp
80102e51:	68 a0 26 11 80       	push   $0x801126a0
80102e56:	e8 15 19 00 00       	call   80104770 <acquire>
    wakeup(&log);
80102e5b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e62:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e69:	00 00 00 
    wakeup(&log);
80102e6c:	e8 5f 14 00 00       	call   801042d0 <wakeup>
    release(&log.lock);
80102e71:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e78:	e8 93 18 00 00       	call   80104710 <release>
80102e7d:	83 c4 10             	add    $0x10,%esp
}
80102e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e83:	5b                   	pop    %ebx
80102e84:	5e                   	pop    %esi
80102e85:	5f                   	pop    %edi
80102e86:	5d                   	pop    %ebp
80102e87:	c3                   	ret    
80102e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e8f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e90:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e95:	83 ec 08             	sub    $0x8,%esp
80102e98:	01 d8                	add    %ebx,%eax
80102e9a:	83 c0 01             	add    $0x1,%eax
80102e9d:	50                   	push   %eax
80102e9e:	ff 35 e4 26 11 80    	push   0x801126e4
80102ea4:	e8 27 d2 ff ff       	call   801000d0 <bread>
80102ea9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eab:	58                   	pop    %eax
80102eac:	5a                   	pop    %edx
80102ead:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102eb4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebd:	e8 0e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ec2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ec5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ec7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eca:	68 00 02 00 00       	push   $0x200
80102ecf:	50                   	push   %eax
80102ed0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ed3:	50                   	push   %eax
80102ed4:	e8 f7 19 00 00       	call   801048d0 <memmove>
    bwrite(to);  // write the log
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 cf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ee1:	89 3c 24             	mov    %edi,(%esp)
80102ee4:	e8 07 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 ff d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ef1:	83 c4 10             	add    $0x10,%esp
80102ef4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102efa:	7c 94                	jl     80102e90 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102efc:	e8 7f fd ff ff       	call   80102c80 <write_head>
    install_trans(); // Now install writes to home locations
80102f01:	e8 da fc ff ff       	call   80102be0 <install_trans>
    log.lh.n = 0;
80102f06:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f0d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f10:	e8 6b fd ff ff       	call   80102c80 <write_head>
80102f15:	e9 34 ff ff ff       	jmp    80102e4e <end_op+0x5e>
80102f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f20:	83 ec 0c             	sub    $0xc,%esp
80102f23:	68 a0 26 11 80       	push   $0x801126a0
80102f28:	e8 a3 13 00 00       	call   801042d0 <wakeup>
  release(&log.lock);
80102f2d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f34:	e8 d7 17 00 00       	call   80104710 <release>
80102f39:	83 c4 10             	add    $0x10,%esp
}
80102f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3f:	5b                   	pop    %ebx
80102f40:	5e                   	pop    %esi
80102f41:	5f                   	pop    %edi
80102f42:	5d                   	pop    %ebp
80102f43:	c3                   	ret    
    panic("log.committing");
80102f44:	83 ec 0c             	sub    $0xc,%esp
80102f47:	68 a4 83 10 80       	push   $0x801083a4
80102f4c:	e8 2f d4 ff ff       	call   80100380 <panic>
80102f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f5f:	90                   	nop

80102f60 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	53                   	push   %ebx
80102f64:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f67:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f70:	83 fa 1d             	cmp    $0x1d,%edx
80102f73:	0f 8f 85 00 00 00    	jg     80102ffe <log_write+0x9e>
80102f79:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f7e:	83 e8 01             	sub    $0x1,%eax
80102f81:	39 c2                	cmp    %eax,%edx
80102f83:	7d 79                	jge    80102ffe <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f85:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f8a:	85 c0                	test   %eax,%eax
80102f8c:	7e 7d                	jle    8010300b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f8e:	83 ec 0c             	sub    $0xc,%esp
80102f91:	68 a0 26 11 80       	push   $0x801126a0
80102f96:	e8 d5 17 00 00       	call   80104770 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f9b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	85 d2                	test   %edx,%edx
80102fa6:	7e 4a                	jle    80102ff2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fab:	31 c0                	xor    %eax,%eax
80102fad:	eb 08                	jmp    80102fb7 <log_write+0x57>
80102faf:	90                   	nop
80102fb0:	83 c0 01             	add    $0x1,%eax
80102fb3:	39 c2                	cmp    %eax,%edx
80102fb5:	74 29                	je     80102fe0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fb7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102fbe:	75 f0                	jne    80102fb0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fc7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fcd:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fd4:	c9                   	leave  
  release(&log.lock);
80102fd5:	e9 36 17 00 00       	jmp    80104710 <release>
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fe0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fe7:	83 c2 01             	add    $0x1,%edx
80102fea:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102ff0:	eb d5                	jmp    80102fc7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102ff2:	8b 43 08             	mov    0x8(%ebx),%eax
80102ff5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102ffa:	75 cb                	jne    80102fc7 <log_write+0x67>
80102ffc:	eb e9                	jmp    80102fe7 <log_write+0x87>
    panic("too big a transaction");
80102ffe:	83 ec 0c             	sub    $0xc,%esp
80103001:	68 b3 83 10 80       	push   $0x801083b3
80103006:	e8 75 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010300b:	83 ec 0c             	sub    $0xc,%esp
8010300e:	68 c9 83 10 80       	push   $0x801083c9
80103013:	e8 68 d3 ff ff       	call   80100380 <panic>
80103018:	66 90                	xchg   %ax,%ax
8010301a:	66 90                	xchg   %ax,%ax
8010301c:	66 90                	xchg   %ax,%ax
8010301e:	66 90                	xchg   %ax,%ax

80103020 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	53                   	push   %ebx
80103024:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103027:	e8 54 09 00 00       	call   80103980 <cpuid>
8010302c:	89 c3                	mov    %eax,%ebx
8010302e:	e8 4d 09 00 00       	call   80103980 <cpuid>
80103033:	83 ec 04             	sub    $0x4,%esp
80103036:	53                   	push   %ebx
80103037:	50                   	push   %eax
80103038:	68 e4 83 10 80       	push   $0x801083e4
8010303d:	e8 5e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103042:	e8 79 2f 00 00       	call   80105fc0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103047:	e8 d4 08 00 00       	call   80103920 <mycpu>
8010304c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010304e:	b8 01 00 00 00       	mov    $0x1,%eax
80103053:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010305a:	e8 51 0d 00 00       	call   80103db0 <scheduler>
8010305f:	90                   	nop

80103060 <mpenter>:
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103066:	e8 b5 42 00 00       	call   80107320 <switchkvm>
  seginit();
8010306b:	e8 a0 40 00 00       	call   80107110 <seginit>
  lapicinit();
80103070:	e8 9b f7 ff ff       	call   80102810 <lapicinit>
  mpmain();
80103075:	e8 a6 ff ff ff       	call   80103020 <mpmain>
8010307a:	66 90                	xchg   %ax,%ax
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <main>:
{
80103080:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103084:	83 e4 f0             	and    $0xfffffff0,%esp
80103087:	ff 71 fc             	push   -0x4(%ecx)
8010308a:	55                   	push   %ebp
8010308b:	89 e5                	mov    %esp,%ebp
8010308d:	53                   	push   %ebx
8010308e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010308f:	83 ec 08             	sub    $0x8,%esp
80103092:	68 00 00 40 80       	push   $0x80400000
80103097:	68 d0 c5 11 80       	push   $0x8011c5d0
8010309c:	e8 8f f5 ff ff       	call   80102630 <kinit1>
  kvmalloc();      // kernel page table
801030a1:	e8 6a 47 00 00       	call   80107810 <kvmalloc>
  mpinit();        // detect other processors
801030a6:	e8 85 01 00 00       	call   80103230 <mpinit>
  lapicinit();     // interrupt controller
801030ab:	e8 60 f7 ff ff       	call   80102810 <lapicinit>
  seginit();       // segment descriptors
801030b0:	e8 5b 40 00 00       	call   80107110 <seginit>
  picinit();       // disable pic
801030b5:	e8 76 03 00 00       	call   80103430 <picinit>
  ioapicinit();    // another interrupt controller
801030ba:	e8 31 f3 ff ff       	call   801023f0 <ioapicinit>
  consoleinit();   // console hardware
801030bf:	e8 9c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030c4:	e8 c7 33 00 00       	call   80106490 <uartinit>
  pinit();         // process table
801030c9:	e8 32 08 00 00       	call   80103900 <pinit>
  tvinit();        // trap vectors
801030ce:	e8 6d 2e 00 00       	call   80105f40 <tvinit>
  binit();         // buffer cache
801030d3:	e8 68 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030d8:	e8 33 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030dd:	e8 fe f0 ff ff       	call   801021e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030e2:	83 c4 0c             	add    $0xc,%esp
801030e5:	68 8a 00 00 00       	push   $0x8a
801030ea:	68 8c b4 10 80       	push   $0x8010b48c
801030ef:	68 00 70 00 80       	push   $0x80007000
801030f4:	e8 d7 17 00 00       	call   801048d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030f9:	83 c4 10             	add    $0x10,%esp
801030fc:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103103:	00 00 00 
80103106:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010310b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103110:	76 7e                	jbe    80103190 <main+0x110>
80103112:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103117:	eb 20                	jmp    80103139 <main+0xb9>
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103120:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103127:	00 00 00 
8010312a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103130:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103135:	39 c3                	cmp    %eax,%ebx
80103137:	73 57                	jae    80103190 <main+0x110>
    if(c == mycpu())  // We've started already.
80103139:	e8 e2 07 00 00       	call   80103920 <mycpu>
8010313e:	39 c3                	cmp    %eax,%ebx
80103140:	74 de                	je     80103120 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103142:	e8 59 f5 ff ff       	call   801026a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103147:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010314a:	c7 05 f8 6f 00 80 60 	movl   $0x80103060,0x80006ff8
80103151:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103154:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010315b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010315e:	05 00 10 00 00       	add    $0x1000,%eax
80103163:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103168:	0f b6 03             	movzbl (%ebx),%eax
8010316b:	68 00 70 00 00       	push   $0x7000
80103170:	50                   	push   %eax
80103171:	e8 ea f7 ff ff       	call   80102960 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103176:	83 c4 10             	add    $0x10,%esp
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103180:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103186:	85 c0                	test   %eax,%eax
80103188:	74 f6                	je     80103180 <main+0x100>
8010318a:	eb 94                	jmp    80103120 <main+0xa0>
8010318c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103190:	83 ec 08             	sub    $0x8,%esp
80103193:	68 00 00 00 8e       	push   $0x8e000000
80103198:	68 00 00 40 80       	push   $0x80400000
8010319d:	e8 2e f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
801031a2:	e8 29 08 00 00       	call   801039d0 <userinit>
  mpmain();        // finish this processor's setup
801031a7:	e8 74 fe ff ff       	call   80103020 <mpmain>
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	57                   	push   %edi
801031b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031bb:	53                   	push   %ebx
  e = addr+len;
801031bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031c2:	39 de                	cmp    %ebx,%esi
801031c4:	72 10                	jb     801031d6 <mpsearch1+0x26>
801031c6:	eb 50                	jmp    80103218 <mpsearch1+0x68>
801031c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031cf:	90                   	nop
801031d0:	89 fe                	mov    %edi,%esi
801031d2:	39 fb                	cmp    %edi,%ebx
801031d4:	76 42                	jbe    80103218 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d6:	83 ec 04             	sub    $0x4,%esp
801031d9:	8d 7e 10             	lea    0x10(%esi),%edi
801031dc:	6a 04                	push   $0x4
801031de:	68 f8 83 10 80       	push   $0x801083f8
801031e3:	56                   	push   %esi
801031e4:	e8 97 16 00 00       	call   80104880 <memcmp>
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	85 c0                	test   %eax,%eax
801031ee:	75 e0                	jne    801031d0 <mpsearch1+0x20>
801031f0:	89 f2                	mov    %esi,%edx
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031f8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031fb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031fe:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103200:	39 fa                	cmp    %edi,%edx
80103202:	75 f4                	jne    801031f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103204:	84 c0                	test   %al,%al
80103206:	75 c8                	jne    801031d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010320b:	89 f0                	mov    %esi,%eax
8010320d:	5b                   	pop    %ebx
8010320e:	5e                   	pop    %esi
8010320f:	5f                   	pop    %edi
80103210:	5d                   	pop    %ebp
80103211:	c3                   	ret    
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010321b:	31 f6                	xor    %esi,%esi
}
8010321d:	5b                   	pop    %ebx
8010321e:	89 f0                	mov    %esi,%eax
80103220:	5e                   	pop    %esi
80103221:	5f                   	pop    %edi
80103222:	5d                   	pop    %ebp
80103223:	c3                   	ret    
80103224:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010322b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010322f:	90                   	nop

80103230 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	57                   	push   %edi
80103234:	56                   	push   %esi
80103235:	53                   	push   %ebx
80103236:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103239:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103240:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103247:	c1 e0 08             	shl    $0x8,%eax
8010324a:	09 d0                	or     %edx,%eax
8010324c:	c1 e0 04             	shl    $0x4,%eax
8010324f:	75 1b                	jne    8010326c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103251:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103258:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010325f:	c1 e0 08             	shl    $0x8,%eax
80103262:	09 d0                	or     %edx,%eax
80103264:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103267:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010326c:	ba 00 04 00 00       	mov    $0x400,%edx
80103271:	e8 3a ff ff ff       	call   801031b0 <mpsearch1>
80103276:	89 c3                	mov    %eax,%ebx
80103278:	85 c0                	test   %eax,%eax
8010327a:	0f 84 40 01 00 00    	je     801033c0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103280:	8b 73 04             	mov    0x4(%ebx),%esi
80103283:	85 f6                	test   %esi,%esi
80103285:	0f 84 25 01 00 00    	je     801033b0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010328b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103294:	6a 04                	push   $0x4
80103296:	68 fd 83 10 80       	push   $0x801083fd
8010329b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010329c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010329f:	e8 dc 15 00 00       	call   80104880 <memcmp>
801032a4:	83 c4 10             	add    $0x10,%esp
801032a7:	85 c0                	test   %eax,%eax
801032a9:	0f 85 01 01 00 00    	jne    801033b0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801032af:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032b6:	3c 01                	cmp    $0x1,%al
801032b8:	74 08                	je     801032c2 <mpinit+0x92>
801032ba:	3c 04                	cmp    $0x4,%al
801032bc:	0f 85 ee 00 00 00    	jne    801033b0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032c2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032c9:	66 85 d2             	test   %dx,%dx
801032cc:	74 22                	je     801032f0 <mpinit+0xc0>
801032ce:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032d1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032d3:	31 d2                	xor    %edx,%edx
801032d5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032d8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032df:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032e2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032e4:	39 c7                	cmp    %eax,%edi
801032e6:	75 f0                	jne    801032d8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032e8:	84 d2                	test   %dl,%dl
801032ea:	0f 85 c0 00 00 00    	jne    801033b0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032f0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032f6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103302:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103308:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103310:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103317:	90                   	nop
80103318:	39 d0                	cmp    %edx,%eax
8010331a:	73 15                	jae    80103331 <mpinit+0x101>
    switch(*p){
8010331c:	0f b6 08             	movzbl (%eax),%ecx
8010331f:	80 f9 02             	cmp    $0x2,%cl
80103322:	74 4c                	je     80103370 <mpinit+0x140>
80103324:	77 3a                	ja     80103360 <mpinit+0x130>
80103326:	84 c9                	test   %cl,%cl
80103328:	74 56                	je     80103380 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010332a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010332d:	39 d0                	cmp    %edx,%eax
8010332f:	72 eb                	jb     8010331c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103331:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103334:	85 f6                	test   %esi,%esi
80103336:	0f 84 d9 00 00 00    	je     80103415 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010333c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103340:	74 15                	je     80103357 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103342:	b8 70 00 00 00       	mov    $0x70,%eax
80103347:	ba 22 00 00 00       	mov    $0x22,%edx
8010334c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010334d:	ba 23 00 00 00       	mov    $0x23,%edx
80103352:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103353:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103356:	ee                   	out    %al,(%dx)
  }
}
80103357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010335a:	5b                   	pop    %ebx
8010335b:	5e                   	pop    %esi
8010335c:	5f                   	pop    %edi
8010335d:	5d                   	pop    %ebp
8010335e:	c3                   	ret    
8010335f:	90                   	nop
    switch(*p){
80103360:	83 e9 03             	sub    $0x3,%ecx
80103363:	80 f9 01             	cmp    $0x1,%cl
80103366:	76 c2                	jbe    8010332a <mpinit+0xfa>
80103368:	31 f6                	xor    %esi,%esi
8010336a:	eb ac                	jmp    80103318 <mpinit+0xe8>
8010336c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103370:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103374:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103377:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010337d:	eb 99                	jmp    80103318 <mpinit+0xe8>
8010337f:	90                   	nop
      if(ncpu < NCPU) {
80103380:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103386:	83 f9 07             	cmp    $0x7,%ecx
80103389:	7f 19                	jg     801033a4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103391:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103395:	83 c1 01             	add    $0x1,%ecx
80103398:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801033a4:	83 c0 14             	add    $0x14,%eax
      continue;
801033a7:	e9 6c ff ff ff       	jmp    80103318 <mpinit+0xe8>
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 02 84 10 80       	push   $0x80108402
801033b8:	e8 c3 cf ff ff       	call   80100380 <panic>
801033bd:	8d 76 00             	lea    0x0(%esi),%esi
{
801033c0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033c5:	eb 13                	jmp    801033da <mpinit+0x1aa>
801033c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ce:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033d0:	89 f3                	mov    %esi,%ebx
801033d2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033d8:	74 d6                	je     801033b0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033da:	83 ec 04             	sub    $0x4,%esp
801033dd:	8d 73 10             	lea    0x10(%ebx),%esi
801033e0:	6a 04                	push   $0x4
801033e2:	68 f8 83 10 80       	push   $0x801083f8
801033e7:	53                   	push   %ebx
801033e8:	e8 93 14 00 00       	call   80104880 <memcmp>
801033ed:	83 c4 10             	add    $0x10,%esp
801033f0:	85 c0                	test   %eax,%eax
801033f2:	75 dc                	jne    801033d0 <mpinit+0x1a0>
801033f4:	89 da                	mov    %ebx,%edx
801033f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103400:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103403:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103406:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103408:	39 d6                	cmp    %edx,%esi
8010340a:	75 f4                	jne    80103400 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010340c:	84 c0                	test   %al,%al
8010340e:	75 c0                	jne    801033d0 <mpinit+0x1a0>
80103410:	e9 6b fe ff ff       	jmp    80103280 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103415:	83 ec 0c             	sub    $0xc,%esp
80103418:	68 1c 84 10 80       	push   $0x8010841c
8010341d:	e8 5e cf ff ff       	call   80100380 <panic>
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <picinit>:
80103430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103435:	ba 21 00 00 00       	mov    $0x21,%edx
8010343a:	ee                   	out    %al,(%dx)
8010343b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103440:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103441:	c3                   	ret    
80103442:	66 90                	xchg   %ax,%ax
80103444:	66 90                	xchg   %ax,%ax
80103446:	66 90                	xchg   %ax,%ax
80103448:	66 90                	xchg   %ax,%ax
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	57                   	push   %edi
80103454:	56                   	push   %esi
80103455:	53                   	push   %ebx
80103456:	83 ec 0c             	sub    $0xc,%esp
80103459:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010345c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010345f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103465:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010346b:	e8 c0 d9 ff ff       	call   80100e30 <filealloc>
80103470:	89 03                	mov    %eax,(%ebx)
80103472:	85 c0                	test   %eax,%eax
80103474:	0f 84 a8 00 00 00    	je     80103522 <pipealloc+0xd2>
8010347a:	e8 b1 d9 ff ff       	call   80100e30 <filealloc>
8010347f:	89 06                	mov    %eax,(%esi)
80103481:	85 c0                	test   %eax,%eax
80103483:	0f 84 87 00 00 00    	je     80103510 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103489:	e8 12 f2 ff ff       	call   801026a0 <kalloc>
8010348e:	89 c7                	mov    %eax,%edi
80103490:	85 c0                	test   %eax,%eax
80103492:	0f 84 b0 00 00 00    	je     80103548 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103498:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010349f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034a2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034ac:	00 00 00 
  p->nwrite = 0;
801034af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034b6:	00 00 00 
  p->nread = 0;
801034b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034c0:	00 00 00 
  initlock(&p->lock, "pipe");
801034c3:	68 3b 84 10 80       	push   $0x8010843b
801034c8:	50                   	push   %eax
801034c9:	e8 d2 10 00 00       	call   801045a0 <initlock>
  (*f0)->type = FD_PIPE;
801034ce:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034d0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034d9:	8b 03                	mov    (%ebx),%eax
801034db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034df:	8b 03                	mov    (%ebx),%eax
801034e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034e5:	8b 03                	mov    (%ebx),%eax
801034e7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ea:	8b 06                	mov    (%esi),%eax
801034ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034f2:	8b 06                	mov    (%esi),%eax
801034f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034f8:	8b 06                	mov    (%esi),%eax
801034fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034fe:	8b 06                	mov    (%esi),%eax
80103500:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103503:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103506:	31 c0                	xor    %eax,%eax
}
80103508:	5b                   	pop    %ebx
80103509:	5e                   	pop    %esi
8010350a:	5f                   	pop    %edi
8010350b:	5d                   	pop    %ebp
8010350c:	c3                   	ret    
8010350d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103510:	8b 03                	mov    (%ebx),%eax
80103512:	85 c0                	test   %eax,%eax
80103514:	74 1e                	je     80103534 <pipealloc+0xe4>
    fileclose(*f0);
80103516:	83 ec 0c             	sub    $0xc,%esp
80103519:	50                   	push   %eax
8010351a:	e8 d1 d9 ff ff       	call   80100ef0 <fileclose>
8010351f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103522:	8b 06                	mov    (%esi),%eax
80103524:	85 c0                	test   %eax,%eax
80103526:	74 0c                	je     80103534 <pipealloc+0xe4>
    fileclose(*f1);
80103528:	83 ec 0c             	sub    $0xc,%esp
8010352b:	50                   	push   %eax
8010352c:	e8 bf d9 ff ff       	call   80100ef0 <fileclose>
80103531:	83 c4 10             	add    $0x10,%esp
}
80103534:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010353c:	5b                   	pop    %ebx
8010353d:	5e                   	pop    %esi
8010353e:	5f                   	pop    %edi
8010353f:	5d                   	pop    %ebp
80103540:	c3                   	ret    
80103541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103548:	8b 03                	mov    (%ebx),%eax
8010354a:	85 c0                	test   %eax,%eax
8010354c:	75 c8                	jne    80103516 <pipealloc+0xc6>
8010354e:	eb d2                	jmp    80103522 <pipealloc+0xd2>

80103550 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103558:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	53                   	push   %ebx
8010355f:	e8 0c 12 00 00       	call   80104770 <acquire>
  if(writable){
80103564:	83 c4 10             	add    $0x10,%esp
80103567:	85 f6                	test   %esi,%esi
80103569:	74 65                	je     801035d0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010356b:	83 ec 0c             	sub    $0xc,%esp
8010356e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103574:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010357b:	00 00 00 
    wakeup(&p->nread);
8010357e:	50                   	push   %eax
8010357f:	e8 4c 0d 00 00       	call   801042d0 <wakeup>
80103584:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103587:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010358d:	85 d2                	test   %edx,%edx
8010358f:	75 0a                	jne    8010359b <pipeclose+0x4b>
80103591:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103597:	85 c0                	test   %eax,%eax
80103599:	74 15                	je     801035b0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010359b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010359e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a1:	5b                   	pop    %ebx
801035a2:	5e                   	pop    %esi
801035a3:	5d                   	pop    %ebp
    release(&p->lock);
801035a4:	e9 67 11 00 00       	jmp    80104710 <release>
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	53                   	push   %ebx
801035b4:	e8 57 11 00 00       	call   80104710 <release>
    kfree((char*)p);
801035b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035bc:	83 c4 10             	add    $0x10,%esp
}
801035bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c2:	5b                   	pop    %ebx
801035c3:	5e                   	pop    %esi
801035c4:	5d                   	pop    %ebp
    kfree((char*)p);
801035c5:	e9 16 ef ff ff       	jmp    801024e0 <kfree>
801035ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035e0:	00 00 00 
    wakeup(&p->nwrite);
801035e3:	50                   	push   %eax
801035e4:	e8 e7 0c 00 00       	call   801042d0 <wakeup>
801035e9:	83 c4 10             	add    $0x10,%esp
801035ec:	eb 99                	jmp    80103587 <pipeclose+0x37>
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 28             	sub    $0x28,%esp
801035f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035fc:	53                   	push   %ebx
801035fd:	e8 6e 11 00 00       	call   80104770 <acquire>
  for(i = 0; i < n; i++){
80103602:	8b 45 10             	mov    0x10(%ebp),%eax
80103605:	83 c4 10             	add    $0x10,%esp
80103608:	85 c0                	test   %eax,%eax
8010360a:	0f 8e c0 00 00 00    	jle    801036d0 <pipewrite+0xe0>
80103610:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103613:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103619:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010361f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103622:	03 45 10             	add    0x10(%ebp),%eax
80103625:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103628:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010362e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103634:	89 ca                	mov    %ecx,%edx
80103636:	05 00 02 00 00       	add    $0x200,%eax
8010363b:	39 c1                	cmp    %eax,%ecx
8010363d:	74 3f                	je     8010367e <pipewrite+0x8e>
8010363f:	eb 67                	jmp    801036a8 <pipewrite+0xb8>
80103641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103648:	e8 53 03 00 00       	call   801039a0 <myproc>
8010364d:	8b 48 24             	mov    0x24(%eax),%ecx
80103650:	85 c9                	test   %ecx,%ecx
80103652:	75 34                	jne    80103688 <pipewrite+0x98>
      wakeup(&p->nread);
80103654:	83 ec 0c             	sub    $0xc,%esp
80103657:	57                   	push   %edi
80103658:	e8 73 0c 00 00       	call   801042d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010365d:	58                   	pop    %eax
8010365e:	5a                   	pop    %edx
8010365f:	53                   	push   %ebx
80103660:	56                   	push   %esi
80103661:	e8 aa 0b 00 00       	call   80104210 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103666:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010366c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103672:	83 c4 10             	add    $0x10,%esp
80103675:	05 00 02 00 00       	add    $0x200,%eax
8010367a:	39 c2                	cmp    %eax,%edx
8010367c:	75 2a                	jne    801036a8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010367e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103684:	85 c0                	test   %eax,%eax
80103686:	75 c0                	jne    80103648 <pipewrite+0x58>
        release(&p->lock);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	53                   	push   %ebx
8010368c:	e8 7f 10 00 00       	call   80104710 <release>
        return -1;
80103691:	83 c4 10             	add    $0x10,%esp
80103694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5f                   	pop    %edi
8010369f:	5d                   	pop    %ebp
801036a0:	c3                   	ret    
801036a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036ab:	8d 4a 01             	lea    0x1(%edx),%ecx
801036ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036b4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ba:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036bd:	83 c6 01             	add    $0x1,%esi
801036c0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036c3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036c7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ca:	0f 85 58 ff ff ff    	jne    80103628 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036d9:	50                   	push   %eax
801036da:	e8 f1 0b 00 00       	call   801042d0 <wakeup>
  release(&p->lock);
801036df:	89 1c 24             	mov    %ebx,(%esp)
801036e2:	e8 29 10 00 00       	call   80104710 <release>
  return n;
801036e7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	eb aa                	jmp    80103699 <pipewrite+0xa9>
801036ef:	90                   	nop

801036f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
801036f5:	53                   	push   %ebx
801036f6:	83 ec 18             	sub    $0x18,%esp
801036f9:	8b 75 08             	mov    0x8(%ebp),%esi
801036fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ff:	56                   	push   %esi
80103700:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103706:	e8 65 10 00 00       	call   80104770 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103711:	83 c4 10             	add    $0x10,%esp
80103714:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010371a:	74 2f                	je     8010374b <piperead+0x5b>
8010371c:	eb 37                	jmp    80103755 <piperead+0x65>
8010371e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103720:	e8 7b 02 00 00       	call   801039a0 <myproc>
80103725:	8b 48 24             	mov    0x24(%eax),%ecx
80103728:	85 c9                	test   %ecx,%ecx
8010372a:	0f 85 80 00 00 00    	jne    801037b0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103730:	83 ec 08             	sub    $0x8,%esp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx
80103735:	e8 d6 0a 00 00       	call   80104210 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010373a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103740:	83 c4 10             	add    $0x10,%esp
80103743:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103749:	75 0a                	jne    80103755 <piperead+0x65>
8010374b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103751:	85 c0                	test   %eax,%eax
80103753:	75 cb                	jne    80103720 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103755:	8b 55 10             	mov    0x10(%ebp),%edx
80103758:	31 db                	xor    %ebx,%ebx
8010375a:	85 d2                	test   %edx,%edx
8010375c:	7f 20                	jg     8010377e <piperead+0x8e>
8010375e:	eb 2c                	jmp    8010378c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103760:	8d 48 01             	lea    0x1(%eax),%ecx
80103763:	25 ff 01 00 00       	and    $0x1ff,%eax
80103768:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010376e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103773:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103776:	83 c3 01             	add    $0x1,%ebx
80103779:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010377c:	74 0e                	je     8010378c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010377e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103784:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010378a:	75 d4                	jne    80103760 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010378c:	83 ec 0c             	sub    $0xc,%esp
8010378f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103795:	50                   	push   %eax
80103796:	e8 35 0b 00 00       	call   801042d0 <wakeup>
  release(&p->lock);
8010379b:	89 34 24             	mov    %esi,(%esp)
8010379e:	e8 6d 0f 00 00       	call   80104710 <release>
  return i;
801037a3:	83 c4 10             	add    $0x10,%esp
}
801037a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a9:	89 d8                	mov    %ebx,%eax
801037ab:	5b                   	pop    %ebx
801037ac:	5e                   	pop    %esi
801037ad:	5f                   	pop    %edi
801037ae:	5d                   	pop    %ebp
801037af:	c3                   	ret    
      release(&p->lock);
801037b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037b8:	56                   	push   %esi
801037b9:	e8 52 0f 00 00       	call   80104710 <release>
      return -1;
801037be:	83 c4 10             	add    $0x10,%esp
}
801037c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c4:	89 d8                	mov    %ebx,%eax
801037c6:	5b                   	pop    %ebx
801037c7:	5e                   	pop    %esi
801037c8:	5f                   	pop    %edi
801037c9:	5d                   	pop    %ebp
801037ca:	c3                   	ret    
801037cb:	66 90                	xchg   %ax,%ax
801037cd:	66 90                	xchg   %ax,%ax
801037cf:	90                   	nop

801037d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037dc:	68 20 2d 11 80       	push   $0x80112d20
801037e1:	e8 8a 0f 00 00       	call   80104770 <acquire>
801037e6:	83 c4 10             	add    $0x10,%esp
801037e9:	eb 17                	jmp    80103802 <allocproc+0x32>
801037eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037ef:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f0:	81 c3 00 02 00 00    	add    $0x200,%ebx
801037f6:	81 fb 54 ad 11 80    	cmp    $0x8011ad54,%ebx
801037fc:	0f 84 7e 00 00 00    	je     80103880 <allocproc+0xb0>
    if(p->state == UNUSED)
80103802:	8b 43 0c             	mov    0xc(%ebx),%eax
80103805:	85 c0                	test   %eax,%eax
80103807:	75 e7                	jne    801037f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103809:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010380e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103811:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103818:	89 43 10             	mov    %eax,0x10(%ebx)
8010381b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010381e:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103823:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103829:	e8 e2 0e 00 00       	call   80104710 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010382e:	e8 6d ee ff ff       	call   801026a0 <kalloc>
80103833:	83 c4 10             	add    $0x10,%esp
80103836:	89 43 08             	mov    %eax,0x8(%ebx)
80103839:	85 c0                	test   %eax,%eax
8010383b:	74 5c                	je     80103899 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010383d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103843:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103846:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010384b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010384e:	c7 40 14 32 5f 10 80 	movl   $0x80105f32,0x14(%eax)
  p->context = (struct context*)sp;
80103855:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103858:	6a 14                	push   $0x14
8010385a:	6a 00                	push   $0x0
8010385c:	50                   	push   %eax
8010385d:	e8 ce 0f 00 00       	call   80104830 <memset>
  p->context->eip = (uint)forkret;
80103862:	8b 43 1c             	mov    0x1c(%ebx),%eax
  // inialize wmapCount to 0
  p->num_mmaps = 0;
  return p;
80103865:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103868:	c7 40 10 b0 38 10 80 	movl   $0x801038b0,0x10(%eax)
}
8010386f:	89 d8                	mov    %ebx,%eax
  p->num_mmaps = 0;
80103871:	c7 83 fc 01 00 00 00 	movl   $0x0,0x1fc(%ebx)
80103878:	00 00 00 
}
8010387b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010387e:	c9                   	leave  
8010387f:	c3                   	ret    
  release(&ptable.lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103883:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103885:	68 20 2d 11 80       	push   $0x80112d20
8010388a:	e8 81 0e 00 00       	call   80104710 <release>
}
8010388f:	89 d8                	mov    %ebx,%eax
  return 0;
80103891:	83 c4 10             	add    $0x10,%esp
}
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
    p->state = UNUSED;
80103899:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038a0:	31 db                	xor    %ebx,%ebx
}
801038a2:	89 d8                	mov    %ebx,%eax
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038b6:	68 20 2d 11 80       	push   $0x80112d20
801038bb:	e8 50 0e 00 00       	call   80104710 <release>

  if (first) {
801038c0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	85 c0                	test   %eax,%eax
801038ca:	75 04                	jne    801038d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038cc:	c9                   	leave  
801038cd:	c3                   	ret    
801038ce:	66 90                	xchg   %ax,%ax
    first = 0;
801038d0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038d7:	00 00 00 
    iinit(ROOTDEV);
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	6a 01                	push   $0x1
801038df:	e8 9c dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
801038e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038eb:	e8 f0 f3 ff ff       	call   80102ce0 <initlog>
}
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	c9                   	leave  
801038f4:	c3                   	ret    
801038f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103900 <pinit>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103906:	68 40 84 10 80       	push   $0x80108440
8010390b:	68 20 2d 11 80       	push   $0x80112d20
80103910:	e8 8b 0c 00 00       	call   801045a0 <initlock>
}
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	c9                   	leave  
80103919:	c3                   	ret    
8010391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103920 <mycpu>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103925:	9c                   	pushf  
80103926:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103927:	f6 c4 02             	test   $0x2,%ah
8010392a:	75 46                	jne    80103972 <mycpu+0x52>
  apicid = lapicid();
8010392c:	e8 df ef ff ff       	call   80102910 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103931:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103937:	85 f6                	test   %esi,%esi
80103939:	7e 2a                	jle    80103965 <mycpu+0x45>
8010393b:	31 d2                	xor    %edx,%edx
8010393d:	eb 08                	jmp    80103947 <mycpu+0x27>
8010393f:	90                   	nop
80103940:	83 c2 01             	add    $0x1,%edx
80103943:	39 f2                	cmp    %esi,%edx
80103945:	74 1e                	je     80103965 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103947:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010394d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103954:	39 c3                	cmp    %eax,%ebx
80103956:	75 e8                	jne    80103940 <mycpu+0x20>
}
80103958:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010395b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103961:	5b                   	pop    %ebx
80103962:	5e                   	pop    %esi
80103963:	5d                   	pop    %ebp
80103964:	c3                   	ret    
  panic("unknown apicid\n");
80103965:	83 ec 0c             	sub    $0xc,%esp
80103968:	68 47 84 10 80       	push   $0x80108447
8010396d:	e8 0e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103972:	83 ec 0c             	sub    $0xc,%esp
80103975:	68 24 85 10 80       	push   $0x80108524
8010397a:	e8 01 ca ff ff       	call   80100380 <panic>
8010397f:	90                   	nop

80103980 <cpuid>:
cpuid() {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103986:	e8 95 ff ff ff       	call   80103920 <mycpu>
}
8010398b:	c9                   	leave  
  return mycpu()-cpus;
8010398c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103991:	c1 f8 04             	sar    $0x4,%eax
80103994:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010399a:	c3                   	ret    
8010399b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop

801039a0 <myproc>:
myproc(void) {
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
801039a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039a7:	e8 74 0c 00 00       	call   80104620 <pushcli>
  c = mycpu();
801039ac:	e8 6f ff ff ff       	call   80103920 <mycpu>
  p = c->proc;
801039b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039b7:	e8 b4 0c 00 00       	call   80104670 <popcli>
}
801039bc:	89 d8                	mov    %ebx,%eax
801039be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039c1:	c9                   	leave  
801039c2:	c3                   	ret    
801039c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039d0 <userinit>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
801039d4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039d7:	e8 f4 fd ff ff       	call   801037d0 <allocproc>
801039dc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039de:	a3 54 ad 11 80       	mov    %eax,0x8011ad54
  if((p->pgdir = setupkvm()) == 0)
801039e3:	e8 a8 3d 00 00       	call   80107790 <setupkvm>
801039e8:	89 43 04             	mov    %eax,0x4(%ebx)
801039eb:	85 c0                	test   %eax,%eax
801039ed:	0f 84 bd 00 00 00    	je     80103ab0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039f3:	83 ec 04             	sub    $0x4,%esp
801039f6:	68 2c 00 00 00       	push   $0x2c
801039fb:	68 60 b4 10 80       	push   $0x8010b460
80103a00:	50                   	push   %eax
80103a01:	e8 3a 3a 00 00       	call   80107440 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a0f:	6a 4c                	push   $0x4c
80103a11:	6a 00                	push   $0x0
80103a13:	ff 73 18             	push   0x18(%ebx)
80103a16:	e8 15 0e 00 00       	call   80104830 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a23:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a26:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a41:	8b 43 18             	mov    0x18(%ebx),%eax
80103a44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a56:	8b 43 18             	mov    0x18(%ebx),%eax
80103a59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a60:	8b 43 18             	mov    0x18(%ebx),%eax
80103a63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a6d:	6a 10                	push   $0x10
80103a6f:	68 70 84 10 80       	push   $0x80108470
80103a74:	50                   	push   %eax
80103a75:	e8 76 0f 00 00       	call   801049f0 <safestrcpy>
  p->cwd = namei("/");
80103a7a:	c7 04 24 79 84 10 80 	movl   $0x80108479,(%esp)
80103a81:	e8 3a e6 ff ff       	call   801020c0 <namei>
80103a86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a90:	e8 db 0c 00 00       	call   80104770 <acquire>
  p->state = RUNNABLE;
80103a95:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a9c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103aa3:	e8 68 0c 00 00       	call   80104710 <release>
}
80103aa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aab:	83 c4 10             	add    $0x10,%esp
80103aae:	c9                   	leave  
80103aaf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	68 57 84 10 80       	push   $0x80108457
80103ab8:	e8 c3 c8 ff ff       	call   80100380 <panic>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi

80103ac0 <growproc>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
80103ac5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ac8:	e8 53 0b 00 00       	call   80104620 <pushcli>
  c = mycpu();
80103acd:	e8 4e fe ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103ad2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad8:	e8 93 0b 00 00       	call   80104670 <popcli>
  sz = curproc->sz;
80103add:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103adf:	85 f6                	test   %esi,%esi
80103ae1:	7f 1d                	jg     80103b00 <growproc+0x40>
  } else if(n < 0){
80103ae3:	75 3b                	jne    80103b20 <growproc+0x60>
  switchuvm(curproc);
80103ae5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ae8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aea:	53                   	push   %ebx
80103aeb:	e8 40 38 00 00       	call   80107330 <switchuvm>
  return 0;
80103af0:	83 c4 10             	add    $0x10,%esp
80103af3:	31 c0                	xor    %eax,%eax
}
80103af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103af8:	5b                   	pop    %ebx
80103af9:	5e                   	pop    %esi
80103afa:	5d                   	pop    %ebp
80103afb:	c3                   	ret    
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	push   0x4(%ebx)
80103b0a:	e8 a1 3a 00 00       	call   801075b0 <allocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 cf                	jne    80103ae5 <growproc+0x25>
      return -1;
80103b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b1b:	eb d8                	jmp    80103af5 <growproc+0x35>
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	push   0x4(%ebx)
80103b2a:	e8 b1 3b 00 00       	call   801076e0 <deallocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 af                	jne    80103ae5 <growproc+0x25>
80103b36:	eb de                	jmp    80103b16 <growproc+0x56>
80103b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b3f:	90                   	nop

80103b40 <fork>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	57                   	push   %edi
80103b44:	56                   	push   %esi
80103b45:	53                   	push   %ebx
80103b46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b49:	e8 d2 0a 00 00       	call   80104620 <pushcli>
  c = mycpu();
80103b4e:	e8 cd fd ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103b53:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103b59:	89 45 dc             	mov    %eax,-0x24(%ebp)
  popcli();
80103b5c:	e8 0f 0b 00 00       	call   80104670 <popcli>
  if((np = allocproc()) == 0){
80103b61:	e8 6a fc ff ff       	call   801037d0 <allocproc>
80103b66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b69:	85 c0                	test   %eax,%eax
80103b6b:	0f 84 ab 00 00 00    	je     80103c1c <fork+0xdc>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103b74:	83 ec 08             	sub    $0x8,%esp
80103b77:	ff 30                	push   (%eax)
80103b79:	ff 70 04             	push   0x4(%eax)
80103b7c:	e8 ff 3c 00 00       	call   80107880 <copyuvm>
80103b81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b84:	83 c4 10             	add    $0x10,%esp
80103b87:	89 42 04             	mov    %eax,0x4(%edx)
80103b8a:	85 c0                	test   %eax,%eax
80103b8c:	0f 84 f6 01 00 00    	je     80103d88 <fork+0x248>
80103b92:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103b95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b98:	8d 70 7c             	lea    0x7c(%eax),%esi
80103b9b:	05 fc 01 00 00       	add    $0x1fc,%eax
80103ba0:	8d 7a 7c             	lea    0x7c(%edx),%edi
80103ba3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103ba6:	eb 1b                	jmp    80103bc3 <fork+0x83>
80103ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103baf:	90                   	nop
          } else if (curproc->mmaps[i].flags & MAP_SHARED) {
80103bb0:	a8 02                	test   $0x2,%al
80103bb2:	75 7c                	jne    80103c30 <fork+0xf0>
  for (i = 0; i < MAX_WMMAP_INFO; i++) {
80103bb4:	83 c6 18             	add    $0x18,%esi
80103bb7:	83 c7 18             	add    $0x18,%edi
80103bba:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103bbd:	0f 84 15 01 00 00    	je     80103cd8 <fork+0x198>
      if (curproc->mmaps[i].used) {
80103bc3:	8b 46 0c             	mov    0xc(%esi),%eax
80103bc6:	85 c0                	test   %eax,%eax
80103bc8:	74 ea                	je     80103bb4 <fork+0x74>
          if (curproc->mmaps[i].flags & MAP_PRIVATE) {
80103bca:	8b 46 08             	mov    0x8(%esi),%eax
80103bcd:	a8 01                	test   $0x1,%al
80103bcf:	74 df                	je     80103bb0 <fork+0x70>
              np->mmaps[i] = curproc->mmaps[i];
80103bd1:	8b 06                	mov    (%esi),%eax
              np->mmaps[i].addr = find_available_region(np, np->mmaps[i].length);
80103bd3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bd6:	83 ec 08             	sub    $0x8,%esp
              np->mmaps[i] = curproc->mmaps[i];
80103bd9:	89 07                	mov    %eax,(%edi)
80103bdb:	8b 46 04             	mov    0x4(%esi),%eax
80103bde:	89 47 04             	mov    %eax,0x4(%edi)
80103be1:	8b 56 08             	mov    0x8(%esi),%edx
80103be4:	89 57 08             	mov    %edx,0x8(%edi)
80103be7:	8b 56 0c             	mov    0xc(%esi),%edx
80103bea:	89 57 0c             	mov    %edx,0xc(%edi)
80103bed:	8b 56 10             	mov    0x10(%esi),%edx
80103bf0:	89 57 10             	mov    %edx,0x10(%edi)
80103bf3:	8b 56 14             	mov    0x14(%esi),%edx
80103bf6:	89 57 14             	mov    %edx,0x14(%edi)
              np->mmaps[i].addr = find_available_region(np, np->mmaps[i].length);
80103bf9:	50                   	push   %eax
80103bfa:	53                   	push   %ebx
80103bfb:	e8 d0 3e 00 00       	call   80107ad0 <find_available_region>
              if (np->mmaps[i].addr == 0) {
80103c00:	83 c4 10             	add    $0x10,%esp
              np->mmaps[i].addr = find_available_region(np, np->mmaps[i].length);
80103c03:	89 07                	mov    %eax,(%edi)
              if (np->mmaps[i].addr == 0) {
80103c05:	85 c0                	test   %eax,%eax
80103c07:	74 13                	je     80103c1c <fork+0xdc>
              if (copy_mapping(np, curproc->mmaps[i].addr, curproc->mmaps[i].length, np->mmaps[i].addr) < 0) {
80103c09:	50                   	push   %eax
80103c0a:	ff 76 04             	push   0x4(%esi)
80103c0d:	ff 36                	push   (%esi)
80103c0f:	53                   	push   %ebx
80103c10:	e8 eb 41 00 00       	call   80107e00 <copy_mapping>
80103c15:	83 c4 10             	add    $0x10,%esp
80103c18:	85 c0                	test   %eax,%eax
80103c1a:	79 98                	jns    80103bb4 <fork+0x74>
}
80103c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80103c1f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80103c24:	89 d8                	mov    %ebx,%eax
80103c26:	5b                   	pop    %ebx
80103c27:	5e                   	pop    %esi
80103c28:	5f                   	pop    %edi
80103c29:	5d                   	pop    %ebp
80103c2a:	c3                   	ret    
80103c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c2f:	90                   	nop
            np->mmaps[i] = curproc->mmaps[i];
80103c30:	8b 06                	mov    (%esi),%eax
80103c32:	89 07                	mov    %eax,(%edi)
80103c34:	8b 46 04             	mov    0x4(%esi),%eax
80103c37:	89 47 04             	mov    %eax,0x4(%edi)
80103c3a:	8b 46 08             	mov    0x8(%esi),%eax
80103c3d:	89 47 08             	mov    %eax,0x8(%edi)
80103c40:	8b 46 0c             	mov    0xc(%esi),%eax
80103c43:	89 47 0c             	mov    %eax,0xc(%edi)
80103c46:	8b 46 10             	mov    0x10(%esi),%eax
80103c49:	89 47 10             	mov    %eax,0x10(%edi)
80103c4c:	8b 46 14             	mov    0x14(%esi),%eax
80103c4f:	89 47 14             	mov    %eax,0x14(%edi)
            for (uint va = curproc->mmaps[i].addr; va < curproc->mmaps[i].addr + curproc->mmaps[i].length; va += PGSIZE) {
80103c52:	8b 1e                	mov    (%esi),%ebx
80103c54:	8b 46 04             	mov    0x4(%esi),%eax
80103c57:	01 d8                	add    %ebx,%eax
80103c59:	39 c3                	cmp    %eax,%ebx
80103c5b:	0f 83 53 ff ff ff    	jae    80103bb4 <fork+0x74>
80103c61:	89 7d d8             	mov    %edi,-0x28(%ebp)
80103c64:	8b 7d dc             	mov    -0x24(%ebp),%edi
80103c67:	eb 4e                	jmp    80103cb7 <fork+0x177>
80103c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                if (!pte || !(*pte & PTE_P)) {
80103c70:	8b 00                	mov    (%eax),%eax
80103c72:	a8 01                	test   $0x1,%al
80103c74:	74 a6                	je     80103c1c <fork+0xdc>
                if (mappages(np->pgdir, (void *)va, PGSIZE, PTE_ADDR(*pte), *pte & PTE_FLAGS(*pte)) < 0) {
80103c76:	89 c1                	mov    %eax,%ecx
80103c78:	83 ec 0c             	sub    $0xc,%esp
80103c7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80103c80:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
80103c86:	51                   	push   %ecx
80103c87:	50                   	push   %eax
80103c88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c8b:	68 00 10 00 00       	push   $0x1000
80103c90:	53                   	push   %ebx
80103c91:	ff 70 04             	push   0x4(%eax)
80103c94:	e8 97 35 00 00       	call   80107230 <mappages>
80103c99:	83 c4 20             	add    $0x20,%esp
80103c9c:	85 c0                	test   %eax,%eax
80103c9e:	0f 88 78 ff ff ff    	js     80103c1c <fork+0xdc>
            for (uint va = curproc->mmaps[i].addr; va < curproc->mmaps[i].addr + curproc->mmaps[i].length; va += PGSIZE) {
80103ca4:	8b 46 04             	mov    0x4(%esi),%eax
80103ca7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103cad:	03 06                	add    (%esi),%eax
80103caf:	39 d8                	cmp    %ebx,%eax
80103cb1:	0f 86 c9 00 00 00    	jbe    80103d80 <fork+0x240>
                pte_t *pte = walkpgdir(curproc->pgdir, (void *)va, 0);
80103cb7:	83 ec 04             	sub    $0x4,%esp
80103cba:	6a 00                	push   $0x0
80103cbc:	53                   	push   %ebx
80103cbd:	ff 77 04             	push   0x4(%edi)
80103cc0:	e8 db 34 00 00       	call   801071a0 <walkpgdir>
                if (!pte || !(*pte & PTE_P)) {
80103cc5:	83 c4 10             	add    $0x10,%esp
80103cc8:	85 c0                	test   %eax,%eax
80103cca:	75 a4                	jne    80103c70 <fork+0x130>
80103ccc:	e9 4b ff ff ff       	jmp    80103c1c <fork+0xdc>
80103cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  np->sz = curproc->sz;
80103cd8:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80103cdb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103cde:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103ce3:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80103ce5:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80103ce8:	89 5a 14             	mov    %ebx,0x14(%edx)
  np->sz = curproc->sz;
80103ceb:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103ced:	8b 73 18             	mov    0x18(%ebx),%esi
80103cf0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103cf2:	89 d7                	mov    %edx,%edi
  for(i = 0; i < NOFILE; i++)
80103cf4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cf6:	8b 42 18             	mov    0x18(%edx),%eax
80103cf9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d00:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d04:	85 c0                	test   %eax,%eax
80103d06:	74 10                	je     80103d18 <fork+0x1d8>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d08:	83 ec 0c             	sub    $0xc,%esp
80103d0b:	50                   	push   %eax
80103d0c:	e8 8f d1 ff ff       	call   80100ea0 <filedup>
80103d11:	83 c4 10             	add    $0x10,%esp
80103d14:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d18:	83 c6 01             	add    $0x1,%esi
80103d1b:	83 fe 10             	cmp    $0x10,%esi
80103d1e:	75 e0                	jne    80103d00 <fork+0x1c0>
  np->cwd = idup(curproc->cwd);
80103d20:	8b 7d dc             	mov    -0x24(%ebp),%edi
80103d23:	83 ec 0c             	sub    $0xc,%esp
80103d26:	ff 77 68             	push   0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d29:	8d 5f 6c             	lea    0x6c(%edi),%ebx
  np->cwd = idup(curproc->cwd);
80103d2c:	e8 3f da ff ff       	call   80101770 <idup>
80103d31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d34:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d37:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d3a:	8d 42 6c             	lea    0x6c(%edx),%eax
80103d3d:	89 d7                	mov    %edx,%edi
80103d3f:	6a 10                	push   $0x10
80103d41:	53                   	push   %ebx
80103d42:	50                   	push   %eax
80103d43:	e8 a8 0c 00 00       	call   801049f0 <safestrcpy>
  pid = np->pid;
80103d48:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d4b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d52:	e8 19 0a 00 00       	call   80104770 <acquire>
  np->state = RUNNABLE;
80103d57:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d5e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d65:	e8 a6 09 00 00       	call   80104710 <release>
  return pid;
80103d6a:	83 c4 10             	add    $0x10,%esp
}
80103d6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d70:	89 d8                	mov    %ebx,%eax
80103d72:	5b                   	pop    %ebx
80103d73:	5e                   	pop    %esi
80103d74:	5f                   	pop    %edi
80103d75:	5d                   	pop    %ebp
80103d76:	c3                   	ret    
80103d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d7e:	66 90                	xchg   %ax,%ax
80103d80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80103d83:	e9 2c fe ff ff       	jmp    80103bb4 <fork+0x74>
    kfree(np->kstack);
80103d88:	83 ec 0c             	sub    $0xc,%esp
80103d8b:	ff 72 08             	push   0x8(%edx)
80103d8e:	89 d3                	mov    %edx,%ebx
80103d90:	e8 4b e7 ff ff       	call   801024e0 <kfree>
    np->kstack = 0;
80103d95:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d9c:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d9f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103da6:	e9 71 fe ff ff       	jmp    80103c1c <fork+0xdc>
80103dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103daf:	90                   	nop

80103db0 <scheduler>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103db9:	e8 62 fb ff ff       	call   80103920 <mycpu>
  c->proc = 0;
80103dbe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103dc5:	00 00 00 
  struct cpu *c = mycpu();
80103dc8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103dca:	8d 78 04             	lea    0x4(%eax),%edi
80103dcd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103dd0:	fb                   	sti    
    acquire(&ptable.lock);
80103dd1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dd4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103dd9:	68 20 2d 11 80       	push   $0x80112d20
80103dde:	e8 8d 09 00 00       	call   80104770 <acquire>
80103de3:	83 c4 10             	add    $0x10,%esp
80103de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ded:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103df0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103df4:	75 33                	jne    80103e29 <scheduler+0x79>
      switchuvm(p);
80103df6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103df9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103dff:	53                   	push   %ebx
80103e00:	e8 2b 35 00 00       	call   80107330 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e05:	58                   	pop    %eax
80103e06:	5a                   	pop    %edx
80103e07:	ff 73 1c             	push   0x1c(%ebx)
80103e0a:	57                   	push   %edi
      p->state = RUNNING;
80103e0b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e12:	e8 34 0c 00 00       	call   80104a4b <swtch>
      switchkvm();
80103e17:	e8 04 35 00 00       	call   80107320 <switchkvm>
      c->proc = 0;
80103e1c:	83 c4 10             	add    $0x10,%esp
80103e1f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e26:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e29:	81 c3 00 02 00 00    	add    $0x200,%ebx
80103e2f:	81 fb 54 ad 11 80    	cmp    $0x8011ad54,%ebx
80103e35:	75 b9                	jne    80103df0 <scheduler+0x40>
    release(&ptable.lock);
80103e37:	83 ec 0c             	sub    $0xc,%esp
80103e3a:	68 20 2d 11 80       	push   $0x80112d20
80103e3f:	e8 cc 08 00 00       	call   80104710 <release>
    sti();
80103e44:	83 c4 10             	add    $0x10,%esp
80103e47:	eb 87                	jmp    80103dd0 <scheduler+0x20>
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e50 <sched>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	56                   	push   %esi
80103e54:	53                   	push   %ebx
  pushcli();
80103e55:	e8 c6 07 00 00       	call   80104620 <pushcli>
  c = mycpu();
80103e5a:	e8 c1 fa ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103e5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e65:	e8 06 08 00 00       	call   80104670 <popcli>
  if(!holding(&ptable.lock))
80103e6a:	83 ec 0c             	sub    $0xc,%esp
80103e6d:	68 20 2d 11 80       	push   $0x80112d20
80103e72:	e8 59 08 00 00       	call   801046d0 <holding>
80103e77:	83 c4 10             	add    $0x10,%esp
80103e7a:	85 c0                	test   %eax,%eax
80103e7c:	74 4f                	je     80103ecd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e7e:	e8 9d fa ff ff       	call   80103920 <mycpu>
80103e83:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e8a:	75 68                	jne    80103ef4 <sched+0xa4>
  if(p->state == RUNNING)
80103e8c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e90:	74 55                	je     80103ee7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e92:	9c                   	pushf  
80103e93:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e94:	f6 c4 02             	test   $0x2,%ah
80103e97:	75 41                	jne    80103eda <sched+0x8a>
  intena = mycpu()->intena;
80103e99:	e8 82 fa ff ff       	call   80103920 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e9e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ea1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ea7:	e8 74 fa ff ff       	call   80103920 <mycpu>
80103eac:	83 ec 08             	sub    $0x8,%esp
80103eaf:	ff 70 04             	push   0x4(%eax)
80103eb2:	53                   	push   %ebx
80103eb3:	e8 93 0b 00 00       	call   80104a4b <swtch>
  mycpu()->intena = intena;
80103eb8:	e8 63 fa ff ff       	call   80103920 <mycpu>
}
80103ebd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ec0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ec6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ec9:	5b                   	pop    %ebx
80103eca:	5e                   	pop    %esi
80103ecb:	5d                   	pop    %ebp
80103ecc:	c3                   	ret    
    panic("sched ptable.lock");
80103ecd:	83 ec 0c             	sub    $0xc,%esp
80103ed0:	68 7b 84 10 80       	push   $0x8010847b
80103ed5:	e8 a6 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 a7 84 10 80       	push   $0x801084a7
80103ee2:	e8 99 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103ee7:	83 ec 0c             	sub    $0xc,%esp
80103eea:	68 99 84 10 80       	push   $0x80108499
80103eef:	e8 8c c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	68 8d 84 10 80       	push   $0x8010848d
80103efc:	e8 7f c4 ff ff       	call   80100380 <panic>
80103f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0f:	90                   	nop

80103f10 <exit>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	57                   	push   %edi
80103f14:	56                   	push   %esi
80103f15:	53                   	push   %ebx
80103f16:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103f19:	e8 82 fa ff ff       	call   801039a0 <myproc>
80103f1e:	89 c6                	mov    %eax,%esi
  if(curproc == initproc)
80103f20:	8d 78 7c             	lea    0x7c(%eax),%edi
80103f23:	05 fc 01 00 00       	add    $0x1fc,%eax
80103f28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103f2b:	39 35 54 ad 11 80    	cmp    %esi,0x8011ad54
80103f31:	0f 84 4a 01 00 00    	je     80104081 <exit+0x171>
80103f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f3e:	66 90                	xchg   %ax,%ax
    for (uint va = curproc->mmaps[i].addr; va < curproc->mmaps[i].addr + curproc->mmaps[i].length; va += PGSIZE) {
80103f40:	8b 1f                	mov    (%edi),%ebx
80103f42:	8b 47 04             	mov    0x4(%edi),%eax
80103f45:	01 d8                	add    %ebx,%eax
80103f47:	39 c3                	cmp    %eax,%ebx
80103f49:	73 2b                	jae    80103f76 <exit+0x66>
80103f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f4f:	90                   	nop
        pte_t *pte = walkpgdir(curproc->pgdir, (void *)va, 0);
80103f50:	83 ec 04             	sub    $0x4,%esp
80103f53:	6a 00                	push   $0x0
80103f55:	53                   	push   %ebx
    for (uint va = curproc->mmaps[i].addr; va < curproc->mmaps[i].addr + curproc->mmaps[i].length; va += PGSIZE) {
80103f56:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        pte_t *pte = walkpgdir(curproc->pgdir, (void *)va, 0);
80103f5c:	ff 76 04             	push   0x4(%esi)
80103f5f:	e8 3c 32 00 00       	call   801071a0 <walkpgdir>
    for (uint va = curproc->mmaps[i].addr; va < curproc->mmaps[i].addr + curproc->mmaps[i].length; va += PGSIZE) {
80103f64:	83 c4 10             	add    $0x10,%esp
        *pte = 0;
80103f67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (uint va = curproc->mmaps[i].addr; va < curproc->mmaps[i].addr + curproc->mmaps[i].length; va += PGSIZE) {
80103f6d:	8b 47 04             	mov    0x4(%edi),%eax
80103f70:	03 07                	add    (%edi),%eax
80103f72:	39 d8                	cmp    %ebx,%eax
80103f74:	77 da                	ja     80103f50 <exit+0x40>
  for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80103f76:	83 c7 18             	add    $0x18,%edi
80103f79:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80103f7c:	75 c2                	jne    80103f40 <exit+0x30>
80103f7e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103f81:	8d 7e 68             	lea    0x68(%esi),%edi
80103f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103f88:	8b 03                	mov    (%ebx),%eax
80103f8a:	85 c0                	test   %eax,%eax
80103f8c:	74 12                	je     80103fa0 <exit+0x90>
      fileclose(curproc->ofile[fd]);
80103f8e:	83 ec 0c             	sub    $0xc,%esp
80103f91:	50                   	push   %eax
80103f92:	e8 59 cf ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103f97:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f9d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103fa0:	83 c3 04             	add    $0x4,%ebx
80103fa3:	39 fb                	cmp    %edi,%ebx
80103fa5:	75 e1                	jne    80103f88 <exit+0x78>
  begin_op();
80103fa7:	e8 d4 ed ff ff       	call   80102d80 <begin_op>
  iput(curproc->cwd);
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	ff 76 68             	push   0x68(%esi)
80103fb2:	e8 19 d9 ff ff       	call   801018d0 <iput>
  end_op();
80103fb7:	e8 34 ee ff ff       	call   80102df0 <end_op>
  curproc->cwd = 0;
80103fbc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103fc3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fca:	e8 a1 07 00 00       	call   80104770 <acquire>
  wakeup1(curproc->parent);
80103fcf:	8b 56 14             	mov    0x14(%esi),%edx
80103fd2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fd5:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103fda:	eb 10                	jmp    80103fec <exit+0xdc>
80103fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fe0:	05 00 02 00 00       	add    $0x200,%eax
80103fe5:	3d 54 ad 11 80       	cmp    $0x8011ad54,%eax
80103fea:	74 1e                	je     8010400a <exit+0xfa>
    if(p->state == SLEEPING && p->chan == chan)
80103fec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ff0:	75 ee                	jne    80103fe0 <exit+0xd0>
80103ff2:	3b 50 20             	cmp    0x20(%eax),%edx
80103ff5:	75 e9                	jne    80103fe0 <exit+0xd0>
      p->state = RUNNABLE;
80103ff7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ffe:	05 00 02 00 00       	add    $0x200,%eax
80104003:	3d 54 ad 11 80       	cmp    $0x8011ad54,%eax
80104008:	75 e2                	jne    80103fec <exit+0xdc>
      p->parent = initproc;
8010400a:	8b 0d 54 ad 11 80    	mov    0x8011ad54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104010:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104015:	eb 17                	jmp    8010402e <exit+0x11e>
80104017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401e:	66 90                	xchg   %ax,%ax
80104020:	81 c2 00 02 00 00    	add    $0x200,%edx
80104026:	81 fa 54 ad 11 80    	cmp    $0x8011ad54,%edx
8010402c:	74 3a                	je     80104068 <exit+0x158>
    if(p->parent == curproc){
8010402e:	39 72 14             	cmp    %esi,0x14(%edx)
80104031:	75 ed                	jne    80104020 <exit+0x110>
      if(p->state == ZOMBIE)
80104033:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104037:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010403a:	75 e4                	jne    80104020 <exit+0x110>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104041:	eb 11                	jmp    80104054 <exit+0x144>
80104043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104047:	90                   	nop
80104048:	05 00 02 00 00       	add    $0x200,%eax
8010404d:	3d 54 ad 11 80       	cmp    $0x8011ad54,%eax
80104052:	74 cc                	je     80104020 <exit+0x110>
    if(p->state == SLEEPING && p->chan == chan)
80104054:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104058:	75 ee                	jne    80104048 <exit+0x138>
8010405a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010405d:	75 e9                	jne    80104048 <exit+0x138>
      p->state = RUNNABLE;
8010405f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104066:	eb e0                	jmp    80104048 <exit+0x138>
  curproc->state = ZOMBIE;
80104068:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010406f:	e8 dc fd ff ff       	call   80103e50 <sched>
  panic("zombie exit");
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	68 c8 84 10 80       	push   $0x801084c8
8010407c:	e8 ff c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104081:	83 ec 0c             	sub    $0xc,%esp
80104084:	68 bb 84 10 80       	push   $0x801084bb
80104089:	e8 f2 c2 ff ff       	call   80100380 <panic>
8010408e:	66 90                	xchg   %ax,%ax

80104090 <wait>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	56                   	push   %esi
80104094:	53                   	push   %ebx
  pushcli();
80104095:	e8 86 05 00 00       	call   80104620 <pushcli>
  c = mycpu();
8010409a:	e8 81 f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
8010409f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040a5:	e8 c6 05 00 00       	call   80104670 <popcli>
  acquire(&ptable.lock);
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	68 20 2d 11 80       	push   $0x80112d20
801040b2:	e8 b9 06 00 00       	call   80104770 <acquire>
801040b7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040ba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040bc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801040c1:	eb 13                	jmp    801040d6 <wait+0x46>
801040c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040c7:	90                   	nop
801040c8:	81 c3 00 02 00 00    	add    $0x200,%ebx
801040ce:	81 fb 54 ad 11 80    	cmp    $0x8011ad54,%ebx
801040d4:	74 1e                	je     801040f4 <wait+0x64>
      if(p->parent != curproc)
801040d6:	39 73 14             	cmp    %esi,0x14(%ebx)
801040d9:	75 ed                	jne    801040c8 <wait+0x38>
      if(p->state == ZOMBIE){
801040db:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040df:	74 5f                	je     80104140 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e1:	81 c3 00 02 00 00    	add    $0x200,%ebx
      havekids = 1;
801040e7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ec:	81 fb 54 ad 11 80    	cmp    $0x8011ad54,%ebx
801040f2:	75 e2                	jne    801040d6 <wait+0x46>
    if(!havekids || curproc->killed){
801040f4:	85 c0                	test   %eax,%eax
801040f6:	0f 84 9a 00 00 00    	je     80104196 <wait+0x106>
801040fc:	8b 46 24             	mov    0x24(%esi),%eax
801040ff:	85 c0                	test   %eax,%eax
80104101:	0f 85 8f 00 00 00    	jne    80104196 <wait+0x106>
  pushcli();
80104107:	e8 14 05 00 00       	call   80104620 <pushcli>
  c = mycpu();
8010410c:	e8 0f f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80104111:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104117:	e8 54 05 00 00       	call   80104670 <popcli>
  if(p == 0)
8010411c:	85 db                	test   %ebx,%ebx
8010411e:	0f 84 89 00 00 00    	je     801041ad <wait+0x11d>
  p->chan = chan;
80104124:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104127:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010412e:	e8 1d fd ff ff       	call   80103e50 <sched>
  p->chan = 0;
80104133:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010413a:	e9 7b ff ff ff       	jmp    801040ba <wait+0x2a>
8010413f:	90                   	nop
        kfree(p->kstack);
80104140:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104143:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104146:	ff 73 08             	push   0x8(%ebx)
80104149:	e8 92 e3 ff ff       	call   801024e0 <kfree>
        p->kstack = 0;
8010414e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104155:	5a                   	pop    %edx
80104156:	ff 73 04             	push   0x4(%ebx)
80104159:	e8 b2 35 00 00       	call   80107710 <freevm>
        p->pid = 0;
8010415e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104165:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010416c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104170:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104177:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010417e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104185:	e8 86 05 00 00       	call   80104710 <release>
        return pid;
8010418a:	83 c4 10             	add    $0x10,%esp
}
8010418d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104190:	89 f0                	mov    %esi,%eax
80104192:	5b                   	pop    %ebx
80104193:	5e                   	pop    %esi
80104194:	5d                   	pop    %ebp
80104195:	c3                   	ret    
      release(&ptable.lock);
80104196:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104199:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010419e:	68 20 2d 11 80       	push   $0x80112d20
801041a3:	e8 68 05 00 00       	call   80104710 <release>
      return -1;
801041a8:	83 c4 10             	add    $0x10,%esp
801041ab:	eb e0                	jmp    8010418d <wait+0xfd>
    panic("sleep");
801041ad:	83 ec 0c             	sub    $0xc,%esp
801041b0:	68 d4 84 10 80       	push   $0x801084d4
801041b5:	e8 c6 c1 ff ff       	call   80100380 <panic>
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041c0 <yield>:
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041c7:	68 20 2d 11 80       	push   $0x80112d20
801041cc:	e8 9f 05 00 00       	call   80104770 <acquire>
  pushcli();
801041d1:	e8 4a 04 00 00       	call   80104620 <pushcli>
  c = mycpu();
801041d6:	e8 45 f7 ff ff       	call   80103920 <mycpu>
  p = c->proc;
801041db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041e1:	e8 8a 04 00 00       	call   80104670 <popcli>
  myproc()->state = RUNNABLE;
801041e6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041ed:	e8 5e fc ff ff       	call   80103e50 <sched>
  release(&ptable.lock);
801041f2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801041f9:	e8 12 05 00 00       	call   80104710 <release>
}
801041fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104201:	83 c4 10             	add    $0x10,%esp
80104204:	c9                   	leave  
80104205:	c3                   	ret    
80104206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420d:	8d 76 00             	lea    0x0(%esi),%esi

80104210 <sleep>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	53                   	push   %ebx
80104216:	83 ec 0c             	sub    $0xc,%esp
80104219:	8b 7d 08             	mov    0x8(%ebp),%edi
8010421c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010421f:	e8 fc 03 00 00       	call   80104620 <pushcli>
  c = mycpu();
80104224:	e8 f7 f6 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80104229:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010422f:	e8 3c 04 00 00       	call   80104670 <popcli>
  if(p == 0)
80104234:	85 db                	test   %ebx,%ebx
80104236:	0f 84 87 00 00 00    	je     801042c3 <sleep+0xb3>
  if(lk == 0)
8010423c:	85 f6                	test   %esi,%esi
8010423e:	74 76                	je     801042b6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104240:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104246:	74 50                	je     80104298 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104248:	83 ec 0c             	sub    $0xc,%esp
8010424b:	68 20 2d 11 80       	push   $0x80112d20
80104250:	e8 1b 05 00 00       	call   80104770 <acquire>
    release(lk);
80104255:	89 34 24             	mov    %esi,(%esp)
80104258:	e8 b3 04 00 00       	call   80104710 <release>
  p->chan = chan;
8010425d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104260:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104267:	e8 e4 fb ff ff       	call   80103e50 <sched>
  p->chan = 0;
8010426c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104273:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010427a:	e8 91 04 00 00       	call   80104710 <release>
    acquire(lk);
8010427f:	89 75 08             	mov    %esi,0x8(%ebp)
80104282:	83 c4 10             	add    $0x10,%esp
}
80104285:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104288:	5b                   	pop    %ebx
80104289:	5e                   	pop    %esi
8010428a:	5f                   	pop    %edi
8010428b:	5d                   	pop    %ebp
    acquire(lk);
8010428c:	e9 df 04 00 00       	jmp    80104770 <acquire>
80104291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104298:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010429b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042a2:	e8 a9 fb ff ff       	call   80103e50 <sched>
  p->chan = 0;
801042a7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b1:	5b                   	pop    %ebx
801042b2:	5e                   	pop    %esi
801042b3:	5f                   	pop    %edi
801042b4:	5d                   	pop    %ebp
801042b5:	c3                   	ret    
    panic("sleep without lk");
801042b6:	83 ec 0c             	sub    $0xc,%esp
801042b9:	68 da 84 10 80       	push   $0x801084da
801042be:	e8 bd c0 ff ff       	call   80100380 <panic>
    panic("sleep");
801042c3:	83 ec 0c             	sub    $0xc,%esp
801042c6:	68 d4 84 10 80       	push   $0x801084d4
801042cb:	e8 b0 c0 ff ff       	call   80100380 <panic>

801042d0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 10             	sub    $0x10,%esp
801042d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042da:	68 20 2d 11 80       	push   $0x80112d20
801042df:	e8 8c 04 00 00       	call   80104770 <acquire>
801042e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042e7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801042ec:	eb 0e                	jmp    801042fc <wakeup+0x2c>
801042ee:	66 90                	xchg   %ax,%ax
801042f0:	05 00 02 00 00       	add    $0x200,%eax
801042f5:	3d 54 ad 11 80       	cmp    $0x8011ad54,%eax
801042fa:	74 1e                	je     8010431a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801042fc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104300:	75 ee                	jne    801042f0 <wakeup+0x20>
80104302:	3b 58 20             	cmp    0x20(%eax),%ebx
80104305:	75 e9                	jne    801042f0 <wakeup+0x20>
      p->state = RUNNABLE;
80104307:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010430e:	05 00 02 00 00       	add    $0x200,%eax
80104313:	3d 54 ad 11 80       	cmp    $0x8011ad54,%eax
80104318:	75 e2                	jne    801042fc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010431a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104321:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104324:	c9                   	leave  
  release(&ptable.lock);
80104325:	e9 e6 03 00 00       	jmp    80104710 <release>
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 10             	sub    $0x10,%esp
80104337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010433a:	68 20 2d 11 80       	push   $0x80112d20
8010433f:	e8 2c 04 00 00       	call   80104770 <acquire>
80104344:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104347:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010434c:	eb 0e                	jmp    8010435c <kill+0x2c>
8010434e:	66 90                	xchg   %ax,%ax
80104350:	05 00 02 00 00       	add    $0x200,%eax
80104355:	3d 54 ad 11 80       	cmp    $0x8011ad54,%eax
8010435a:	74 34                	je     80104390 <kill+0x60>
    if(p->pid == pid){
8010435c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010435f:	75 ef                	jne    80104350 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104361:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104365:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010436c:	75 07                	jne    80104375 <kill+0x45>
        p->state = RUNNABLE;
8010436e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104375:	83 ec 0c             	sub    $0xc,%esp
80104378:	68 20 2d 11 80       	push   $0x80112d20
8010437d:	e8 8e 03 00 00       	call   80104710 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104385:	83 c4 10             	add    $0x10,%esp
80104388:	31 c0                	xor    %eax,%eax
}
8010438a:	c9                   	leave  
8010438b:	c3                   	ret    
8010438c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104390:	83 ec 0c             	sub    $0xc,%esp
80104393:	68 20 2d 11 80       	push   $0x80112d20
80104398:	e8 73 03 00 00       	call   80104710 <release>
}
8010439d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043a0:	83 c4 10             	add    $0x10,%esp
801043a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043a8:	c9                   	leave  
801043a9:	c3                   	ret    
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	57                   	push   %edi
801043b4:	56                   	push   %esi
801043b5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043b8:	53                   	push   %ebx
801043b9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801043be:	83 ec 3c             	sub    $0x3c,%esp
801043c1:	eb 27                	jmp    801043ea <procdump+0x3a>
801043c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043c7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	68 e7 88 10 80       	push   $0x801088e7
801043d0:	e8 cb c2 ff ff       	call   801006a0 <cprintf>
801043d5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d8:	81 c3 00 02 00 00    	add    $0x200,%ebx
801043de:	81 fb c0 ad 11 80    	cmp    $0x8011adc0,%ebx
801043e4:	0f 84 7e 00 00 00    	je     80104468 <procdump+0xb8>
    if(p->state == UNUSED)
801043ea:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043ed:	85 c0                	test   %eax,%eax
801043ef:	74 e7                	je     801043d8 <procdump+0x28>
      state = "???";
801043f1:	ba eb 84 10 80       	mov    $0x801084eb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043f6:	83 f8 05             	cmp    $0x5,%eax
801043f9:	77 11                	ja     8010440c <procdump+0x5c>
801043fb:	8b 14 85 4c 85 10 80 	mov    -0x7fef7ab4(,%eax,4),%edx
      state = "???";
80104402:	b8 eb 84 10 80       	mov    $0x801084eb,%eax
80104407:	85 d2                	test   %edx,%edx
80104409:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010440c:	53                   	push   %ebx
8010440d:	52                   	push   %edx
8010440e:	ff 73 a4             	push   -0x5c(%ebx)
80104411:	68 ef 84 10 80       	push   $0x801084ef
80104416:	e8 85 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010441b:	83 c4 10             	add    $0x10,%esp
8010441e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104422:	75 a4                	jne    801043c8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104424:	83 ec 08             	sub    $0x8,%esp
80104427:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010442a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010442d:	50                   	push   %eax
8010442e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104431:	8b 40 0c             	mov    0xc(%eax),%eax
80104434:	83 c0 08             	add    $0x8,%eax
80104437:	50                   	push   %eax
80104438:	e8 83 01 00 00       	call   801045c0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010443d:	83 c4 10             	add    $0x10,%esp
80104440:	8b 17                	mov    (%edi),%edx
80104442:	85 d2                	test   %edx,%edx
80104444:	74 82                	je     801043c8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104446:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104449:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010444c:	52                   	push   %edx
8010444d:	68 41 7f 10 80       	push   $0x80107f41
80104452:	e8 49 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104457:	83 c4 10             	add    $0x10,%esp
8010445a:	39 fe                	cmp    %edi,%esi
8010445c:	75 e2                	jne    80104440 <procdump+0x90>
8010445e:	e9 65 ff ff ff       	jmp    801043c8 <procdump+0x18>
80104463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104467:	90                   	nop
  }
80104468:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010446b:	5b                   	pop    %ebx
8010446c:	5e                   	pop    %esi
8010446d:	5f                   	pop    %edi
8010446e:	5d                   	pop    %ebp
8010446f:	c3                   	ret    

80104470 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	53                   	push   %ebx
80104474:	83 ec 0c             	sub    $0xc,%esp
80104477:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010447a:	68 64 85 10 80       	push   $0x80108564
8010447f:	8d 43 04             	lea    0x4(%ebx),%eax
80104482:	50                   	push   %eax
80104483:	e8 18 01 00 00       	call   801045a0 <initlock>
  lk->name = name;
80104488:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010448b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104491:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104494:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010449b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010449e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a1:	c9                   	leave  
801044a2:	c3                   	ret    
801044a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
801044b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044b8:	8d 73 04             	lea    0x4(%ebx),%esi
801044bb:	83 ec 0c             	sub    $0xc,%esp
801044be:	56                   	push   %esi
801044bf:	e8 ac 02 00 00       	call   80104770 <acquire>
  while (lk->locked) {
801044c4:	8b 13                	mov    (%ebx),%edx
801044c6:	83 c4 10             	add    $0x10,%esp
801044c9:	85 d2                	test   %edx,%edx
801044cb:	74 16                	je     801044e3 <acquiresleep+0x33>
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044d0:	83 ec 08             	sub    $0x8,%esp
801044d3:	56                   	push   %esi
801044d4:	53                   	push   %ebx
801044d5:	e8 36 fd ff ff       	call   80104210 <sleep>
  while (lk->locked) {
801044da:	8b 03                	mov    (%ebx),%eax
801044dc:	83 c4 10             	add    $0x10,%esp
801044df:	85 c0                	test   %eax,%eax
801044e1:	75 ed                	jne    801044d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801044e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044e9:	e8 b2 f4 ff ff       	call   801039a0 <myproc>
801044ee:	8b 40 10             	mov    0x10(%eax),%eax
801044f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044fa:	5b                   	pop    %ebx
801044fb:	5e                   	pop    %esi
801044fc:	5d                   	pop    %ebp
  release(&lk->lk);
801044fd:	e9 0e 02 00 00       	jmp    80104710 <release>
80104502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104510 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
80104515:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104518:	8d 73 04             	lea    0x4(%ebx),%esi
8010451b:	83 ec 0c             	sub    $0xc,%esp
8010451e:	56                   	push   %esi
8010451f:	e8 4c 02 00 00       	call   80104770 <acquire>
  lk->locked = 0;
80104524:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010452a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104531:	89 1c 24             	mov    %ebx,(%esp)
80104534:	e8 97 fd ff ff       	call   801042d0 <wakeup>
  release(&lk->lk);
80104539:	89 75 08             	mov    %esi,0x8(%ebp)
8010453c:	83 c4 10             	add    $0x10,%esp
}
8010453f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104542:	5b                   	pop    %ebx
80104543:	5e                   	pop    %esi
80104544:	5d                   	pop    %ebp
  release(&lk->lk);
80104545:	e9 c6 01 00 00       	jmp    80104710 <release>
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104550 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	57                   	push   %edi
80104554:	31 ff                	xor    %edi,%edi
80104556:	56                   	push   %esi
80104557:	53                   	push   %ebx
80104558:	83 ec 18             	sub    $0x18,%esp
8010455b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010455e:	8d 73 04             	lea    0x4(%ebx),%esi
80104561:	56                   	push   %esi
80104562:	e8 09 02 00 00       	call   80104770 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104567:	8b 03                	mov    (%ebx),%eax
80104569:	83 c4 10             	add    $0x10,%esp
8010456c:	85 c0                	test   %eax,%eax
8010456e:	75 18                	jne    80104588 <holdingsleep+0x38>
  release(&lk->lk);
80104570:	83 ec 0c             	sub    $0xc,%esp
80104573:	56                   	push   %esi
80104574:	e8 97 01 00 00       	call   80104710 <release>
  return r;
}
80104579:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010457c:	89 f8                	mov    %edi,%eax
8010457e:	5b                   	pop    %ebx
8010457f:	5e                   	pop    %esi
80104580:	5f                   	pop    %edi
80104581:	5d                   	pop    %ebp
80104582:	c3                   	ret    
80104583:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104587:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104588:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010458b:	e8 10 f4 ff ff       	call   801039a0 <myproc>
80104590:	39 58 10             	cmp    %ebx,0x10(%eax)
80104593:	0f 94 c0             	sete   %al
80104596:	0f b6 c0             	movzbl %al,%eax
80104599:	89 c7                	mov    %eax,%edi
8010459b:	eb d3                	jmp    80104570 <holdingsleep+0x20>
8010459d:	66 90                	xchg   %ax,%ax
8010459f:	90                   	nop

801045a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045b9:	5d                   	pop    %ebp
801045ba:	c3                   	ret    
801045bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop

801045c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045c0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045c1:	31 d2                	xor    %edx,%edx
{
801045c3:	89 e5                	mov    %esp,%ebp
801045c5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801045c6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801045c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801045cc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801045cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045d0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045dc:	77 1a                	ja     801045f8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045de:	8b 58 04             	mov    0x4(%eax),%ebx
801045e1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801045e4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801045e7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801045e9:	83 fa 0a             	cmp    $0xa,%edx
801045ec:	75 e2                	jne    801045d0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f1:	c9                   	leave  
801045f2:	c3                   	ret    
801045f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045f7:	90                   	nop
  for(; i < 10; i++)
801045f8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801045fb:	8d 51 28             	lea    0x28(%ecx),%edx
801045fe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104600:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104606:	83 c0 04             	add    $0x4,%eax
80104609:	39 d0                	cmp    %edx,%eax
8010460b:	75 f3                	jne    80104600 <getcallerpcs+0x40>
}
8010460d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104610:	c9                   	leave  
80104611:	c3                   	ret    
80104612:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104620 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 04             	sub    $0x4,%esp
80104627:	9c                   	pushf  
80104628:	5b                   	pop    %ebx
  asm volatile("cli");
80104629:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010462a:	e8 f1 f2 ff ff       	call   80103920 <mycpu>
8010462f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104635:	85 c0                	test   %eax,%eax
80104637:	74 17                	je     80104650 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104639:	e8 e2 f2 ff ff       	call   80103920 <mycpu>
8010463e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104648:	c9                   	leave  
80104649:	c3                   	ret    
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104650:	e8 cb f2 ff ff       	call   80103920 <mycpu>
80104655:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010465b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104661:	eb d6                	jmp    80104639 <pushcli+0x19>
80104663:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104670 <popcli>:

void
popcli(void)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104676:	9c                   	pushf  
80104677:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104678:	f6 c4 02             	test   $0x2,%ah
8010467b:	75 35                	jne    801046b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010467d:	e8 9e f2 ff ff       	call   80103920 <mycpu>
80104682:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104689:	78 34                	js     801046bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010468b:	e8 90 f2 ff ff       	call   80103920 <mycpu>
80104690:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104696:	85 d2                	test   %edx,%edx
80104698:	74 06                	je     801046a0 <popcli+0x30>
    sti();
}
8010469a:	c9                   	leave  
8010469b:	c3                   	ret    
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046a0:	e8 7b f2 ff ff       	call   80103920 <mycpu>
801046a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046ab:	85 c0                	test   %eax,%eax
801046ad:	74 eb                	je     8010469a <popcli+0x2a>
  asm volatile("sti");
801046af:	fb                   	sti    
}
801046b0:	c9                   	leave  
801046b1:	c3                   	ret    
    panic("popcli - interruptible");
801046b2:	83 ec 0c             	sub    $0xc,%esp
801046b5:	68 6f 85 10 80       	push   $0x8010856f
801046ba:	e8 c1 bc ff ff       	call   80100380 <panic>
    panic("popcli");
801046bf:	83 ec 0c             	sub    $0xc,%esp
801046c2:	68 86 85 10 80       	push   $0x80108586
801046c7:	e8 b4 bc ff ff       	call   80100380 <panic>
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046d0 <holding>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	8b 75 08             	mov    0x8(%ebp),%esi
801046d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801046da:	e8 41 ff ff ff       	call   80104620 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046df:	8b 06                	mov    (%esi),%eax
801046e1:	85 c0                	test   %eax,%eax
801046e3:	75 0b                	jne    801046f0 <holding+0x20>
  popcli();
801046e5:	e8 86 ff ff ff       	call   80104670 <popcli>
}
801046ea:	89 d8                	mov    %ebx,%eax
801046ec:	5b                   	pop    %ebx
801046ed:	5e                   	pop    %esi
801046ee:	5d                   	pop    %ebp
801046ef:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801046f0:	8b 5e 08             	mov    0x8(%esi),%ebx
801046f3:	e8 28 f2 ff ff       	call   80103920 <mycpu>
801046f8:	39 c3                	cmp    %eax,%ebx
801046fa:	0f 94 c3             	sete   %bl
  popcli();
801046fd:	e8 6e ff ff ff       	call   80104670 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104702:	0f b6 db             	movzbl %bl,%ebx
}
80104705:	89 d8                	mov    %ebx,%eax
80104707:	5b                   	pop    %ebx
80104708:	5e                   	pop    %esi
80104709:	5d                   	pop    %ebp
8010470a:	c3                   	ret    
8010470b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop

80104710 <release>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
80104715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104718:	e8 03 ff ff ff       	call   80104620 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010471d:	8b 03                	mov    (%ebx),%eax
8010471f:	85 c0                	test   %eax,%eax
80104721:	75 15                	jne    80104738 <release+0x28>
  popcli();
80104723:	e8 48 ff ff ff       	call   80104670 <popcli>
    panic("release");
80104728:	83 ec 0c             	sub    $0xc,%esp
8010472b:	68 8d 85 10 80       	push   $0x8010858d
80104730:	e8 4b bc ff ff       	call   80100380 <panic>
80104735:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104738:	8b 73 08             	mov    0x8(%ebx),%esi
8010473b:	e8 e0 f1 ff ff       	call   80103920 <mycpu>
80104740:	39 c6                	cmp    %eax,%esi
80104742:	75 df                	jne    80104723 <release+0x13>
  popcli();
80104744:	e8 27 ff ff ff       	call   80104670 <popcli>
  lk->pcs[0] = 0;
80104749:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104750:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104757:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010475c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104762:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104765:	5b                   	pop    %ebx
80104766:	5e                   	pop    %esi
80104767:	5d                   	pop    %ebp
  popcli();
80104768:	e9 03 ff ff ff       	jmp    80104670 <popcli>
8010476d:	8d 76 00             	lea    0x0(%esi),%esi

80104770 <acquire>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104777:	e8 a4 fe ff ff       	call   80104620 <pushcli>
  if(holding(lk))
8010477c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010477f:	e8 9c fe ff ff       	call   80104620 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104784:	8b 03                	mov    (%ebx),%eax
80104786:	85 c0                	test   %eax,%eax
80104788:	75 7e                	jne    80104808 <acquire+0x98>
  popcli();
8010478a:	e8 e1 fe ff ff       	call   80104670 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010478f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104798:	8b 55 08             	mov    0x8(%ebp),%edx
8010479b:	89 c8                	mov    %ecx,%eax
8010479d:	f0 87 02             	lock xchg %eax,(%edx)
801047a0:	85 c0                	test   %eax,%eax
801047a2:	75 f4                	jne    80104798 <acquire+0x28>
  __sync_synchronize();
801047a4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047ac:	e8 6f f1 ff ff       	call   80103920 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801047b4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801047b6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801047b9:	31 c0                	xor    %eax,%eax
801047bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801047c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047cc:	77 1a                	ja     801047e8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801047ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801047d1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801047d5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801047d8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801047da:	83 f8 0a             	cmp    $0xa,%eax
801047dd:	75 e1                	jne    801047c0 <acquire+0x50>
}
801047df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047e2:	c9                   	leave  
801047e3:	c3                   	ret    
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801047e8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801047ec:	8d 51 34             	lea    0x34(%ecx),%edx
801047ef:	90                   	nop
    pcs[i] = 0;
801047f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047f6:	83 c0 04             	add    $0x4,%eax
801047f9:	39 c2                	cmp    %eax,%edx
801047fb:	75 f3                	jne    801047f0 <acquire+0x80>
}
801047fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104800:	c9                   	leave  
80104801:	c3                   	ret    
80104802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104808:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010480b:	e8 10 f1 ff ff       	call   80103920 <mycpu>
80104810:	39 c3                	cmp    %eax,%ebx
80104812:	0f 85 72 ff ff ff    	jne    8010478a <acquire+0x1a>
  popcli();
80104818:	e8 53 fe ff ff       	call   80104670 <popcli>
    panic("acquire");
8010481d:	83 ec 0c             	sub    $0xc,%esp
80104820:	68 95 85 10 80       	push   $0x80108595
80104825:	e8 56 bb ff ff       	call   80100380 <panic>
8010482a:	66 90                	xchg   %ax,%ax
8010482c:	66 90                	xchg   %ax,%ax
8010482e:	66 90                	xchg   %ax,%ax

80104830 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	8b 55 08             	mov    0x8(%ebp),%edx
80104837:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010483a:	53                   	push   %ebx
8010483b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010483e:	89 d7                	mov    %edx,%edi
80104840:	09 cf                	or     %ecx,%edi
80104842:	83 e7 03             	and    $0x3,%edi
80104845:	75 29                	jne    80104870 <memset+0x40>
    c &= 0xFF;
80104847:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010484a:	c1 e0 18             	shl    $0x18,%eax
8010484d:	89 fb                	mov    %edi,%ebx
8010484f:	c1 e9 02             	shr    $0x2,%ecx
80104852:	c1 e3 10             	shl    $0x10,%ebx
80104855:	09 d8                	or     %ebx,%eax
80104857:	09 f8                	or     %edi,%eax
80104859:	c1 e7 08             	shl    $0x8,%edi
8010485c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010485e:	89 d7                	mov    %edx,%edi
80104860:	fc                   	cld    
80104861:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104863:	5b                   	pop    %ebx
80104864:	89 d0                	mov    %edx,%eax
80104866:	5f                   	pop    %edi
80104867:	5d                   	pop    %ebp
80104868:	c3                   	ret    
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104870:	89 d7                	mov    %edx,%edi
80104872:	fc                   	cld    
80104873:	f3 aa                	rep stos %al,%es:(%edi)
80104875:	5b                   	pop    %ebx
80104876:	89 d0                	mov    %edx,%eax
80104878:	5f                   	pop    %edi
80104879:	5d                   	pop    %ebp
8010487a:	c3                   	ret    
8010487b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010487f:	90                   	nop

80104880 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	8b 75 10             	mov    0x10(%ebp),%esi
80104887:	8b 55 08             	mov    0x8(%ebp),%edx
8010488a:	53                   	push   %ebx
8010488b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010488e:	85 f6                	test   %esi,%esi
80104890:	74 2e                	je     801048c0 <memcmp+0x40>
80104892:	01 c6                	add    %eax,%esi
80104894:	eb 14                	jmp    801048aa <memcmp+0x2a>
80104896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048a0:	83 c0 01             	add    $0x1,%eax
801048a3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048a6:	39 f0                	cmp    %esi,%eax
801048a8:	74 16                	je     801048c0 <memcmp+0x40>
    if(*s1 != *s2)
801048aa:	0f b6 0a             	movzbl (%edx),%ecx
801048ad:	0f b6 18             	movzbl (%eax),%ebx
801048b0:	38 d9                	cmp    %bl,%cl
801048b2:	74 ec                	je     801048a0 <memcmp+0x20>
      return *s1 - *s2;
801048b4:	0f b6 c1             	movzbl %cl,%eax
801048b7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048b9:	5b                   	pop    %ebx
801048ba:	5e                   	pop    %esi
801048bb:	5d                   	pop    %ebp
801048bc:	c3                   	ret    
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
801048c0:	5b                   	pop    %ebx
  return 0;
801048c1:	31 c0                	xor    %eax,%eax
}
801048c3:	5e                   	pop    %esi
801048c4:	5d                   	pop    %ebp
801048c5:	c3                   	ret    
801048c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048cd:	8d 76 00             	lea    0x0(%esi),%esi

801048d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	57                   	push   %edi
801048d4:	8b 55 08             	mov    0x8(%ebp),%edx
801048d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048da:	56                   	push   %esi
801048db:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048de:	39 d6                	cmp    %edx,%esi
801048e0:	73 26                	jae    80104908 <memmove+0x38>
801048e2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801048e5:	39 fa                	cmp    %edi,%edx
801048e7:	73 1f                	jae    80104908 <memmove+0x38>
801048e9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801048ec:	85 c9                	test   %ecx,%ecx
801048ee:	74 0c                	je     801048fc <memmove+0x2c>
      *--d = *--s;
801048f0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801048f4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801048f7:	83 e8 01             	sub    $0x1,%eax
801048fa:	73 f4                	jae    801048f0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048fc:	5e                   	pop    %esi
801048fd:	89 d0                	mov    %edx,%eax
801048ff:	5f                   	pop    %edi
80104900:	5d                   	pop    %ebp
80104901:	c3                   	ret    
80104902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104908:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010490b:	89 d7                	mov    %edx,%edi
8010490d:	85 c9                	test   %ecx,%ecx
8010490f:	74 eb                	je     801048fc <memmove+0x2c>
80104911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104918:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104919:	39 c6                	cmp    %eax,%esi
8010491b:	75 fb                	jne    80104918 <memmove+0x48>
}
8010491d:	5e                   	pop    %esi
8010491e:	89 d0                	mov    %edx,%eax
80104920:	5f                   	pop    %edi
80104921:	5d                   	pop    %ebp
80104922:	c3                   	ret    
80104923:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104930 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104930:	eb 9e                	jmp    801048d0 <memmove>
80104932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104940 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	8b 75 10             	mov    0x10(%ebp),%esi
80104947:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010494a:	53                   	push   %ebx
8010494b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010494e:	85 f6                	test   %esi,%esi
80104950:	74 2e                	je     80104980 <strncmp+0x40>
80104952:	01 d6                	add    %edx,%esi
80104954:	eb 18                	jmp    8010496e <strncmp+0x2e>
80104956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
80104960:	38 d8                	cmp    %bl,%al
80104962:	75 14                	jne    80104978 <strncmp+0x38>
    n--, p++, q++;
80104964:	83 c2 01             	add    $0x1,%edx
80104967:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010496a:	39 f2                	cmp    %esi,%edx
8010496c:	74 12                	je     80104980 <strncmp+0x40>
8010496e:	0f b6 01             	movzbl (%ecx),%eax
80104971:	0f b6 1a             	movzbl (%edx),%ebx
80104974:	84 c0                	test   %al,%al
80104976:	75 e8                	jne    80104960 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104978:	29 d8                	sub    %ebx,%eax
}
8010497a:	5b                   	pop    %ebx
8010497b:	5e                   	pop    %esi
8010497c:	5d                   	pop    %ebp
8010497d:	c3                   	ret    
8010497e:	66 90                	xchg   %ax,%ax
80104980:	5b                   	pop    %ebx
    return 0;
80104981:	31 c0                	xor    %eax,%eax
}
80104983:	5e                   	pop    %esi
80104984:	5d                   	pop    %ebp
80104985:	c3                   	ret    
80104986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498d:	8d 76 00             	lea    0x0(%esi),%esi

80104990 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	8b 75 08             	mov    0x8(%ebp),%esi
80104998:	53                   	push   %ebx
80104999:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010499c:	89 f0                	mov    %esi,%eax
8010499e:	eb 15                	jmp    801049b5 <strncpy+0x25>
801049a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049a7:	83 c0 01             	add    $0x1,%eax
801049aa:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801049ae:	88 50 ff             	mov    %dl,-0x1(%eax)
801049b1:	84 d2                	test   %dl,%dl
801049b3:	74 09                	je     801049be <strncpy+0x2e>
801049b5:	89 cb                	mov    %ecx,%ebx
801049b7:	83 e9 01             	sub    $0x1,%ecx
801049ba:	85 db                	test   %ebx,%ebx
801049bc:	7f e2                	jg     801049a0 <strncpy+0x10>
    ;
  while(n-- > 0)
801049be:	89 c2                	mov    %eax,%edx
801049c0:	85 c9                	test   %ecx,%ecx
801049c2:	7e 17                	jle    801049db <strncpy+0x4b>
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801049c8:	83 c2 01             	add    $0x1,%edx
801049cb:	89 c1                	mov    %eax,%ecx
801049cd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801049d1:	29 d1                	sub    %edx,%ecx
801049d3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801049d7:	85 c9                	test   %ecx,%ecx
801049d9:	7f ed                	jg     801049c8 <strncpy+0x38>
  return os;
}
801049db:	5b                   	pop    %ebx
801049dc:	89 f0                	mov    %esi,%eax
801049de:	5e                   	pop    %esi
801049df:	5f                   	pop    %edi
801049e0:	5d                   	pop    %ebp
801049e1:	c3                   	ret    
801049e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	8b 55 10             	mov    0x10(%ebp),%edx
801049f7:	8b 75 08             	mov    0x8(%ebp),%esi
801049fa:	53                   	push   %ebx
801049fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801049fe:	85 d2                	test   %edx,%edx
80104a00:	7e 25                	jle    80104a27 <safestrcpy+0x37>
80104a02:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a06:	89 f2                	mov    %esi,%edx
80104a08:	eb 16                	jmp    80104a20 <safestrcpy+0x30>
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a10:	0f b6 08             	movzbl (%eax),%ecx
80104a13:	83 c0 01             	add    $0x1,%eax
80104a16:	83 c2 01             	add    $0x1,%edx
80104a19:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a1c:	84 c9                	test   %cl,%cl
80104a1e:	74 04                	je     80104a24 <safestrcpy+0x34>
80104a20:	39 d8                	cmp    %ebx,%eax
80104a22:	75 ec                	jne    80104a10 <safestrcpy+0x20>
    ;
  *s = 0;
80104a24:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a27:	89 f0                	mov    %esi,%eax
80104a29:	5b                   	pop    %ebx
80104a2a:	5e                   	pop    %esi
80104a2b:	5d                   	pop    %ebp
80104a2c:	c3                   	ret    
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi

80104a30 <strlen>:

int
strlen(const char *s)
{
80104a30:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a31:	31 c0                	xor    %eax,%eax
{
80104a33:	89 e5                	mov    %esp,%ebp
80104a35:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a38:	80 3a 00             	cmpb   $0x0,(%edx)
80104a3b:	74 0c                	je     80104a49 <strlen+0x19>
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	83 c0 01             	add    $0x1,%eax
80104a43:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a47:	75 f7                	jne    80104a40 <strlen+0x10>
    ;
  return n;
}
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret    

80104a4b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a4b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a4f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a53:	55                   	push   %ebp
  pushl %ebx
80104a54:	53                   	push   %ebx
  pushl %esi
80104a55:	56                   	push   %esi
  pushl %edi
80104a56:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a57:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a59:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a5b:	5f                   	pop    %edi
  popl %esi
80104a5c:	5e                   	pop    %esi
  popl %ebx
80104a5d:	5b                   	pop    %ebx
  popl %ebp
80104a5e:	5d                   	pop    %ebp
  ret
80104a5f:	c3                   	ret    

80104a60 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 04             	sub    $0x4,%esp
80104a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a6a:	e8 31 ef ff ff       	call   801039a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a6f:	8b 00                	mov    (%eax),%eax
80104a71:	39 d8                	cmp    %ebx,%eax
80104a73:	76 1b                	jbe    80104a90 <fetchint+0x30>
80104a75:	8d 53 04             	lea    0x4(%ebx),%edx
80104a78:	39 d0                	cmp    %edx,%eax
80104a7a:	72 14                	jb     80104a90 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a7f:	8b 13                	mov    (%ebx),%edx
80104a81:	89 10                	mov    %edx,(%eax)
  return 0;
80104a83:	31 c0                	xor    %eax,%eax
}
80104a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a88:	c9                   	leave  
80104a89:	c3                   	ret    
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a95:	eb ee                	jmp    80104a85 <fetchint+0x25>
80104a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 04             	sub    $0x4,%esp
80104aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104aaa:	e8 f1 ee ff ff       	call   801039a0 <myproc>

  if(addr >= curproc->sz)
80104aaf:	39 18                	cmp    %ebx,(%eax)
80104ab1:	76 2d                	jbe    80104ae0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ab6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ab8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104aba:	39 d3                	cmp    %edx,%ebx
80104abc:	73 22                	jae    80104ae0 <fetchstr+0x40>
80104abe:	89 d8                	mov    %ebx,%eax
80104ac0:	eb 0d                	jmp    80104acf <fetchstr+0x2f>
80104ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ac8:	83 c0 01             	add    $0x1,%eax
80104acb:	39 c2                	cmp    %eax,%edx
80104acd:	76 11                	jbe    80104ae0 <fetchstr+0x40>
    if(*s == 0)
80104acf:	80 38 00             	cmpb   $0x0,(%eax)
80104ad2:	75 f4                	jne    80104ac8 <fetchstr+0x28>
      return s - *pp;
80104ad4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad9:	c9                   	leave  
80104ada:	c3                   	ret    
80104adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104adf:	90                   	nop
80104ae0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104ae3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ae8:	c9                   	leave  
80104ae9:	c3                   	ret    
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104af0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104af5:	e8 a6 ee ff ff       	call   801039a0 <myproc>
80104afa:	8b 55 08             	mov    0x8(%ebp),%edx
80104afd:	8b 40 18             	mov    0x18(%eax),%eax
80104b00:	8b 40 44             	mov    0x44(%eax),%eax
80104b03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b06:	e8 95 ee ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b0b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b0e:	8b 00                	mov    (%eax),%eax
80104b10:	39 c6                	cmp    %eax,%esi
80104b12:	73 1c                	jae    80104b30 <argint+0x40>
80104b14:	8d 53 08             	lea    0x8(%ebx),%edx
80104b17:	39 d0                	cmp    %edx,%eax
80104b19:	72 15                	jb     80104b30 <argint+0x40>
  *ip = *(int*)(addr);
80104b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b1e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b21:	89 10                	mov    %edx,(%eax)
  return 0;
80104b23:	31 c0                	xor    %eax,%eax
}
80104b25:	5b                   	pop    %ebx
80104b26:	5e                   	pop    %esi
80104b27:	5d                   	pop    %ebp
80104b28:	c3                   	ret    
80104b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b35:	eb ee                	jmp    80104b25 <argint+0x35>
80104b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
80104b45:	53                   	push   %ebx
80104b46:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b49:	e8 52 ee ff ff       	call   801039a0 <myproc>
80104b4e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b50:	e8 4b ee ff ff       	call   801039a0 <myproc>
80104b55:	8b 55 08             	mov    0x8(%ebp),%edx
80104b58:	8b 40 18             	mov    0x18(%eax),%eax
80104b5b:	8b 40 44             	mov    0x44(%eax),%eax
80104b5e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b61:	e8 3a ee ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b66:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b69:	8b 00                	mov    (%eax),%eax
80104b6b:	39 c7                	cmp    %eax,%edi
80104b6d:	73 31                	jae    80104ba0 <argptr+0x60>
80104b6f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b72:	39 c8                	cmp    %ecx,%eax
80104b74:	72 2a                	jb     80104ba0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b76:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b79:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b7c:	85 d2                	test   %edx,%edx
80104b7e:	78 20                	js     80104ba0 <argptr+0x60>
80104b80:	8b 16                	mov    (%esi),%edx
80104b82:	39 c2                	cmp    %eax,%edx
80104b84:	76 1a                	jbe    80104ba0 <argptr+0x60>
80104b86:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b89:	01 c3                	add    %eax,%ebx
80104b8b:	39 da                	cmp    %ebx,%edx
80104b8d:	72 11                	jb     80104ba0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b92:	89 02                	mov    %eax,(%edx)
  return 0;
80104b94:	31 c0                	xor    %eax,%eax
}
80104b96:	83 c4 0c             	add    $0xc,%esp
80104b99:	5b                   	pop    %ebx
80104b9a:	5e                   	pop    %esi
80104b9b:	5f                   	pop    %edi
80104b9c:	5d                   	pop    %ebp
80104b9d:	c3                   	ret    
80104b9e:	66 90                	xchg   %ax,%ax
    return -1;
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba5:	eb ef                	jmp    80104b96 <argptr+0x56>
80104ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bb5:	e8 e6 ed ff ff       	call   801039a0 <myproc>
80104bba:	8b 55 08             	mov    0x8(%ebp),%edx
80104bbd:	8b 40 18             	mov    0x18(%eax),%eax
80104bc0:	8b 40 44             	mov    0x44(%eax),%eax
80104bc3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bc6:	e8 d5 ed ff ff       	call   801039a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bcb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bce:	8b 00                	mov    (%eax),%eax
80104bd0:	39 c6                	cmp    %eax,%esi
80104bd2:	73 44                	jae    80104c18 <argstr+0x68>
80104bd4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bd7:	39 d0                	cmp    %edx,%eax
80104bd9:	72 3d                	jb     80104c18 <argstr+0x68>
  *ip = *(int*)(addr);
80104bdb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104bde:	e8 bd ed ff ff       	call   801039a0 <myproc>
  if(addr >= curproc->sz)
80104be3:	3b 18                	cmp    (%eax),%ebx
80104be5:	73 31                	jae    80104c18 <argstr+0x68>
  *pp = (char*)addr;
80104be7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bee:	39 d3                	cmp    %edx,%ebx
80104bf0:	73 26                	jae    80104c18 <argstr+0x68>
80104bf2:	89 d8                	mov    %ebx,%eax
80104bf4:	eb 11                	jmp    80104c07 <argstr+0x57>
80104bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi
80104c00:	83 c0 01             	add    $0x1,%eax
80104c03:	39 c2                	cmp    %eax,%edx
80104c05:	76 11                	jbe    80104c18 <argstr+0x68>
    if(*s == 0)
80104c07:	80 38 00             	cmpb   $0x0,(%eax)
80104c0a:	75 f4                	jne    80104c00 <argstr+0x50>
      return s - *pp;
80104c0c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c0e:	5b                   	pop    %ebx
80104c0f:	5e                   	pop    %esi
80104c10:	5d                   	pop    %ebp
80104c11:	c3                   	ret    
80104c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c18:	5b                   	pop    %ebx
    return -1;
80104c19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c1e:	5e                   	pop    %esi
80104c1f:	5d                   	pop    %ebp
80104c20:	c3                   	ret    
80104c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop

80104c30 <syscall>:
[SYS_getwmapinfo]   sys_getwmapinfo,
};

void
syscall(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c37:	e8 64 ed ff ff       	call   801039a0 <myproc>
80104c3c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c3e:	8b 40 18             	mov    0x18(%eax),%eax
80104c41:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c44:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c47:	83 fa 19             	cmp    $0x19,%edx
80104c4a:	77 24                	ja     80104c70 <syscall+0x40>
80104c4c:	8b 14 85 c0 85 10 80 	mov    -0x7fef7a40(,%eax,4),%edx
80104c53:	85 d2                	test   %edx,%edx
80104c55:	74 19                	je     80104c70 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c57:	ff d2                	call   *%edx
80104c59:	89 c2                	mov    %eax,%edx
80104c5b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c5e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c64:	c9                   	leave  
80104c65:	c3                   	ret    
80104c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c70:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c71:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c74:	50                   	push   %eax
80104c75:	ff 73 10             	push   0x10(%ebx)
80104c78:	68 9d 85 10 80       	push   $0x8010859d
80104c7d:	e8 1e ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104c82:	8b 43 18             	mov    0x18(%ebx),%eax
80104c85:	83 c4 10             	add    $0x10,%esp
80104c88:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c92:	c9                   	leave  
80104c93:	c3                   	ret    
80104c94:	66 90                	xchg   %ax,%ax
80104c96:	66 90                	xchg   %ax,%ax
80104c98:	66 90                	xchg   %ax,%ax
80104c9a:	66 90                	xchg   %ax,%ax
80104c9c:	66 90                	xchg   %ax,%ax
80104c9e:	66 90                	xchg   %ax,%ax

80104ca0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	57                   	push   %edi
80104ca4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ca5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ca8:	53                   	push   %ebx
80104ca9:	83 ec 34             	sub    $0x34,%esp
80104cac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104caf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104cb2:	57                   	push   %edi
80104cb3:	50                   	push   %eax
{
80104cb4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104cb7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cba:	e8 21 d4 ff ff       	call   801020e0 <nameiparent>
80104cbf:	83 c4 10             	add    $0x10,%esp
80104cc2:	85 c0                	test   %eax,%eax
80104cc4:	0f 84 46 01 00 00    	je     80104e10 <create+0x170>
    return 0;
  ilock(dp);
80104cca:	83 ec 0c             	sub    $0xc,%esp
80104ccd:	89 c3                	mov    %eax,%ebx
80104ccf:	50                   	push   %eax
80104cd0:	e8 cb ca ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104cd5:	83 c4 0c             	add    $0xc,%esp
80104cd8:	6a 00                	push   $0x0
80104cda:	57                   	push   %edi
80104cdb:	53                   	push   %ebx
80104cdc:	e8 1f d0 ff ff       	call   80101d00 <dirlookup>
80104ce1:	83 c4 10             	add    $0x10,%esp
80104ce4:	89 c6                	mov    %eax,%esi
80104ce6:	85 c0                	test   %eax,%eax
80104ce8:	74 56                	je     80104d40 <create+0xa0>
    iunlockput(dp);
80104cea:	83 ec 0c             	sub    $0xc,%esp
80104ced:	53                   	push   %ebx
80104cee:	e8 3d cd ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80104cf3:	89 34 24             	mov    %esi,(%esp)
80104cf6:	e8 a5 ca ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104cfb:	83 c4 10             	add    $0x10,%esp
80104cfe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d03:	75 1b                	jne    80104d20 <create+0x80>
80104d05:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d0a:	75 14                	jne    80104d20 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d0f:	89 f0                	mov    %esi,%eax
80104d11:	5b                   	pop    %ebx
80104d12:	5e                   	pop    %esi
80104d13:	5f                   	pop    %edi
80104d14:	5d                   	pop    %ebp
80104d15:	c3                   	ret    
80104d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d20:	83 ec 0c             	sub    $0xc,%esp
80104d23:	56                   	push   %esi
    return 0;
80104d24:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d26:	e8 05 cd ff ff       	call   80101a30 <iunlockput>
    return 0;
80104d2b:	83 c4 10             	add    $0x10,%esp
}
80104d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d31:	89 f0                	mov    %esi,%eax
80104d33:	5b                   	pop    %ebx
80104d34:	5e                   	pop    %esi
80104d35:	5f                   	pop    %edi
80104d36:	5d                   	pop    %ebp
80104d37:	c3                   	ret    
80104d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104d40:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d44:	83 ec 08             	sub    $0x8,%esp
80104d47:	50                   	push   %eax
80104d48:	ff 33                	push   (%ebx)
80104d4a:	e8 e1 c8 ff ff       	call   80101630 <ialloc>
80104d4f:	83 c4 10             	add    $0x10,%esp
80104d52:	89 c6                	mov    %eax,%esi
80104d54:	85 c0                	test   %eax,%eax
80104d56:	0f 84 cd 00 00 00    	je     80104e29 <create+0x189>
  ilock(ip);
80104d5c:	83 ec 0c             	sub    $0xc,%esp
80104d5f:	50                   	push   %eax
80104d60:	e8 3b ca ff ff       	call   801017a0 <ilock>
  ip->major = major;
80104d65:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d69:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d6d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d71:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d75:	b8 01 00 00 00       	mov    $0x1,%eax
80104d7a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d7e:	89 34 24             	mov    %esi,(%esp)
80104d81:	e8 6a c9 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d86:	83 c4 10             	add    $0x10,%esp
80104d89:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d8e:	74 30                	je     80104dc0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d90:	83 ec 04             	sub    $0x4,%esp
80104d93:	ff 76 04             	push   0x4(%esi)
80104d96:	57                   	push   %edi
80104d97:	53                   	push   %ebx
80104d98:	e8 63 d2 ff ff       	call   80102000 <dirlink>
80104d9d:	83 c4 10             	add    $0x10,%esp
80104da0:	85 c0                	test   %eax,%eax
80104da2:	78 78                	js     80104e1c <create+0x17c>
  iunlockput(dp);
80104da4:	83 ec 0c             	sub    $0xc,%esp
80104da7:	53                   	push   %ebx
80104da8:	e8 83 cc ff ff       	call   80101a30 <iunlockput>
  return ip;
80104dad:	83 c4 10             	add    $0x10,%esp
}
80104db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104db3:	89 f0                	mov    %esi,%eax
80104db5:	5b                   	pop    %ebx
80104db6:	5e                   	pop    %esi
80104db7:	5f                   	pop    %edi
80104db8:	5d                   	pop    %ebp
80104db9:	c3                   	ret    
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104dc0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104dc3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104dc8:	53                   	push   %ebx
80104dc9:	e8 22 c9 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dce:	83 c4 0c             	add    $0xc,%esp
80104dd1:	ff 76 04             	push   0x4(%esi)
80104dd4:	68 48 86 10 80       	push   $0x80108648
80104dd9:	56                   	push   %esi
80104dda:	e8 21 d2 ff ff       	call   80102000 <dirlink>
80104ddf:	83 c4 10             	add    $0x10,%esp
80104de2:	85 c0                	test   %eax,%eax
80104de4:	78 18                	js     80104dfe <create+0x15e>
80104de6:	83 ec 04             	sub    $0x4,%esp
80104de9:	ff 73 04             	push   0x4(%ebx)
80104dec:	68 47 86 10 80       	push   $0x80108647
80104df1:	56                   	push   %esi
80104df2:	e8 09 d2 ff ff       	call   80102000 <dirlink>
80104df7:	83 c4 10             	add    $0x10,%esp
80104dfa:	85 c0                	test   %eax,%eax
80104dfc:	79 92                	jns    80104d90 <create+0xf0>
      panic("create dots");
80104dfe:	83 ec 0c             	sub    $0xc,%esp
80104e01:	68 3b 86 10 80       	push   $0x8010863b
80104e06:	e8 75 b5 ff ff       	call   80100380 <panic>
80104e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e0f:	90                   	nop
}
80104e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e13:	31 f6                	xor    %esi,%esi
}
80104e15:	5b                   	pop    %ebx
80104e16:	89 f0                	mov    %esi,%eax
80104e18:	5e                   	pop    %esi
80104e19:	5f                   	pop    %edi
80104e1a:	5d                   	pop    %ebp
80104e1b:	c3                   	ret    
    panic("create: dirlink");
80104e1c:	83 ec 0c             	sub    $0xc,%esp
80104e1f:	68 4a 86 10 80       	push   $0x8010864a
80104e24:	e8 57 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e29:	83 ec 0c             	sub    $0xc,%esp
80104e2c:	68 2c 86 10 80       	push   $0x8010862c
80104e31:	e8 4a b5 ff ff       	call   80100380 <panic>
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi

80104e40 <sys_wmap>:
sys_wmap(void) {
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
    if (argint(0, &addr) < 0 || argint(1, &length) < 0 ||
80104e45:	8d 45 d8             	lea    -0x28(%ebp),%eax
sys_wmap(void) {
80104e48:	53                   	push   %ebx
80104e49:	83 ec 24             	sub    $0x24,%esp
    if (argint(0, &addr) < 0 || argint(1, &length) < 0 ||
80104e4c:	50                   	push   %eax
80104e4d:	6a 00                	push   $0x0
80104e4f:	e8 9c fc ff ff       	call   80104af0 <argint>
80104e54:	83 c4 10             	add    $0x10,%esp
80104e57:	85 c0                	test   %eax,%eax
80104e59:	0f 88 2d 01 00 00    	js     80104f8c <sys_wmap+0x14c>
80104e5f:	83 ec 08             	sub    $0x8,%esp
80104e62:	8d 45 dc             	lea    -0x24(%ebp),%eax
80104e65:	50                   	push   %eax
80104e66:	6a 01                	push   $0x1
80104e68:	e8 83 fc ff ff       	call   80104af0 <argint>
80104e6d:	83 c4 10             	add    $0x10,%esp
80104e70:	85 c0                	test   %eax,%eax
80104e72:	0f 88 14 01 00 00    	js     80104f8c <sys_wmap+0x14c>
        argint(2, &flags) < 0 || argint(3, &fd) < 0) {
80104e78:	83 ec 08             	sub    $0x8,%esp
80104e7b:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104e7e:	50                   	push   %eax
80104e7f:	6a 02                	push   $0x2
80104e81:	e8 6a fc ff ff       	call   80104af0 <argint>
    if (argint(0, &addr) < 0 || argint(1, &length) < 0 ||
80104e86:	83 c4 10             	add    $0x10,%esp
80104e89:	85 c0                	test   %eax,%eax
80104e8b:	0f 88 fb 00 00 00    	js     80104f8c <sys_wmap+0x14c>
        argint(2, &flags) < 0 || argint(3, &fd) < 0) {
80104e91:	83 ec 08             	sub    $0x8,%esp
80104e94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e97:	50                   	push   %eax
80104e98:	6a 03                	push   $0x3
80104e9a:	e8 51 fc ff ff       	call   80104af0 <argint>
80104e9f:	83 c4 10             	add    $0x10,%esp
80104ea2:	85 c0                	test   %eax,%eax
80104ea4:	0f 88 e2 00 00 00    	js     80104f8c <sys_wmap+0x14c>
    struct proc *p = myproc();
80104eaa:	e8 f1 ea ff ff       	call   801039a0 <myproc>
80104eaf:	89 c3                	mov    %eax,%ebx
    if (flags & MAP_FIXED) {
80104eb1:	f6 45 e0 08          	testb  $0x8,-0x20(%ebp)
80104eb5:	0f 84 b5 00 00 00    	je     80104f70 <sys_wmap+0x130>
                if (!(addr + length <= mmap_start || addr >= mmap_end)) {
80104ebb:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80104ebe:	8b 7d dc             	mov    -0x24(%ebp),%edi
80104ec1:	8d 40 7c             	lea    0x7c(%eax),%eax
80104ec4:	8d b3 fc 01 00 00    	lea    0x1fc(%ebx),%esi
80104eca:	01 cf                	add    %ecx,%edi
80104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            if (p->mmaps[i].used) {
80104ed0:	8b 50 0c             	mov    0xc(%eax),%edx
80104ed3:	85 d2                	test   %edx,%edx
80104ed5:	74 11                	je     80104ee8 <sys_wmap+0xa8>
                uint mmap_start = p->mmaps[i].addr;
80104ed7:	8b 10                	mov    (%eax),%edx
                if (!(addr + length <= mmap_start || addr >= mmap_end)) {
80104ed9:	39 d7                	cmp    %edx,%edi
80104edb:	76 0b                	jbe    80104ee8 <sys_wmap+0xa8>
                uint mmap_end = mmap_start + p->mmaps[i].length;
80104edd:	03 50 04             	add    0x4(%eax),%edx
                if (!(addr + length <= mmap_start || addr >= mmap_end)) {
80104ee0:	39 ca                	cmp    %ecx,%edx
80104ee2:	0f 87 a4 00 00 00    	ja     80104f8c <sys_wmap+0x14c>
        for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80104ee8:	83 c0 18             	add    $0x18,%eax
80104eeb:	39 f0                	cmp    %esi,%eax
80104eed:	75 e1                	jne    80104ed0 <sys_wmap+0x90>
    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80104eef:	8d 93 88 00 00 00    	lea    0x88(%ebx),%edx
80104ef5:	31 c0                	xor    %eax,%eax
80104ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efe:	66 90                	xchg   %ax,%ax
        if (!p->mmaps[i].used) {
80104f00:	8b 32                	mov    (%edx),%esi
80104f02:	85 f6                	test   %esi,%esi
80104f04:	74 1a                	je     80104f20 <sys_wmap+0xe0>
    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80104f06:	83 c0 01             	add    $0x1,%eax
80104f09:	83 c2 18             	add    $0x18,%edx
80104f0c:	83 f8 10             	cmp    $0x10,%eax
80104f0f:	75 ef                	jne    80104f00 <sys_wmap+0xc0>
}
80104f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f14:	89 c8                	mov    %ecx,%eax
80104f16:	5b                   	pop    %ebx
80104f17:	5e                   	pop    %esi
80104f18:	5f                   	pop    %edi
80104f19:	5d                   	pop    %ebp
80104f1a:	c3                   	ret    
80104f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f1f:	90                   	nop
            p->mmaps[i].length = length;
80104f20:	8b 55 dc             	mov    -0x24(%ebp),%edx
            p->mmaps[i].used = 1;
80104f23:	8d 04 40             	lea    (%eax,%eax,2),%eax
80104f26:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
            p->mmaps[i].length = length;
80104f29:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
            p->mmaps[i].flags = flags;
80104f2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
            p->mmaps[i].used = 1;
80104f32:	c7 80 88 00 00 00 01 	movl   $0x1,0x88(%eax)
80104f39:	00 00 00 
            p->mmaps[i].flags = flags;
80104f3c:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
            if (!(flags & MAP_ANONYMOUS)) {
80104f42:	83 e2 04             	and    $0x4,%edx
            p->mmaps[i].addr = addr;
80104f45:	89 48 7c             	mov    %ecx,0x7c(%eax)
            if (!(flags & MAP_ANONYMOUS)) {
80104f48:	75 56                	jne    80104fa0 <sys_wmap+0x160>
                p->mmaps[i].file_offset = 0; // Assuming the offset is 0 for simplicity
80104f4a:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104f51:	00 00 00 
                p->mmaps[i].fd = fd;
80104f54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104f57:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
}
80104f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f60:	89 c8                	mov    %ecx,%eax
80104f62:	5b                   	pop    %ebx
80104f63:	5e                   	pop    %esi
80104f64:	5f                   	pop    %edi
80104f65:	5d                   	pop    %ebp
80104f66:	c3                   	ret    
80104f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6e:	66 90                	xchg   %ax,%ax
        addr = find_available_region(p, length);
80104f70:	83 ec 08             	sub    $0x8,%esp
80104f73:	ff 75 dc             	push   -0x24(%ebp)
80104f76:	50                   	push   %eax
80104f77:	e8 54 2b 00 00       	call   80107ad0 <find_available_region>
        if (addr == 0) {
80104f7c:	83 c4 10             	add    $0x10,%esp
        addr = find_available_region(p, length);
80104f7f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104f82:	89 c1                	mov    %eax,%ecx
        if (addr == 0) {
80104f84:	85 c0                	test   %eax,%eax
80104f86:	0f 85 63 ff ff ff    	jne    80104eef <sys_wmap+0xaf>
}
80104f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80104f8f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
}
80104f94:	5b                   	pop    %ebx
80104f95:	89 c8                	mov    %ecx,%eax
80104f97:	5e                   	pop    %esi
80104f98:	5f                   	pop    %edi
80104f99:	5d                   	pop    %ebp
80104f9a:	c3                   	ret    
80104f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f9f:	90                   	nop
                p->mmaps[i].fd = -1;
80104fa0:	c7 80 8c 00 00 00 ff 	movl   $0xffffffff,0x8c(%eax)
80104fa7:	ff ff ff 
                p->mmaps[i].file_offset = 0;
80104faa:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104fb1:	00 00 00 
}
80104fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fb7:	89 c8                	mov    %ecx,%eax
80104fb9:	5b                   	pop    %ebx
80104fba:	5e                   	pop    %esi
80104fbb:	5f                   	pop    %edi
80104fbc:	5d                   	pop    %ebp
80104fbd:	c3                   	ret    
80104fbe:	66 90                	xchg   %ax,%ax

80104fc0 <sys_wunmap>:
sys_wunmap(void) {
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	53                   	push   %ebx
    if (argint(0, (int *)&addr) < 0) {
80104fc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
sys_wunmap(void) {
80104fc7:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, (int *)&addr) < 0) {
80104fca:	50                   	push   %eax
80104fcb:	6a 00                	push   $0x0
80104fcd:	e8 1e fb ff ff       	call   80104af0 <argint>
80104fd2:	83 c4 10             	add    $0x10,%esp
80104fd5:	85 c0                	test   %eax,%eax
80104fd7:	78 1f                	js     80104ff8 <sys_wunmap+0x38>
    return unmap_pages(myproc(), addr);
80104fd9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104fdc:	e8 bf e9 ff ff       	call   801039a0 <myproc>
80104fe1:	83 ec 08             	sub    $0x8,%esp
80104fe4:	53                   	push   %ebx
80104fe5:	50                   	push   %eax
80104fe6:	e8 e5 2b 00 00       	call   80107bd0 <unmap_pages>
80104feb:	83 c4 10             	add    $0x10,%esp
}
80104fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ff1:	c9                   	leave  
80104ff2:	c3                   	ret    
80104ff3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ff7:	90                   	nop
        return -1;
80104ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ffd:	eb ef                	jmp    80104fee <sys_wunmap+0x2e>
80104fff:	90                   	nop

80105000 <sys_wremap>:
uint sys_wremap(void) {
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	57                   	push   %edi
80105004:	56                   	push   %esi
  if (argint(0, (int*)&oldaddr) < 0 || argint(1, &oldsize) < 0 || argint(2, &newsize) < 0 || argint(3, &flags) < 0) {
80105005:	8d 45 d8             	lea    -0x28(%ebp),%eax
uint sys_wremap(void) {
80105008:	53                   	push   %ebx
80105009:	83 ec 34             	sub    $0x34,%esp
  if (argint(0, (int*)&oldaddr) < 0 || argint(1, &oldsize) < 0 || argint(2, &newsize) < 0 || argint(3, &flags) < 0) {
8010500c:	50                   	push   %eax
8010500d:	6a 00                	push   $0x0
8010500f:	e8 dc fa ff ff       	call   80104af0 <argint>
80105014:	83 c4 10             	add    $0x10,%esp
80105017:	85 c0                	test   %eax,%eax
80105019:	0f 88 01 01 00 00    	js     80105120 <sys_wremap+0x120>
8010501f:	83 ec 08             	sub    $0x8,%esp
80105022:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105025:	50                   	push   %eax
80105026:	6a 01                	push   $0x1
80105028:	e8 c3 fa ff ff       	call   80104af0 <argint>
8010502d:	83 c4 10             	add    $0x10,%esp
80105030:	85 c0                	test   %eax,%eax
80105032:	0f 88 e8 00 00 00    	js     80105120 <sys_wremap+0x120>
80105038:	83 ec 08             	sub    $0x8,%esp
8010503b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010503e:	50                   	push   %eax
8010503f:	6a 02                	push   $0x2
80105041:	e8 aa fa ff ff       	call   80104af0 <argint>
80105046:	83 c4 10             	add    $0x10,%esp
80105049:	85 c0                	test   %eax,%eax
8010504b:	0f 88 cf 00 00 00    	js     80105120 <sys_wremap+0x120>
80105051:	83 ec 08             	sub    $0x8,%esp
80105054:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105057:	50                   	push   %eax
80105058:	6a 03                	push   $0x3
8010505a:	e8 91 fa ff ff       	call   80104af0 <argint>
8010505f:	83 c4 10             	add    $0x10,%esp
80105062:	85 c0                	test   %eax,%eax
80105064:	0f 88 b6 00 00 00    	js     80105120 <sys_wremap+0x120>
  struct proc *curproc = myproc();
8010506a:	e8 31 e9 ff ff       	call   801039a0 <myproc>
    if(oldaddr == curproc->mmaps->addr){
8010506f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  int index = -1;
80105072:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80105077:	31 f6                	xor    %esi,%esi
  struct proc *curproc = myproc();
80105079:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if(oldaddr == curproc->mmaps->addr){
8010507c:	8b 78 7c             	mov    0x7c(%eax),%edi
  int found = -1;
8010507f:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80105084:	31 c0                	xor    %eax,%eax
80105086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
    if(oldaddr == curproc->mmaps->addr){
80105090:	39 df                	cmp    %ebx,%edi
80105092:	0f 44 c8             	cmove  %eax,%ecx
80105095:	0f 44 d6             	cmove  %esi,%edx
  for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80105098:	83 c0 01             	add    $0x1,%eax
8010509b:	83 f8 10             	cmp    $0x10,%eax
8010509e:	75 f0                	jne    80105090 <sys_wremap+0x90>
  if(found == -1) { // if not found, Fail
801050a0:	83 fa ff             	cmp    $0xffffffff,%edx
801050a3:	74 7b                	je     80105120 <sys_wremap+0x120>
    if(newsize <= oldsize) {
801050a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050a8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
801050ab:	0f 8e 7f 00 00 00    	jle    80105130 <sys_wremap+0x130>
        if(flags & MREMAP_MAYMOVE) {
801050b1:	f6 45 e4 01          	testb  $0x1,-0x1c(%ebp)
801050b5:	74 6e                	je     80105125 <sys_wremap+0x125>
          uint newAddr = find_available_region(curproc, newsize);
801050b7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
801050ba:	83 ec 08             	sub    $0x8,%esp
801050bd:	50                   	push   %eax
801050be:	57                   	push   %edi
801050bf:	e8 0c 2a 00 00       	call   80107ad0 <find_available_region>
          if(newAddr){ // if region found map to new region
801050c4:	83 c4 10             	add    $0x10,%esp
          uint newAddr = find_available_region(curproc, newsize);
801050c7:	89 c3                	mov    %eax,%ebx
          if(newAddr){ // if region found map to new region
801050c9:	85 c0                	test   %eax,%eax
801050cb:	74 53                	je     80105120 <sys_wremap+0x120>
            unmap_pages(curproc, oldaddr);
801050cd:	83 ec 08             	sub    $0x8,%esp
801050d0:	ff 75 d8             	push   -0x28(%ebp)
            if(mappages(curproc->pgdir, (void *)PGROUNDDOWN(newAddr), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0) {
801050d3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
            unmap_pages(curproc, oldaddr);
801050d9:	57                   	push   %edi
801050da:	e8 f1 2a 00 00       	call   80107bd0 <unmap_pages>
            char *mem = kalloc();
801050df:	e8 bc d5 ff ff       	call   801026a0 <kalloc>
            memset(mem, 0, PGSIZE);
801050e4:	83 c4 0c             	add    $0xc,%esp
801050e7:	68 00 10 00 00       	push   $0x1000
            char *mem = kalloc();
801050ec:	89 c6                	mov    %eax,%esi
            memset(mem, 0, PGSIZE);
801050ee:	6a 00                	push   $0x0
            if(mappages(curproc->pgdir, (void *)PGROUNDDOWN(newAddr), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0) {
801050f0:	81 c6 00 00 00 80    	add    $0x80000000,%esi
            memset(mem, 0, PGSIZE);
801050f6:	50                   	push   %eax
801050f7:	e8 34 f7 ff ff       	call   80104830 <memset>
            if(mappages(curproc->pgdir, (void *)PGROUNDDOWN(newAddr), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0) {
801050fc:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80105103:	56                   	push   %esi
80105104:	68 00 10 00 00       	push   $0x1000
80105109:	53                   	push   %ebx
8010510a:	ff 77 04             	push   0x4(%edi)
8010510d:	e8 1e 21 00 00       	call   80107230 <mappages>
80105112:	83 c4 20             	add    $0x20,%esp
80105115:	85 c0                	test   %eax,%eax
80105117:	78 07                	js     80105120 <sys_wremap+0x120>
  return oldaddr;
80105119:	8b 5d d8             	mov    -0x28(%ebp),%ebx
8010511c:	eb 07                	jmp    80105125 <sys_wremap+0x125>
8010511e:	66 90                	xchg   %ax,%ax
    return -1;  // if not valid 
80105120:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105125:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105128:	89 d8                	mov    %ebx,%eax
8010512a:	5b                   	pop    %ebx
8010512b:	5e                   	pop    %esi
8010512c:	5f                   	pop    %edi
8010512d:	5d                   	pop    %ebp
8010512e:	c3                   	ret    
8010512f:	90                   	nop
      curproc->mmaps[index].length=newsize;
80105130:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80105133:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
80105136:	89 84 d6 80 00 00 00 	mov    %eax,0x80(%esi,%edx,8)
      return oldaddr;
8010513d:	eb e6                	jmp    80105125 <sys_wremap+0x125>
8010513f:	90                   	nop

80105140 <sys_getpgdirinfo>:
int sys_getpgdirinfo(void) {
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	57                   	push   %edi
80105144:	56                   	push   %esi
    if (argptr(0, (void *)&pdinfo, sizeof(*pdinfo)) < 0) {
80105145:	8d 45 e4             	lea    -0x1c(%ebp),%eax
int sys_getpgdirinfo(void) {
80105148:	53                   	push   %ebx
80105149:	83 ec 30             	sub    $0x30,%esp
    if (argptr(0, (void *)&pdinfo, sizeof(*pdinfo)) < 0) {
8010514c:	68 04 01 00 00       	push   $0x104
80105151:	50                   	push   %eax
80105152:	6a 00                	push   $0x0
80105154:	e8 e7 f9 ff ff       	call   80104b40 <argptr>
80105159:	83 c4 10             	add    $0x10,%esp
8010515c:	85 c0                	test   %eax,%eax
8010515e:	0f 88 c3 00 00 00    	js     80105227 <sys_getpgdirinfo+0xe7>
    struct proc *curproc = myproc();
80105164:	e8 37 e8 ff ff       	call   801039a0 <myproc>
    for (int pdx = 0; pdx < NPDENTRIES && n_upages < MAX_UPAGE_INFO; pdx++) {
80105169:	31 ff                	xor    %edi,%edi
    uint n_upages = 0;
8010516b:	31 c9                	xor    %ecx,%ecx
    pde_t *pgdir = curproc->pgdir;
8010516d:	8b 40 04             	mov    0x4(%eax),%eax
80105170:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                    pdinfo->va[n_upages] = va;
80105173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105176:	89 45 d0             	mov    %eax,-0x30(%ebp)
80105179:	eb 1c                	jmp    80105197 <sys_getpgdirinfo+0x57>
8010517b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010517f:	90                   	nop
    for (int pdx = 0; pdx < NPDENTRIES && n_upages < MAX_UPAGE_INFO; pdx++) {
80105180:	83 c7 01             	add    $0x1,%edi
80105183:	81 ff ff 03 00 00    	cmp    $0x3ff,%edi
80105189:	0f 8f 89 00 00 00    	jg     80105218 <sys_getpgdirinfo+0xd8>
8010518f:	84 db                	test   %bl,%bl
80105191:	0f 84 81 00 00 00    	je     80105218 <sys_getpgdirinfo+0xd8>
        pde_t pde = pgdir[pdx];
80105197:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    for (int pdx = 0; pdx < NPDENTRIES && n_upages < MAX_UPAGE_INFO; pdx++) {
8010519a:	83 f9 1f             	cmp    $0x1f,%ecx
8010519d:	0f 96 c3             	setbe  %bl
        pde_t pde = pgdir[pdx];
801051a0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
        if (pde & PTE_P) { // Check if the page directory entry is present
801051a3:	a8 01                	test   $0x1,%al
801051a5:	74 d9                	je     80105180 <sys_getpgdirinfo+0x40>
            pte_t *pgtab = (pte_t *)P2V(PTE_ADDR(pde));
801051a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801051ac:	05 00 00 00 80       	add    $0x80000000,%eax
            for (int ptx = 0; ptx < NPTENTRIES && n_upages < MAX_UPAGE_INFO; ptx++) {
801051b1:	83 f9 1f             	cmp    $0x1f,%ecx
801051b4:	77 62                	ja     80105218 <sys_getpgdirinfo+0xd8>
801051b6:	89 7d cc             	mov    %edi,-0x34(%ebp)
801051b9:	89 fe                	mov    %edi,%esi
801051bb:	31 d2                	xor    %edx,%edx
801051bd:	c1 e6 16             	shl    $0x16,%esi
                pte_t pte = pgtab[ptx];
801051c0:	8b 18                	mov    (%eax),%ebx
                if (pte & PTE_P && pte & PTE_U) { // Check if the page is present and user-accessible
801051c2:	89 df                	mov    %ebx,%edi
801051c4:	83 e7 05             	and    $0x5,%edi
801051c7:	83 ff 05             	cmp    $0x5,%edi
801051ca:	75 17                	jne    801051e3 <sys_getpgdirinfo+0xa3>
                    pdinfo->va[n_upages] = va;
801051cc:	8b 7d d0             	mov    -0x30(%ebp),%edi
                    uint pa = PTE_ADDR(pte);
801051cf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
                    pdinfo->va[n_upages] = va;
801051d5:	89 74 8f 04          	mov    %esi,0x4(%edi,%ecx,4)
                    uint pa = PTE_ADDR(pte);
801051d9:	89 9c 8f 84 00 00 00 	mov    %ebx,0x84(%edi,%ecx,4)
                    n_upages++;
801051e0:	83 c1 01             	add    $0x1,%ecx
            for (int ptx = 0; ptx < NPTENTRIES && n_upages < MAX_UPAGE_INFO; ptx++) {
801051e3:	83 c2 01             	add    $0x1,%edx
801051e6:	83 f9 1f             	cmp    $0x1f,%ecx
801051e9:	0f 96 c3             	setbe  %bl
801051ec:	83 c0 04             	add    $0x4,%eax
801051ef:	81 c6 00 10 00 00    	add    $0x1000,%esi
801051f5:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
801051fb:	7f 04                	jg     80105201 <sys_getpgdirinfo+0xc1>
801051fd:	84 db                	test   %bl,%bl
801051ff:	75 bf                	jne    801051c0 <sys_getpgdirinfo+0x80>
80105201:	8b 7d cc             	mov    -0x34(%ebp),%edi
    for (int pdx = 0; pdx < NPDENTRIES && n_upages < MAX_UPAGE_INFO; pdx++) {
80105204:	83 c7 01             	add    $0x1,%edi
80105207:	81 ff ff 03 00 00    	cmp    $0x3ff,%edi
8010520d:	0f 8e 7c ff ff ff    	jle    8010518f <sys_getpgdirinfo+0x4f>
80105213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105217:	90                   	nop
    pdinfo->n_upages = n_upages;
80105218:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010521b:	89 08                	mov    %ecx,(%eax)
    return 0; // Success
8010521d:	31 c0                	xor    %eax,%eax
}
8010521f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105222:	5b                   	pop    %ebx
80105223:	5e                   	pop    %esi
80105224:	5f                   	pop    %edi
80105225:	5d                   	pop    %ebp
80105226:	c3                   	ret    
        return -1; // Failed to retrieve the argument
80105227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010522c:	eb f1                	jmp    8010521f <sys_getpgdirinfo+0xdf>
8010522e:	66 90                	xchg   %ax,%ax

80105230 <sys_getwmapinfo>:
int sys_getwmapinfo(void) {
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	57                   	push   %edi
80105234:	56                   	push   %esi
    if (argptr(0, (void *)&wminfo, sizeof(struct wmapinfo)) < 0) {
80105235:	8d 45 e4             	lea    -0x1c(%ebp),%eax
int sys_getwmapinfo(void) {
80105238:	53                   	push   %ebx
80105239:	83 ec 30             	sub    $0x30,%esp
    if (argptr(0, (void *)&wminfo, sizeof(struct wmapinfo)) < 0) {
8010523c:	68 cc 00 00 00       	push   $0xcc
80105241:	50                   	push   %eax
80105242:	6a 00                	push   $0x0
80105244:	e8 f7 f8 ff ff       	call   80104b40 <argptr>
80105249:	83 c4 10             	add    $0x10,%esp
8010524c:	85 c0                	test   %eax,%eax
8010524e:	0f 88 db 00 00 00    	js     8010532f <sys_getwmapinfo+0xff>
    struct proc *p = myproc();
80105254:	e8 47 e7 ff ff       	call   801039a0 <myproc>
    for (int i = 0; i < MAX_WMMAP_INFO && count < MAX_WMMAP_INFO; i++) {
80105259:	31 db                	xor    %ebx,%ebx
    int count = 0;
8010525b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    struct proc *p = myproc();
80105262:	89 c2                	mov    %eax,%edx
80105264:	89 45 c8             	mov    %eax,-0x38(%ebp)
            wminfo->addr[count] = p->mmaps[i].addr;
80105267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010526a:	8d 7a 7c             	lea    0x7c(%edx),%edi
    int count = 0;
8010526d:	89 fe                	mov    %edi,%esi
8010526f:	eb 20                	jmp    80105291 <sys_getwmapinfo+0x61>
80105271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (int i = 0; i < MAX_WMMAP_INFO && count < MAX_WMMAP_INFO; i++) {
80105278:	83 c3 01             	add    $0x1,%ebx
8010527b:	83 c6 18             	add    $0x18,%esi
8010527e:	83 fb 0f             	cmp    $0xf,%ebx
80105281:	0f 8f 99 00 00 00    	jg     80105320 <sys_getwmapinfo+0xf0>
80105287:	83 7d d4 0f          	cmpl   $0xf,-0x2c(%ebp)
8010528b:	0f 8f 8f 00 00 00    	jg     80105320 <sys_getwmapinfo+0xf0>
        if (p->mmaps[i].used) {
80105291:	8b 56 0c             	mov    0xc(%esi),%edx
80105294:	85 d2                	test   %edx,%edx
80105296:	74 e0                	je     80105278 <sys_getwmapinfo+0x48>
            wminfo->addr[count] = p->mmaps[i].addr;
80105298:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
8010529b:	8b 3e                	mov    (%esi),%edi
8010529d:	8d 14 88             	lea    (%eax,%ecx,4),%edx
801052a0:	89 7a 04             	mov    %edi,0x4(%edx)
            wminfo->length[count] = p->mmaps[i].length;
801052a3:	8b 7e 04             	mov    0x4(%esi),%edi
            wminfo->n_loaded_pages[count] = 0;
801052a6:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
801052ad:	00 00 00 
            wminfo->length[count] = p->mmaps[i].length;
801052b0:	89 7a 44             	mov    %edi,0x44(%edx)
            for (uint a = p->mmaps[i].addr; a < p->mmaps[i].addr + p->mmaps[i].length; a += PGSIZE) {
801052b3:	8b 3e                	mov    (%esi),%edi
801052b5:	8b 56 04             	mov    0x4(%esi),%edx
801052b8:	01 fa                	add    %edi,%edx
801052ba:	39 d7                	cmp    %edx,%edi
801052bc:	73 4c                	jae    8010530a <sys_getwmapinfo+0xda>
                    wminfo->n_loaded_pages[count]++;
801052be:	8d 41 20             	lea    0x20(%ecx),%eax
801052c1:	89 5d cc             	mov    %ebx,-0x34(%ebp)
801052c4:	89 fb                	mov    %edi,%ebx
801052c6:	8b 7d c8             	mov    -0x38(%ebp),%edi
801052c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
801052cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                pte_t *pte = walkpgdir(p->pgdir, (char *)a, 0);
801052d0:	83 ec 04             	sub    $0x4,%esp
801052d3:	6a 00                	push   $0x0
801052d5:	53                   	push   %ebx
801052d6:	ff 77 04             	push   0x4(%edi)
801052d9:	e8 c2 1e 00 00       	call   801071a0 <walkpgdir>
                if (pte && (*pte & PTE_P)) {
801052de:	83 c4 10             	add    $0x10,%esp
801052e1:	85 c0                	test   %eax,%eax
801052e3:	74 10                	je     801052f5 <sys_getwmapinfo+0xc5>
801052e5:	f6 00 01             	testb  $0x1,(%eax)
801052e8:	74 0b                	je     801052f5 <sys_getwmapinfo+0xc5>
                    wminfo->n_loaded_pages[count]++;
801052ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801052ed:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801052f0:	83 44 88 04 01       	addl   $0x1,0x4(%eax,%ecx,4)
            for (uint a = p->mmaps[i].addr; a < p->mmaps[i].addr + p->mmaps[i].length; a += PGSIZE) {
801052f5:	8b 46 04             	mov    0x4(%esi),%eax
801052f8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801052fe:	03 06                	add    (%esi),%eax
80105300:	39 d8                	cmp    %ebx,%eax
80105302:	77 cc                	ja     801052d0 <sys_getwmapinfo+0xa0>
                    wminfo->n_loaded_pages[count]++;
80105304:	8b 5d cc             	mov    -0x34(%ebp),%ebx
80105307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    for (int i = 0; i < MAX_WMMAP_INFO && count < MAX_WMMAP_INFO; i++) {
8010530a:	83 c3 01             	add    $0x1,%ebx
            count++;
8010530d:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
    for (int i = 0; i < MAX_WMMAP_INFO && count < MAX_WMMAP_INFO; i++) {
80105311:	83 c6 18             	add    $0x18,%esi
80105314:	83 fb 0f             	cmp    $0xf,%ebx
80105317:	0f 8e 6a ff ff ff    	jle    80105287 <sys_getwmapinfo+0x57>
8010531d:	8d 76 00             	lea    0x0(%esi),%esi
    wminfo->total_mmaps = count;
80105320:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105323:	89 10                	mov    %edx,(%eax)
    return 0; // Success
80105325:	31 c0                	xor    %eax,%eax
}
80105327:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010532a:	5b                   	pop    %ebx
8010532b:	5e                   	pop    %esi
8010532c:	5f                   	pop    %edi
8010532d:	5d                   	pop    %ebp
8010532e:	c3                   	ret    
        return -1;
8010532f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105334:	eb f1                	jmp    80105327 <sys_getwmapinfo+0xf7>
80105336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533d:	8d 76 00             	lea    0x0(%esi),%esi

80105340 <sys_dup>:
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	56                   	push   %esi
80105344:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105345:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105348:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010534b:	50                   	push   %eax
8010534c:	6a 00                	push   $0x0
8010534e:	e8 9d f7 ff ff       	call   80104af0 <argint>
80105353:	83 c4 10             	add    $0x10,%esp
80105356:	85 c0                	test   %eax,%eax
80105358:	78 36                	js     80105390 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010535a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010535e:	77 30                	ja     80105390 <sys_dup+0x50>
80105360:	e8 3b e6 ff ff       	call   801039a0 <myproc>
80105365:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105368:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010536c:	85 f6                	test   %esi,%esi
8010536e:	74 20                	je     80105390 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105370:	e8 2b e6 ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105375:	31 db                	xor    %ebx,%ebx
80105377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105380:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105384:	85 d2                	test   %edx,%edx
80105386:	74 18                	je     801053a0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105388:	83 c3 01             	add    $0x1,%ebx
8010538b:	83 fb 10             	cmp    $0x10,%ebx
8010538e:	75 f0                	jne    80105380 <sys_dup+0x40>
}
80105390:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105393:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105398:	89 d8                	mov    %ebx,%eax
8010539a:	5b                   	pop    %ebx
8010539b:	5e                   	pop    %esi
8010539c:	5d                   	pop    %ebp
8010539d:	c3                   	ret    
8010539e:	66 90                	xchg   %ax,%ax
  filedup(f);
801053a0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053a3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801053a7:	56                   	push   %esi
801053a8:	e8 f3 ba ff ff       	call   80100ea0 <filedup>
  return fd;
801053ad:	83 c4 10             	add    $0x10,%esp
}
801053b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053b3:	89 d8                	mov    %ebx,%eax
801053b5:	5b                   	pop    %ebx
801053b6:	5e                   	pop    %esi
801053b7:	5d                   	pop    %ebp
801053b8:	c3                   	ret    
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053c0 <sys_read>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	56                   	push   %esi
801053c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801053c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801053c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053cb:	53                   	push   %ebx
801053cc:	6a 00                	push   $0x0
801053ce:	e8 1d f7 ff ff       	call   80104af0 <argint>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	85 c0                	test   %eax,%eax
801053d8:	78 5e                	js     80105438 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053de:	77 58                	ja     80105438 <sys_read+0x78>
801053e0:	e8 bb e5 ff ff       	call   801039a0 <myproc>
801053e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801053ec:	85 f6                	test   %esi,%esi
801053ee:	74 48                	je     80105438 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053f0:	83 ec 08             	sub    $0x8,%esp
801053f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053f6:	50                   	push   %eax
801053f7:	6a 02                	push   $0x2
801053f9:	e8 f2 f6 ff ff       	call   80104af0 <argint>
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	85 c0                	test   %eax,%eax
80105403:	78 33                	js     80105438 <sys_read+0x78>
80105405:	83 ec 04             	sub    $0x4,%esp
80105408:	ff 75 f0             	push   -0x10(%ebp)
8010540b:	53                   	push   %ebx
8010540c:	6a 01                	push   $0x1
8010540e:	e8 2d f7 ff ff       	call   80104b40 <argptr>
80105413:	83 c4 10             	add    $0x10,%esp
80105416:	85 c0                	test   %eax,%eax
80105418:	78 1e                	js     80105438 <sys_read+0x78>
  return fileread(f, p, n);
8010541a:	83 ec 04             	sub    $0x4,%esp
8010541d:	ff 75 f0             	push   -0x10(%ebp)
80105420:	ff 75 f4             	push   -0xc(%ebp)
80105423:	56                   	push   %esi
80105424:	e8 f7 bb ff ff       	call   80101020 <fileread>
80105429:	83 c4 10             	add    $0x10,%esp
}
8010542c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010542f:	5b                   	pop    %ebx
80105430:	5e                   	pop    %esi
80105431:	5d                   	pop    %ebp
80105432:	c3                   	ret    
80105433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105437:	90                   	nop
    return -1;
80105438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543d:	eb ed                	jmp    8010542c <sys_read+0x6c>
8010543f:	90                   	nop

80105440 <sys_write>:
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	56                   	push   %esi
80105444:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105445:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105448:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010544b:	53                   	push   %ebx
8010544c:	6a 00                	push   $0x0
8010544e:	e8 9d f6 ff ff       	call   80104af0 <argint>
80105453:	83 c4 10             	add    $0x10,%esp
80105456:	85 c0                	test   %eax,%eax
80105458:	78 5e                	js     801054b8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010545a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010545e:	77 58                	ja     801054b8 <sys_write+0x78>
80105460:	e8 3b e5 ff ff       	call   801039a0 <myproc>
80105465:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105468:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010546c:	85 f6                	test   %esi,%esi
8010546e:	74 48                	je     801054b8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105470:	83 ec 08             	sub    $0x8,%esp
80105473:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105476:	50                   	push   %eax
80105477:	6a 02                	push   $0x2
80105479:	e8 72 f6 ff ff       	call   80104af0 <argint>
8010547e:	83 c4 10             	add    $0x10,%esp
80105481:	85 c0                	test   %eax,%eax
80105483:	78 33                	js     801054b8 <sys_write+0x78>
80105485:	83 ec 04             	sub    $0x4,%esp
80105488:	ff 75 f0             	push   -0x10(%ebp)
8010548b:	53                   	push   %ebx
8010548c:	6a 01                	push   $0x1
8010548e:	e8 ad f6 ff ff       	call   80104b40 <argptr>
80105493:	83 c4 10             	add    $0x10,%esp
80105496:	85 c0                	test   %eax,%eax
80105498:	78 1e                	js     801054b8 <sys_write+0x78>
  return filewrite(f, p, n);
8010549a:	83 ec 04             	sub    $0x4,%esp
8010549d:	ff 75 f0             	push   -0x10(%ebp)
801054a0:	ff 75 f4             	push   -0xc(%ebp)
801054a3:	56                   	push   %esi
801054a4:	e8 07 bc ff ff       	call   801010b0 <filewrite>
801054a9:	83 c4 10             	add    $0x10,%esp
}
801054ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054af:	5b                   	pop    %ebx
801054b0:	5e                   	pop    %esi
801054b1:	5d                   	pop    %ebp
801054b2:	c3                   	ret    
801054b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054b7:	90                   	nop
    return -1;
801054b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bd:	eb ed                	jmp    801054ac <sys_write+0x6c>
801054bf:	90                   	nop

801054c0 <sys_close>:
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	56                   	push   %esi
801054c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801054c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054cb:	50                   	push   %eax
801054cc:	6a 00                	push   $0x0
801054ce:	e8 1d f6 ff ff       	call   80104af0 <argint>
801054d3:	83 c4 10             	add    $0x10,%esp
801054d6:	85 c0                	test   %eax,%eax
801054d8:	78 3e                	js     80105518 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054de:	77 38                	ja     80105518 <sys_close+0x58>
801054e0:	e8 bb e4 ff ff       	call   801039a0 <myproc>
801054e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054e8:	8d 5a 08             	lea    0x8(%edx),%ebx
801054eb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801054ef:	85 f6                	test   %esi,%esi
801054f1:	74 25                	je     80105518 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801054f3:	e8 a8 e4 ff ff       	call   801039a0 <myproc>
  fileclose(f);
801054f8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801054fb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105502:	00 
  fileclose(f);
80105503:	56                   	push   %esi
80105504:	e8 e7 b9 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105509:	83 c4 10             	add    $0x10,%esp
8010550c:	31 c0                	xor    %eax,%eax
}
8010550e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105511:	5b                   	pop    %ebx
80105512:	5e                   	pop    %esi
80105513:	5d                   	pop    %ebp
80105514:	c3                   	ret    
80105515:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551d:	eb ef                	jmp    8010550e <sys_close+0x4e>
8010551f:	90                   	nop

80105520 <sys_fstat>:
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	56                   	push   %esi
80105524:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105525:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105528:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010552b:	53                   	push   %ebx
8010552c:	6a 00                	push   $0x0
8010552e:	e8 bd f5 ff ff       	call   80104af0 <argint>
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	85 c0                	test   %eax,%eax
80105538:	78 46                	js     80105580 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010553a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010553e:	77 40                	ja     80105580 <sys_fstat+0x60>
80105540:	e8 5b e4 ff ff       	call   801039a0 <myproc>
80105545:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105548:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010554c:	85 f6                	test   %esi,%esi
8010554e:	74 30                	je     80105580 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105550:	83 ec 04             	sub    $0x4,%esp
80105553:	6a 14                	push   $0x14
80105555:	53                   	push   %ebx
80105556:	6a 01                	push   $0x1
80105558:	e8 e3 f5 ff ff       	call   80104b40 <argptr>
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	85 c0                	test   %eax,%eax
80105562:	78 1c                	js     80105580 <sys_fstat+0x60>
  return filestat(f, st);
80105564:	83 ec 08             	sub    $0x8,%esp
80105567:	ff 75 f4             	push   -0xc(%ebp)
8010556a:	56                   	push   %esi
8010556b:	e8 60 ba ff ff       	call   80100fd0 <filestat>
80105570:	83 c4 10             	add    $0x10,%esp
}
80105573:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105576:	5b                   	pop    %ebx
80105577:	5e                   	pop    %esi
80105578:	5d                   	pop    %ebp
80105579:	c3                   	ret    
8010557a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105585:	eb ec                	jmp    80105573 <sys_fstat+0x53>
80105587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558e:	66 90                	xchg   %ax,%ax

80105590 <sys_link>:
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105595:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105598:	53                   	push   %ebx
80105599:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010559c:	50                   	push   %eax
8010559d:	6a 00                	push   $0x0
8010559f:	e8 0c f6 ff ff       	call   80104bb0 <argstr>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	85 c0                	test   %eax,%eax
801055a9:	0f 88 fb 00 00 00    	js     801056aa <sys_link+0x11a>
801055af:	83 ec 08             	sub    $0x8,%esp
801055b2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055b5:	50                   	push   %eax
801055b6:	6a 01                	push   $0x1
801055b8:	e8 f3 f5 ff ff       	call   80104bb0 <argstr>
801055bd:	83 c4 10             	add    $0x10,%esp
801055c0:	85 c0                	test   %eax,%eax
801055c2:	0f 88 e2 00 00 00    	js     801056aa <sys_link+0x11a>
  begin_op();
801055c8:	e8 b3 d7 ff ff       	call   80102d80 <begin_op>
  if((ip = namei(old)) == 0){
801055cd:	83 ec 0c             	sub    $0xc,%esp
801055d0:	ff 75 d4             	push   -0x2c(%ebp)
801055d3:	e8 e8 ca ff ff       	call   801020c0 <namei>
801055d8:	83 c4 10             	add    $0x10,%esp
801055db:	89 c3                	mov    %eax,%ebx
801055dd:	85 c0                	test   %eax,%eax
801055df:	0f 84 e4 00 00 00    	je     801056c9 <sys_link+0x139>
  ilock(ip);
801055e5:	83 ec 0c             	sub    $0xc,%esp
801055e8:	50                   	push   %eax
801055e9:	e8 b2 c1 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055f6:	0f 84 b5 00 00 00    	je     801056b1 <sys_link+0x121>
  iupdate(ip);
801055fc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801055ff:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105604:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105607:	53                   	push   %ebx
80105608:	e8 e3 c0 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
8010560d:	89 1c 24             	mov    %ebx,(%esp)
80105610:	e8 6b c2 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105615:	58                   	pop    %eax
80105616:	5a                   	pop    %edx
80105617:	57                   	push   %edi
80105618:	ff 75 d0             	push   -0x30(%ebp)
8010561b:	e8 c0 ca ff ff       	call   801020e0 <nameiparent>
80105620:	83 c4 10             	add    $0x10,%esp
80105623:	89 c6                	mov    %eax,%esi
80105625:	85 c0                	test   %eax,%eax
80105627:	74 5b                	je     80105684 <sys_link+0xf4>
  ilock(dp);
80105629:	83 ec 0c             	sub    $0xc,%esp
8010562c:	50                   	push   %eax
8010562d:	e8 6e c1 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105632:	8b 03                	mov    (%ebx),%eax
80105634:	83 c4 10             	add    $0x10,%esp
80105637:	39 06                	cmp    %eax,(%esi)
80105639:	75 3d                	jne    80105678 <sys_link+0xe8>
8010563b:	83 ec 04             	sub    $0x4,%esp
8010563e:	ff 73 04             	push   0x4(%ebx)
80105641:	57                   	push   %edi
80105642:	56                   	push   %esi
80105643:	e8 b8 c9 ff ff       	call   80102000 <dirlink>
80105648:	83 c4 10             	add    $0x10,%esp
8010564b:	85 c0                	test   %eax,%eax
8010564d:	78 29                	js     80105678 <sys_link+0xe8>
  iunlockput(dp);
8010564f:	83 ec 0c             	sub    $0xc,%esp
80105652:	56                   	push   %esi
80105653:	e8 d8 c3 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
80105658:	89 1c 24             	mov    %ebx,(%esp)
8010565b:	e8 70 c2 ff ff       	call   801018d0 <iput>
  end_op();
80105660:	e8 8b d7 ff ff       	call   80102df0 <end_op>
  return 0;
80105665:	83 c4 10             	add    $0x10,%esp
80105668:	31 c0                	xor    %eax,%eax
}
8010566a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010566d:	5b                   	pop    %ebx
8010566e:	5e                   	pop    %esi
8010566f:	5f                   	pop    %edi
80105670:	5d                   	pop    %ebp
80105671:	c3                   	ret    
80105672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105678:	83 ec 0c             	sub    $0xc,%esp
8010567b:	56                   	push   %esi
8010567c:	e8 af c3 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105681:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105684:	83 ec 0c             	sub    $0xc,%esp
80105687:	53                   	push   %ebx
80105688:	e8 13 c1 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
8010568d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105692:	89 1c 24             	mov    %ebx,(%esp)
80105695:	e8 56 c0 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
8010569a:	89 1c 24             	mov    %ebx,(%esp)
8010569d:	e8 8e c3 ff ff       	call   80101a30 <iunlockput>
  end_op();
801056a2:	e8 49 d7 ff ff       	call   80102df0 <end_op>
  return -1;
801056a7:	83 c4 10             	add    $0x10,%esp
801056aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056af:	eb b9                	jmp    8010566a <sys_link+0xda>
    iunlockput(ip);
801056b1:	83 ec 0c             	sub    $0xc,%esp
801056b4:	53                   	push   %ebx
801056b5:	e8 76 c3 ff ff       	call   80101a30 <iunlockput>
    end_op();
801056ba:	e8 31 d7 ff ff       	call   80102df0 <end_op>
    return -1;
801056bf:	83 c4 10             	add    $0x10,%esp
801056c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056c7:	eb a1                	jmp    8010566a <sys_link+0xda>
    end_op();
801056c9:	e8 22 d7 ff ff       	call   80102df0 <end_op>
    return -1;
801056ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d3:	eb 95                	jmp    8010566a <sys_link+0xda>
801056d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_unlink>:
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801056e5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801056e8:	53                   	push   %ebx
801056e9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801056ec:	50                   	push   %eax
801056ed:	6a 00                	push   $0x0
801056ef:	e8 bc f4 ff ff       	call   80104bb0 <argstr>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	85 c0                	test   %eax,%eax
801056f9:	0f 88 82 01 00 00    	js     80105881 <sys_unlink+0x1a1>
  begin_op();
801056ff:	e8 7c d6 ff ff       	call   80102d80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105704:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105707:	83 ec 08             	sub    $0x8,%esp
8010570a:	53                   	push   %ebx
8010570b:	ff 75 c0             	push   -0x40(%ebp)
8010570e:	e8 cd c9 ff ff       	call   801020e0 <nameiparent>
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105719:	85 c0                	test   %eax,%eax
8010571b:	0f 84 6a 01 00 00    	je     8010588b <sys_unlink+0x1ab>
  ilock(dp);
80105721:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105724:	83 ec 0c             	sub    $0xc,%esp
80105727:	57                   	push   %edi
80105728:	e8 73 c0 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010572d:	58                   	pop    %eax
8010572e:	5a                   	pop    %edx
8010572f:	68 48 86 10 80       	push   $0x80108648
80105734:	53                   	push   %ebx
80105735:	e8 a6 c5 ff ff       	call   80101ce0 <namecmp>
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	85 c0                	test   %eax,%eax
8010573f:	0f 84 03 01 00 00    	je     80105848 <sys_unlink+0x168>
80105745:	83 ec 08             	sub    $0x8,%esp
80105748:	68 47 86 10 80       	push   $0x80108647
8010574d:	53                   	push   %ebx
8010574e:	e8 8d c5 ff ff       	call   80101ce0 <namecmp>
80105753:	83 c4 10             	add    $0x10,%esp
80105756:	85 c0                	test   %eax,%eax
80105758:	0f 84 ea 00 00 00    	je     80105848 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010575e:	83 ec 04             	sub    $0x4,%esp
80105761:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105764:	50                   	push   %eax
80105765:	53                   	push   %ebx
80105766:	57                   	push   %edi
80105767:	e8 94 c5 ff ff       	call   80101d00 <dirlookup>
8010576c:	83 c4 10             	add    $0x10,%esp
8010576f:	89 c3                	mov    %eax,%ebx
80105771:	85 c0                	test   %eax,%eax
80105773:	0f 84 cf 00 00 00    	je     80105848 <sys_unlink+0x168>
  ilock(ip);
80105779:	83 ec 0c             	sub    $0xc,%esp
8010577c:	50                   	push   %eax
8010577d:	e8 1e c0 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
80105782:	83 c4 10             	add    $0x10,%esp
80105785:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010578a:	0f 8e 24 01 00 00    	jle    801058b4 <sys_unlink+0x1d4>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105790:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105795:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105798:	74 66                	je     80105800 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010579a:	83 ec 04             	sub    $0x4,%esp
8010579d:	6a 10                	push   $0x10
8010579f:	6a 00                	push   $0x0
801057a1:	57                   	push   %edi
801057a2:	e8 89 f0 ff ff       	call   80104830 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057a7:	6a 10                	push   $0x10
801057a9:	ff 75 c4             	push   -0x3c(%ebp)
801057ac:	57                   	push   %edi
801057ad:	ff 75 b4             	push   -0x4c(%ebp)
801057b0:	e8 fb c3 ff ff       	call   80101bb0 <writei>
801057b5:	83 c4 20             	add    $0x20,%esp
801057b8:	83 f8 10             	cmp    $0x10,%eax
801057bb:	0f 85 e6 00 00 00    	jne    801058a7 <sys_unlink+0x1c7>
  if(ip->type == T_DIR){
801057c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057c6:	0f 84 9c 00 00 00    	je     80105868 <sys_unlink+0x188>
  iunlockput(dp);
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	ff 75 b4             	push   -0x4c(%ebp)
801057d2:	e8 59 c2 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
801057d7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057dc:	89 1c 24             	mov    %ebx,(%esp)
801057df:	e8 0c bf ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
801057e4:	89 1c 24             	mov    %ebx,(%esp)
801057e7:	e8 44 c2 ff ff       	call   80101a30 <iunlockput>
  end_op();
801057ec:	e8 ff d5 ff ff       	call   80102df0 <end_op>
  return 0;
801057f1:	83 c4 10             	add    $0x10,%esp
801057f4:	31 c0                	xor    %eax,%eax
}
801057f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057f9:	5b                   	pop    %ebx
801057fa:	5e                   	pop    %esi
801057fb:	5f                   	pop    %edi
801057fc:	5d                   	pop    %ebp
801057fd:	c3                   	ret    
801057fe:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105800:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105804:	76 94                	jbe    8010579a <sys_unlink+0xba>
80105806:	be 20 00 00 00       	mov    $0x20,%esi
8010580b:	eb 0f                	jmp    8010581c <sys_unlink+0x13c>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
80105810:	83 c6 10             	add    $0x10,%esi
80105813:	3b 73 58             	cmp    0x58(%ebx),%esi
80105816:	0f 83 7e ff ff ff    	jae    8010579a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010581c:	6a 10                	push   $0x10
8010581e:	56                   	push   %esi
8010581f:	57                   	push   %edi
80105820:	53                   	push   %ebx
80105821:	e8 8a c2 ff ff       	call   80101ab0 <readi>
80105826:	83 c4 10             	add    $0x10,%esp
80105829:	83 f8 10             	cmp    $0x10,%eax
8010582c:	75 6c                	jne    8010589a <sys_unlink+0x1ba>
    if(de.inum != 0)
8010582e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105833:	74 db                	je     80105810 <sys_unlink+0x130>
    iunlockput(ip);
80105835:	83 ec 0c             	sub    $0xc,%esp
80105838:	53                   	push   %ebx
80105839:	e8 f2 c1 ff ff       	call   80101a30 <iunlockput>
    goto bad;
8010583e:	83 c4 10             	add    $0x10,%esp
80105841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105848:	83 ec 0c             	sub    $0xc,%esp
8010584b:	ff 75 b4             	push   -0x4c(%ebp)
8010584e:	e8 dd c1 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105853:	e8 98 d5 ff ff       	call   80102df0 <end_op>
  return -1;
80105858:	83 c4 10             	add    $0x10,%esp
8010585b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105860:	eb 94                	jmp    801057f6 <sys_unlink+0x116>
80105862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105868:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010586b:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
8010586e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105873:	50                   	push   %eax
80105874:	e8 77 be ff ff       	call   801016f0 <iupdate>
80105879:	83 c4 10             	add    $0x10,%esp
8010587c:	e9 4b ff ff ff       	jmp    801057cc <sys_unlink+0xec>
    return -1;
80105881:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105886:	e9 6b ff ff ff       	jmp    801057f6 <sys_unlink+0x116>
    end_op();
8010588b:	e8 60 d5 ff ff       	call   80102df0 <end_op>
    return -1;
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105895:	e9 5c ff ff ff       	jmp    801057f6 <sys_unlink+0x116>
      panic("isdirempty: readi");
8010589a:	83 ec 0c             	sub    $0xc,%esp
8010589d:	68 6c 86 10 80       	push   $0x8010866c
801058a2:	e8 d9 aa ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801058a7:	83 ec 0c             	sub    $0xc,%esp
801058aa:	68 7e 86 10 80       	push   $0x8010867e
801058af:	e8 cc aa ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801058b4:	83 ec 0c             	sub    $0xc,%esp
801058b7:	68 5a 86 10 80       	push   $0x8010865a
801058bc:	e8 bf aa ff ff       	call   80100380 <panic>
801058c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058cf:	90                   	nop

801058d0 <sys_open>:

int
sys_open(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801058d8:	53                   	push   %ebx
801058d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058dc:	50                   	push   %eax
801058dd:	6a 00                	push   $0x0
801058df:	e8 cc f2 ff ff       	call   80104bb0 <argstr>
801058e4:	83 c4 10             	add    $0x10,%esp
801058e7:	85 c0                	test   %eax,%eax
801058e9:	0f 88 8e 00 00 00    	js     8010597d <sys_open+0xad>
801058ef:	83 ec 08             	sub    $0x8,%esp
801058f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058f5:	50                   	push   %eax
801058f6:	6a 01                	push   $0x1
801058f8:	e8 f3 f1 ff ff       	call   80104af0 <argint>
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	85 c0                	test   %eax,%eax
80105902:	78 79                	js     8010597d <sys_open+0xad>
    return -1;

  begin_op();
80105904:	e8 77 d4 ff ff       	call   80102d80 <begin_op>

  if(omode & O_CREATE){
80105909:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010590d:	75 79                	jne    80105988 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010590f:	83 ec 0c             	sub    $0xc,%esp
80105912:	ff 75 e0             	push   -0x20(%ebp)
80105915:	e8 a6 c7 ff ff       	call   801020c0 <namei>
8010591a:	83 c4 10             	add    $0x10,%esp
8010591d:	89 c6                	mov    %eax,%esi
8010591f:	85 c0                	test   %eax,%eax
80105921:	0f 84 7e 00 00 00    	je     801059a5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105927:	83 ec 0c             	sub    $0xc,%esp
8010592a:	50                   	push   %eax
8010592b:	e8 70 be ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105930:	83 c4 10             	add    $0x10,%esp
80105933:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105938:	0f 84 c2 00 00 00    	je     80105a00 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010593e:	e8 ed b4 ff ff       	call   80100e30 <filealloc>
80105943:	89 c7                	mov    %eax,%edi
80105945:	85 c0                	test   %eax,%eax
80105947:	74 23                	je     8010596c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105949:	e8 52 e0 ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010594e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105950:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105954:	85 d2                	test   %edx,%edx
80105956:	74 60                	je     801059b8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105958:	83 c3 01             	add    $0x1,%ebx
8010595b:	83 fb 10             	cmp    $0x10,%ebx
8010595e:	75 f0                	jne    80105950 <sys_open+0x80>
    if(f)
      fileclose(f);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	57                   	push   %edi
80105964:	e8 87 b5 ff ff       	call   80100ef0 <fileclose>
80105969:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010596c:	83 ec 0c             	sub    $0xc,%esp
8010596f:	56                   	push   %esi
80105970:	e8 bb c0 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105975:	e8 76 d4 ff ff       	call   80102df0 <end_op>
    return -1;
8010597a:	83 c4 10             	add    $0x10,%esp
8010597d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105982:	eb 6d                	jmp    801059f1 <sys_open+0x121>
80105984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010598e:	31 c9                	xor    %ecx,%ecx
80105990:	ba 02 00 00 00       	mov    $0x2,%edx
80105995:	6a 00                	push   $0x0
80105997:	e8 04 f3 ff ff       	call   80104ca0 <create>
    if(ip == 0){
8010599c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010599f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801059a1:	85 c0                	test   %eax,%eax
801059a3:	75 99                	jne    8010593e <sys_open+0x6e>
      end_op();
801059a5:	e8 46 d4 ff ff       	call   80102df0 <end_op>
      return -1;
801059aa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059af:	eb 40                	jmp    801059f1 <sys_open+0x121>
801059b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801059b8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801059bb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801059bf:	56                   	push   %esi
801059c0:	e8 bb be ff ff       	call   80101880 <iunlock>
  end_op();
801059c5:	e8 26 d4 ff ff       	call   80102df0 <end_op>

  f->type = FD_INODE;
801059ca:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801059d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059d3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801059d6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801059d9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801059db:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801059e2:	f7 d0                	not    %eax
801059e4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059e7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801059ea:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059ed:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801059f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059f4:	89 d8                	mov    %ebx,%eax
801059f6:	5b                   	pop    %ebx
801059f7:	5e                   	pop    %esi
801059f8:	5f                   	pop    %edi
801059f9:	5d                   	pop    %ebp
801059fa:	c3                   	ret    
801059fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059ff:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a00:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a03:	85 c9                	test   %ecx,%ecx
80105a05:	0f 84 33 ff ff ff    	je     8010593e <sys_open+0x6e>
80105a0b:	e9 5c ff ff ff       	jmp    8010596c <sys_open+0x9c>

80105a10 <sys_mkdir>:

int
sys_mkdir(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a16:	e8 65 d3 ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a1b:	83 ec 08             	sub    $0x8,%esp
80105a1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a21:	50                   	push   %eax
80105a22:	6a 00                	push   $0x0
80105a24:	e8 87 f1 ff ff       	call   80104bb0 <argstr>
80105a29:	83 c4 10             	add    $0x10,%esp
80105a2c:	85 c0                	test   %eax,%eax
80105a2e:	78 30                	js     80105a60 <sys_mkdir+0x50>
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a36:	31 c9                	xor    %ecx,%ecx
80105a38:	ba 01 00 00 00       	mov    $0x1,%edx
80105a3d:	6a 00                	push   $0x0
80105a3f:	e8 5c f2 ff ff       	call   80104ca0 <create>
80105a44:	83 c4 10             	add    $0x10,%esp
80105a47:	85 c0                	test   %eax,%eax
80105a49:	74 15                	je     80105a60 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a4b:	83 ec 0c             	sub    $0xc,%esp
80105a4e:	50                   	push   %eax
80105a4f:	e8 dc bf ff ff       	call   80101a30 <iunlockput>
  end_op();
80105a54:	e8 97 d3 ff ff       	call   80102df0 <end_op>
  return 0;
80105a59:	83 c4 10             	add    $0x10,%esp
80105a5c:	31 c0                	xor    %eax,%eax
}
80105a5e:	c9                   	leave  
80105a5f:	c3                   	ret    
    end_op();
80105a60:	e8 8b d3 ff ff       	call   80102df0 <end_op>
    return -1;
80105a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a6a:	c9                   	leave  
80105a6b:	c3                   	ret    
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a70 <sys_mknod>:

int
sys_mknod(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a76:	e8 05 d3 ff ff       	call   80102d80 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a7b:	83 ec 08             	sub    $0x8,%esp
80105a7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a81:	50                   	push   %eax
80105a82:	6a 00                	push   $0x0
80105a84:	e8 27 f1 ff ff       	call   80104bb0 <argstr>
80105a89:	83 c4 10             	add    $0x10,%esp
80105a8c:	85 c0                	test   %eax,%eax
80105a8e:	78 60                	js     80105af0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a90:	83 ec 08             	sub    $0x8,%esp
80105a93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a96:	50                   	push   %eax
80105a97:	6a 01                	push   $0x1
80105a99:	e8 52 f0 ff ff       	call   80104af0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a9e:	83 c4 10             	add    $0x10,%esp
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	78 4b                	js     80105af0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105aa5:	83 ec 08             	sub    $0x8,%esp
80105aa8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aab:	50                   	push   %eax
80105aac:	6a 02                	push   $0x2
80105aae:	e8 3d f0 ff ff       	call   80104af0 <argint>
     argint(1, &major) < 0 ||
80105ab3:	83 c4 10             	add    $0x10,%esp
80105ab6:	85 c0                	test   %eax,%eax
80105ab8:	78 36                	js     80105af0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105aba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105abe:	83 ec 0c             	sub    $0xc,%esp
80105ac1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105ac5:	ba 03 00 00 00       	mov    $0x3,%edx
80105aca:	50                   	push   %eax
80105acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ace:	e8 cd f1 ff ff       	call   80104ca0 <create>
     argint(2, &minor) < 0 ||
80105ad3:	83 c4 10             	add    $0x10,%esp
80105ad6:	85 c0                	test   %eax,%eax
80105ad8:	74 16                	je     80105af0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105ada:	83 ec 0c             	sub    $0xc,%esp
80105add:	50                   	push   %eax
80105ade:	e8 4d bf ff ff       	call   80101a30 <iunlockput>
  end_op();
80105ae3:	e8 08 d3 ff ff       	call   80102df0 <end_op>
  return 0;
80105ae8:	83 c4 10             	add    $0x10,%esp
80105aeb:	31 c0                	xor    %eax,%eax
}
80105aed:	c9                   	leave  
80105aee:	c3                   	ret    
80105aef:	90                   	nop
    end_op();
80105af0:	e8 fb d2 ff ff       	call   80102df0 <end_op>
    return -1;
80105af5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105afa:	c9                   	leave  
80105afb:	c3                   	ret    
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b00 <sys_chdir>:

int
sys_chdir(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	56                   	push   %esi
80105b04:	53                   	push   %ebx
80105b05:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b08:	e8 93 de ff ff       	call   801039a0 <myproc>
80105b0d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105b0f:	e8 6c d2 ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b14:	83 ec 08             	sub    $0x8,%esp
80105b17:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b1a:	50                   	push   %eax
80105b1b:	6a 00                	push   $0x0
80105b1d:	e8 8e f0 ff ff       	call   80104bb0 <argstr>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	78 77                	js     80105ba0 <sys_chdir+0xa0>
80105b29:	83 ec 0c             	sub    $0xc,%esp
80105b2c:	ff 75 f4             	push   -0xc(%ebp)
80105b2f:	e8 8c c5 ff ff       	call   801020c0 <namei>
80105b34:	83 c4 10             	add    $0x10,%esp
80105b37:	89 c3                	mov    %eax,%ebx
80105b39:	85 c0                	test   %eax,%eax
80105b3b:	74 63                	je     80105ba0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b3d:	83 ec 0c             	sub    $0xc,%esp
80105b40:	50                   	push   %eax
80105b41:	e8 5a bc ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105b46:	83 c4 10             	add    $0x10,%esp
80105b49:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b4e:	75 30                	jne    80105b80 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b50:	83 ec 0c             	sub    $0xc,%esp
80105b53:	53                   	push   %ebx
80105b54:	e8 27 bd ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105b59:	58                   	pop    %eax
80105b5a:	ff 76 68             	push   0x68(%esi)
80105b5d:	e8 6e bd ff ff       	call   801018d0 <iput>
  end_op();
80105b62:	e8 89 d2 ff ff       	call   80102df0 <end_op>
  curproc->cwd = ip;
80105b67:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b6a:	83 c4 10             	add    $0x10,%esp
80105b6d:	31 c0                	xor    %eax,%eax
}
80105b6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b72:	5b                   	pop    %ebx
80105b73:	5e                   	pop    %esi
80105b74:	5d                   	pop    %ebp
80105b75:	c3                   	ret    
80105b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	53                   	push   %ebx
80105b84:	e8 a7 be ff ff       	call   80101a30 <iunlockput>
    end_op();
80105b89:	e8 62 d2 ff ff       	call   80102df0 <end_op>
    return -1;
80105b8e:	83 c4 10             	add    $0x10,%esp
80105b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b96:	eb d7                	jmp    80105b6f <sys_chdir+0x6f>
80105b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9f:	90                   	nop
    end_op();
80105ba0:	e8 4b d2 ff ff       	call   80102df0 <end_op>
    return -1;
80105ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105baa:	eb c3                	jmp    80105b6f <sys_chdir+0x6f>
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <sys_exec>:

int
sys_exec(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	57                   	push   %edi
80105bb4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bb5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105bbb:	53                   	push   %ebx
80105bbc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bc2:	50                   	push   %eax
80105bc3:	6a 00                	push   $0x0
80105bc5:	e8 e6 ef ff ff       	call   80104bb0 <argstr>
80105bca:	83 c4 10             	add    $0x10,%esp
80105bcd:	85 c0                	test   %eax,%eax
80105bcf:	0f 88 87 00 00 00    	js     80105c5c <sys_exec+0xac>
80105bd5:	83 ec 08             	sub    $0x8,%esp
80105bd8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105bde:	50                   	push   %eax
80105bdf:	6a 01                	push   $0x1
80105be1:	e8 0a ef ff ff       	call   80104af0 <argint>
80105be6:	83 c4 10             	add    $0x10,%esp
80105be9:	85 c0                	test   %eax,%eax
80105beb:	78 6f                	js     80105c5c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105bed:	83 ec 04             	sub    $0x4,%esp
80105bf0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105bf6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105bf8:	68 80 00 00 00       	push   $0x80
80105bfd:	6a 00                	push   $0x0
80105bff:	56                   	push   %esi
80105c00:	e8 2b ec ff ff       	call   80104830 <memset>
80105c05:	83 c4 10             	add    $0x10,%esp
80105c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c10:	83 ec 08             	sub    $0x8,%esp
80105c13:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105c19:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105c20:	50                   	push   %eax
80105c21:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c27:	01 f8                	add    %edi,%eax
80105c29:	50                   	push   %eax
80105c2a:	e8 31 ee ff ff       	call   80104a60 <fetchint>
80105c2f:	83 c4 10             	add    $0x10,%esp
80105c32:	85 c0                	test   %eax,%eax
80105c34:	78 26                	js     80105c5c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105c36:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c3c:	85 c0                	test   %eax,%eax
80105c3e:	74 30                	je     80105c70 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c40:	83 ec 08             	sub    $0x8,%esp
80105c43:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105c46:	52                   	push   %edx
80105c47:	50                   	push   %eax
80105c48:	e8 53 ee ff ff       	call   80104aa0 <fetchstr>
80105c4d:	83 c4 10             	add    $0x10,%esp
80105c50:	85 c0                	test   %eax,%eax
80105c52:	78 08                	js     80105c5c <sys_exec+0xac>
  for(i=0;; i++){
80105c54:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c57:	83 fb 20             	cmp    $0x20,%ebx
80105c5a:	75 b4                	jne    80105c10 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c64:	5b                   	pop    %ebx
80105c65:	5e                   	pop    %esi
80105c66:	5f                   	pop    %edi
80105c67:	5d                   	pop    %ebp
80105c68:	c3                   	ret    
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105c70:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c77:	00 00 00 00 
  return exec(path, argv);
80105c7b:	83 ec 08             	sub    $0x8,%esp
80105c7e:	56                   	push   %esi
80105c7f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105c85:	e8 26 ae ff ff       	call   80100ab0 <exec>
80105c8a:	83 c4 10             	add    $0x10,%esp
}
80105c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c90:	5b                   	pop    %ebx
80105c91:	5e                   	pop    %esi
80105c92:	5f                   	pop    %edi
80105c93:	5d                   	pop    %ebp
80105c94:	c3                   	ret    
80105c95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ca0 <sys_pipe>:

int
sys_pipe(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	57                   	push   %edi
80105ca4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ca5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105ca8:	53                   	push   %ebx
80105ca9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105cac:	6a 08                	push   $0x8
80105cae:	50                   	push   %eax
80105caf:	6a 00                	push   $0x0
80105cb1:	e8 8a ee ff ff       	call   80104b40 <argptr>
80105cb6:	83 c4 10             	add    $0x10,%esp
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	78 4a                	js     80105d07 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105cbd:	83 ec 08             	sub    $0x8,%esp
80105cc0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cc3:	50                   	push   %eax
80105cc4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105cc7:	50                   	push   %eax
80105cc8:	e8 83 d7 ff ff       	call   80103450 <pipealloc>
80105ccd:	83 c4 10             	add    $0x10,%esp
80105cd0:	85 c0                	test   %eax,%eax
80105cd2:	78 33                	js     80105d07 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cd4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105cd7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105cd9:	e8 c2 dc ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cde:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105ce0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ce4:	85 f6                	test   %esi,%esi
80105ce6:	74 28                	je     80105d10 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105ce8:	83 c3 01             	add    $0x1,%ebx
80105ceb:	83 fb 10             	cmp    $0x10,%ebx
80105cee:	75 f0                	jne    80105ce0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	ff 75 e0             	push   -0x20(%ebp)
80105cf6:	e8 f5 b1 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105cfb:	58                   	pop    %eax
80105cfc:	ff 75 e4             	push   -0x1c(%ebp)
80105cff:	e8 ec b1 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105d04:	83 c4 10             	add    $0x10,%esp
80105d07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0c:	eb 53                	jmp    80105d61 <sys_pipe+0xc1>
80105d0e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d10:	8d 73 08             	lea    0x8(%ebx),%esi
80105d13:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105d1a:	e8 81 dc ff ff       	call   801039a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d1f:	31 d2                	xor    %edx,%edx
80105d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105d28:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105d2c:	85 c9                	test   %ecx,%ecx
80105d2e:	74 20                	je     80105d50 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105d30:	83 c2 01             	add    $0x1,%edx
80105d33:	83 fa 10             	cmp    $0x10,%edx
80105d36:	75 f0                	jne    80105d28 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105d38:	e8 63 dc ff ff       	call   801039a0 <myproc>
80105d3d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d44:	00 
80105d45:	eb a9                	jmp    80105cf0 <sys_pipe+0x50>
80105d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d4e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d50:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105d54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d57:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d59:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d5c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d5f:	31 c0                	xor    %eax,%eax
80105d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d64:	5b                   	pop    %ebx
80105d65:	5e                   	pop    %esi
80105d66:	5f                   	pop    %edi
80105d67:	5d                   	pop    %ebp
80105d68:	c3                   	ret    
80105d69:	66 90                	xchg   %ax,%ax
80105d6b:	66 90                	xchg   %ax,%ax
80105d6d:	66 90                	xchg   %ax,%ax
80105d6f:	90                   	nop

80105d70 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105d70:	e9 cb dd ff ff       	jmp    80103b40 <fork>
80105d75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d80 <sys_exit>:
}

int
sys_exit(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d86:	e8 85 e1 ff ff       	call   80103f10 <exit>
  return 0;  // not reached
}
80105d8b:	31 c0                	xor    %eax,%eax
80105d8d:	c9                   	leave  
80105d8e:	c3                   	ret    
80105d8f:	90                   	nop

80105d90 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105d90:	e9 fb e2 ff ff       	jmp    80104090 <wait>
80105d95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_kill>:
}

int
sys_kill(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105da6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105da9:	50                   	push   %eax
80105daa:	6a 00                	push   $0x0
80105dac:	e8 3f ed ff ff       	call   80104af0 <argint>
80105db1:	83 c4 10             	add    $0x10,%esp
80105db4:	85 c0                	test   %eax,%eax
80105db6:	78 18                	js     80105dd0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105db8:	83 ec 0c             	sub    $0xc,%esp
80105dbb:	ff 75 f4             	push   -0xc(%ebp)
80105dbe:	e8 6d e5 ff ff       	call   80104330 <kill>
80105dc3:	83 c4 10             	add    $0x10,%esp
}
80105dc6:	c9                   	leave  
80105dc7:	c3                   	ret    
80105dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dcf:	90                   	nop
80105dd0:	c9                   	leave  
    return -1;
80105dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dd6:	c3                   	ret    
80105dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dde:	66 90                	xchg   %ax,%ax

80105de0 <sys_getpid>:

int
sys_getpid(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105de6:	e8 b5 db ff ff       	call   801039a0 <myproc>
80105deb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dee:	c9                   	leave  
80105def:	c3                   	ret    

80105df0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105df7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dfa:	50                   	push   %eax
80105dfb:	6a 00                	push   $0x0
80105dfd:	e8 ee ec ff ff       	call   80104af0 <argint>
80105e02:	83 c4 10             	add    $0x10,%esp
80105e05:	85 c0                	test   %eax,%eax
80105e07:	78 27                	js     80105e30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105e09:	e8 92 db ff ff       	call   801039a0 <myproc>
  if(growproc(n) < 0)
80105e0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105e11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105e13:	ff 75 f4             	push   -0xc(%ebp)
80105e16:	e8 a5 dc ff ff       	call   80103ac0 <growproc>
80105e1b:	83 c4 10             	add    $0x10,%esp
80105e1e:	85 c0                	test   %eax,%eax
80105e20:	78 0e                	js     80105e30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105e22:	89 d8                	mov    %ebx,%eax
80105e24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e27:	c9                   	leave  
80105e28:	c3                   	ret    
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e35:	eb eb                	jmp    80105e22 <sys_sbrk+0x32>
80105e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3e:	66 90                	xchg   %ax,%ax

80105e40 <sys_sleep>:

int
sys_sleep(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e4a:	50                   	push   %eax
80105e4b:	6a 00                	push   $0x0
80105e4d:	e8 9e ec ff ff       	call   80104af0 <argint>
80105e52:	83 c4 10             	add    $0x10,%esp
80105e55:	85 c0                	test   %eax,%eax
80105e57:	0f 88 8a 00 00 00    	js     80105ee7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e5d:	83 ec 0c             	sub    $0xc,%esp
80105e60:	68 80 ad 11 80       	push   $0x8011ad80
80105e65:	e8 06 e9 ff ff       	call   80104770 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105e6d:	8b 1d 60 ad 11 80    	mov    0x8011ad60,%ebx
  while(ticks - ticks0 < n){
80105e73:	83 c4 10             	add    $0x10,%esp
80105e76:	85 d2                	test   %edx,%edx
80105e78:	75 27                	jne    80105ea1 <sys_sleep+0x61>
80105e7a:	eb 54                	jmp    80105ed0 <sys_sleep+0x90>
80105e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e80:	83 ec 08             	sub    $0x8,%esp
80105e83:	68 80 ad 11 80       	push   $0x8011ad80
80105e88:	68 60 ad 11 80       	push   $0x8011ad60
80105e8d:	e8 7e e3 ff ff       	call   80104210 <sleep>
  while(ticks - ticks0 < n){
80105e92:	a1 60 ad 11 80       	mov    0x8011ad60,%eax
80105e97:	83 c4 10             	add    $0x10,%esp
80105e9a:	29 d8                	sub    %ebx,%eax
80105e9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e9f:	73 2f                	jae    80105ed0 <sys_sleep+0x90>
    if(myproc()->killed){
80105ea1:	e8 fa da ff ff       	call   801039a0 <myproc>
80105ea6:	8b 40 24             	mov    0x24(%eax),%eax
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	74 d3                	je     80105e80 <sys_sleep+0x40>
      release(&tickslock);
80105ead:	83 ec 0c             	sub    $0xc,%esp
80105eb0:	68 80 ad 11 80       	push   $0x8011ad80
80105eb5:	e8 56 e8 ff ff       	call   80104710 <release>
  }
  release(&tickslock);
  return 0;
}
80105eba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105ebd:	83 c4 10             	add    $0x10,%esp
80105ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ec5:	c9                   	leave  
80105ec6:	c3                   	ret    
80105ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ece:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ed0:	83 ec 0c             	sub    $0xc,%esp
80105ed3:	68 80 ad 11 80       	push   $0x8011ad80
80105ed8:	e8 33 e8 ff ff       	call   80104710 <release>
  return 0;
80105edd:	83 c4 10             	add    $0x10,%esp
80105ee0:	31 c0                	xor    %eax,%eax
}
80105ee2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ee5:	c9                   	leave  
80105ee6:	c3                   	ret    
    return -1;
80105ee7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eec:	eb f4                	jmp    80105ee2 <sys_sleep+0xa2>
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	53                   	push   %ebx
80105ef4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ef7:	68 80 ad 11 80       	push   $0x8011ad80
80105efc:	e8 6f e8 ff ff       	call   80104770 <acquire>
  xticks = ticks;
80105f01:	8b 1d 60 ad 11 80    	mov    0x8011ad60,%ebx
  release(&tickslock);
80105f07:	c7 04 24 80 ad 11 80 	movl   $0x8011ad80,(%esp)
80105f0e:	e8 fd e7 ff ff       	call   80104710 <release>
  return xticks;
}
80105f13:	89 d8                	mov    %ebx,%eax
80105f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f18:	c9                   	leave  
80105f19:	c3                   	ret    

80105f1a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f1a:	1e                   	push   %ds
  pushl %es
80105f1b:	06                   	push   %es
  pushl %fs
80105f1c:	0f a0                	push   %fs
  pushl %gs
80105f1e:	0f a8                	push   %gs
  pushal
80105f20:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f21:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f25:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f27:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f29:	54                   	push   %esp
  call trap
80105f2a:	e8 c1 00 00 00       	call   80105ff0 <trap>
  addl $4, %esp
80105f2f:	83 c4 04             	add    $0x4,%esp

80105f32 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f32:	61                   	popa   
  popl %gs
80105f33:	0f a9                	pop    %gs
  popl %fs
80105f35:	0f a1                	pop    %fs
  popl %es
80105f37:	07                   	pop    %es
  popl %ds
80105f38:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f39:	83 c4 08             	add    $0x8,%esp
  iret
80105f3c:	cf                   	iret   
80105f3d:	66 90                	xchg   %ax,%ax
80105f3f:	90                   	nop

80105f40 <tvinit>:

pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc);

void
tvinit(void)
{
80105f40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f41:	31 c0                	xor    %eax,%eax
{
80105f43:	89 e5                	mov    %esp,%ebp
80105f45:	83 ec 08             	sub    $0x8,%esp
80105f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f50:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f57:	c7 04 c5 c2 ad 11 80 	movl   $0x8e000008,-0x7fee523e(,%eax,8)
80105f5e:	08 00 00 8e 
80105f62:	66 89 14 c5 c0 ad 11 	mov    %dx,-0x7fee5240(,%eax,8)
80105f69:	80 
80105f6a:	c1 ea 10             	shr    $0x10,%edx
80105f6d:	66 89 14 c5 c6 ad 11 	mov    %dx,-0x7fee523a(,%eax,8)
80105f74:	80 
  for(i = 0; i < 256; i++)
80105f75:	83 c0 01             	add    $0x1,%eax
80105f78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f7d:	75 d1                	jne    80105f50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105f7f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f82:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105f87:	c7 05 c2 af 11 80 08 	movl   $0xef000008,0x8011afc2
80105f8e:	00 00 ef 
  initlock(&tickslock, "time");
80105f91:	68 8d 86 10 80       	push   $0x8010868d
80105f96:	68 80 ad 11 80       	push   $0x8011ad80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f9b:	66 a3 c0 af 11 80    	mov    %ax,0x8011afc0
80105fa1:	c1 e8 10             	shr    $0x10,%eax
80105fa4:	66 a3 c6 af 11 80    	mov    %ax,0x8011afc6
  initlock(&tickslock, "time");
80105faa:	e8 f1 e5 ff ff       	call   801045a0 <initlock>
}
80105faf:	83 c4 10             	add    $0x10,%esp
80105fb2:	c9                   	leave  
80105fb3:	c3                   	ret    
80105fb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop

80105fc0 <idtinit>:

void
idtinit(void)
{
80105fc0:	55                   	push   %ebp
  pd[0] = size-1;
80105fc1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105fc6:	89 e5                	mov    %esp,%ebp
80105fc8:	83 ec 10             	sub    $0x10,%esp
80105fcb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105fcf:	b8 c0 ad 11 80       	mov    $0x8011adc0,%eax
80105fd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fd8:	c1 e8 10             	shr    $0x10,%eax
80105fdb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105fdf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fe2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105fe5:	c9                   	leave  
80105fe6:	c3                   	ret    
80105fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	57                   	push   %edi
80105ff4:	56                   	push   %esi
80105ff5:	53                   	push   %ebx
80105ff6:	83 ec 1c             	sub    $0x1c,%esp
80105ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105ffc:	8b 43 30             	mov    0x30(%ebx),%eax
80105fff:	83 f8 40             	cmp    $0x40,%eax
80106002:	0f 84 38 01 00 00    	je     80106140 <trap+0x150>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106008:	83 e8 0e             	sub    $0xe,%eax
8010600b:	83 f8 31             	cmp    $0x31,%eax
8010600e:	0f 87 8c 00 00 00    	ja     801060a0 <trap+0xb0>
80106014:	ff 24 85 68 87 10 80 	jmp    *-0x7fef7898(,%eax,4)
8010601b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010601f:	90                   	nop
    cprintf("Segmentation Fault\n");
    p->killed = 1;
}
break;
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106020:	e8 5b d9 ff ff       	call   80103980 <cpuid>
80106025:	85 c0                	test   %eax,%eax
80106027:	0f 84 83 02 00 00    	je     801062b0 <trap+0x2c0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
8010602d:	e8 fe c8 ff ff       	call   80102930 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106032:	e8 69 d9 ff ff       	call   801039a0 <myproc>
80106037:	85 c0                	test   %eax,%eax
80106039:	74 1d                	je     80106058 <trap+0x68>
8010603b:	e8 60 d9 ff ff       	call   801039a0 <myproc>
80106040:	8b 50 24             	mov    0x24(%eax),%edx
80106043:	85 d2                	test   %edx,%edx
80106045:	74 11                	je     80106058 <trap+0x68>
80106047:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010604b:	83 e0 03             	and    $0x3,%eax
8010604e:	66 83 f8 03          	cmp    $0x3,%ax
80106052:	0f 84 38 02 00 00    	je     80106290 <trap+0x2a0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106058:	e8 43 d9 ff ff       	call   801039a0 <myproc>
8010605d:	85 c0                	test   %eax,%eax
8010605f:	74 0f                	je     80106070 <trap+0x80>
80106061:	e8 3a d9 ff ff       	call   801039a0 <myproc>
80106066:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010606a:	0f 84 b8 00 00 00    	je     80106128 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106070:	e8 2b d9 ff ff       	call   801039a0 <myproc>
80106075:	85 c0                	test   %eax,%eax
80106077:	74 1d                	je     80106096 <trap+0xa6>
80106079:	e8 22 d9 ff ff       	call   801039a0 <myproc>
8010607e:	8b 40 24             	mov    0x24(%eax),%eax
80106081:	85 c0                	test   %eax,%eax
80106083:	74 11                	je     80106096 <trap+0xa6>
80106085:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106089:	83 e0 03             	and    $0x3,%eax
8010608c:	66 83 f8 03          	cmp    $0x3,%ax
80106090:	0f 84 d7 00 00 00    	je     8010616d <trap+0x17d>
    exit();
80106096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106099:	5b                   	pop    %ebx
8010609a:	5e                   	pop    %esi
8010609b:	5f                   	pop    %edi
8010609c:	5d                   	pop    %ebp
8010609d:	c3                   	ret    
8010609e:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
801060a0:	e8 fb d8 ff ff       	call   801039a0 <myproc>
801060a5:	85 c0                	test   %eax,%eax
801060a7:	0f 84 80 03 00 00    	je     8010642d <trap+0x43d>
801060ad:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801060b1:	0f 84 76 03 00 00    	je     8010642d <trap+0x43d>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060b7:	0f 20 d1             	mov    %cr2,%ecx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060ba:	8b 53 38             	mov    0x38(%ebx),%edx
801060bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801060c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801060c3:	e8 b8 d8 ff ff       	call   80103980 <cpuid>
801060c8:	8b 73 30             	mov    0x30(%ebx),%esi
801060cb:	89 c7                	mov    %eax,%edi
801060cd:	8b 43 34             	mov    0x34(%ebx),%eax
801060d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801060d3:	e8 c8 d8 ff ff       	call   801039a0 <myproc>
801060d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060db:	e8 c0 d8 ff ff       	call   801039a0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060e0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801060e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801060e6:	51                   	push   %ecx
801060e7:	52                   	push   %edx
801060e8:	57                   	push   %edi
801060e9:	ff 75 e4             	push   -0x1c(%ebp)
801060ec:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801060ed:	8b 75 e0             	mov    -0x20(%ebp),%esi
801060f0:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060f3:	56                   	push   %esi
801060f4:	ff 70 10             	push   0x10(%eax)
801060f7:	68 24 87 10 80       	push   $0x80108724
801060fc:	e8 9f a5 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80106101:	83 c4 20             	add    $0x20,%esp
80106104:	e8 97 d8 ff ff       	call   801039a0 <myproc>
80106109:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106110:	e8 8b d8 ff ff       	call   801039a0 <myproc>
80106115:	85 c0                	test   %eax,%eax
80106117:	0f 85 1e ff ff ff    	jne    8010603b <trap+0x4b>
8010611d:	e9 36 ff ff ff       	jmp    80106058 <trap+0x68>
80106122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106128:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010612c:	0f 85 3e ff ff ff    	jne    80106070 <trap+0x80>
    yield();
80106132:	e8 89 e0 ff ff       	call   801041c0 <yield>
80106137:	e9 34 ff ff ff       	jmp    80106070 <trap+0x80>
8010613c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106140:	e8 5b d8 ff ff       	call   801039a0 <myproc>
80106145:	8b 40 24             	mov    0x24(%eax),%eax
80106148:	85 c0                	test   %eax,%eax
8010614a:	0f 85 50 01 00 00    	jne    801062a0 <trap+0x2b0>
    myproc()->tf = tf;
80106150:	e8 4b d8 ff ff       	call   801039a0 <myproc>
80106155:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106158:	e8 d3 ea ff ff       	call   80104c30 <syscall>
    if(myproc()->killed)
8010615d:	e8 3e d8 ff ff       	call   801039a0 <myproc>
80106162:	8b 40 24             	mov    0x24(%eax),%eax
80106165:	85 c0                	test   %eax,%eax
80106167:	0f 84 29 ff ff ff    	je     80106096 <trap+0xa6>
8010616d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106170:	5b                   	pop    %ebx
80106171:	5e                   	pop    %esi
80106172:	5f                   	pop    %edi
80106173:	5d                   	pop    %ebp
      exit();
80106174:	e9 97 dd ff ff       	jmp    80103f10 <exit>
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106180:	8b 7b 38             	mov    0x38(%ebx),%edi
80106183:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106187:	e8 f4 d7 ff ff       	call   80103980 <cpuid>
8010618c:	57                   	push   %edi
8010618d:	56                   	push   %esi
8010618e:	50                   	push   %eax
8010618f:	68 cc 86 10 80       	push   $0x801086cc
80106194:	e8 07 a5 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106199:	e8 92 c7 ff ff       	call   80102930 <lapiceoi>
    break;
8010619e:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061a1:	e8 fa d7 ff ff       	call   801039a0 <myproc>
801061a6:	85 c0                	test   %eax,%eax
801061a8:	0f 85 8d fe ff ff    	jne    8010603b <trap+0x4b>
801061ae:	e9 a5 fe ff ff       	jmp    80106058 <trap+0x68>
801061b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061b7:	90                   	nop
    kbdintr();
801061b8:	e8 33 c6 ff ff       	call   801027f0 <kbdintr>
    lapiceoi();
801061bd:	e8 6e c7 ff ff       	call   80102930 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061c2:	e8 d9 d7 ff ff       	call   801039a0 <myproc>
801061c7:	85 c0                	test   %eax,%eax
801061c9:	0f 85 6c fe ff ff    	jne    8010603b <trap+0x4b>
801061cf:	e9 84 fe ff ff       	jmp    80106058 <trap+0x68>
801061d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801061d8:	e8 f3 03 00 00       	call   801065d0 <uartintr>
    lapiceoi();
801061dd:	e8 4e c7 ff ff       	call   80102930 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061e2:	e8 b9 d7 ff ff       	call   801039a0 <myproc>
801061e7:	85 c0                	test   %eax,%eax
801061e9:	0f 85 4c fe ff ff    	jne    8010603b <trap+0x4b>
801061ef:	e9 64 fe ff ff       	jmp    80106058 <trap+0x68>
801061f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801061f8:	e8 63 c0 ff ff       	call   80102260 <ideintr>
801061fd:	e9 2b fe ff ff       	jmp    8010602d <trap+0x3d>
80106202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106208:	0f 20 d6             	mov    %cr2,%esi
    struct proc *p = myproc();
8010620b:	e8 90 d7 ff ff       	call   801039a0 <myproc>
    pte_t *pte = walkpgdir(p->pgdir, (void *)fault_addr, 0);
80106210:	83 ec 04             	sub    $0x4,%esp
80106213:	6a 00                	push   $0x0
80106215:	56                   	push   %esi
80106216:	ff 70 04             	push   0x4(%eax)
    struct proc *p = myproc();
80106219:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pte_t *pte = walkpgdir(p->pgdir, (void *)fault_addr, 0);
8010621c:	e8 7f 0f 00 00       	call   801071a0 <walkpgdir>
    if (pte && (*pte & PTE_P) && (*pte & PTE_COW)) {
80106221:	83 c4 10             	add    $0x10,%esp
    pte_t *pte = walkpgdir(p->pgdir, (void *)fault_addr, 0);
80106224:	89 c7                	mov    %eax,%edi
    if (pte && (*pte & PTE_P) && (*pte & PTE_COW)) {
80106226:	85 c0                	test   %eax,%eax
80106228:	74 12                	je     8010623c <trap+0x24c>
8010622a:	8b 00                	mov    (%eax),%eax
8010622c:	25 01 08 00 00       	and    $0x801,%eax
80106231:	3d 01 08 00 00       	cmp    $0x801,%eax
80106236:	0f 84 74 01 00 00    	je     801063b0 <trap+0x3c0>
8010623c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
{
8010623f:	31 c9                	xor    %ecx,%ecx
80106241:	83 c0 7c             	add    $0x7c,%eax
80106244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->mmaps[i].used && fault_addr >= p->mmaps[i].addr &&
80106248:	8b 78 0c             	mov    0xc(%eax),%edi
8010624b:	85 ff                	test   %edi,%edi
8010624d:	74 11                	je     80106260 <trap+0x270>
8010624f:	8b 10                	mov    (%eax),%edx
80106251:	39 f2                	cmp    %esi,%edx
80106253:	77 0b                	ja     80106260 <trap+0x270>
            fault_addr < p->mmaps[i].addr + p->mmaps[i].length) {
80106255:	03 50 04             	add    0x4(%eax),%edx
        if (p->mmaps[i].used && fault_addr >= p->mmaps[i].addr &&
80106258:	39 f2                	cmp    %esi,%edx
8010625a:	0f 87 88 00 00 00    	ja     801062e8 <trap+0x2f8>
    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80106260:	83 c1 01             	add    $0x1,%ecx
80106263:	83 c0 18             	add    $0x18,%eax
80106266:	83 f9 10             	cmp    $0x10,%ecx
80106269:	75 dd                	jne    80106248 <trap+0x258>
    cprintf("Segmentation Fault\n");
8010626b:	83 ec 0c             	sub    $0xc,%esp
8010626e:	68 b2 86 10 80       	push   $0x801086b2
80106273:	e8 28 a4 ff ff       	call   801006a0 <cprintf>
    p->killed = 1;
80106278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
break;
8010627b:	83 c4 10             	add    $0x10,%esp
    p->killed = 1;
8010627e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
break;
80106285:	e9 a8 fd ff ff       	jmp    80106032 <trap+0x42>
8010628a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106290:	e8 7b dc ff ff       	call   80103f10 <exit>
80106295:	e9 be fd ff ff       	jmp    80106058 <trap+0x68>
8010629a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801062a0:	e8 6b dc ff ff       	call   80103f10 <exit>
801062a5:	e9 a6 fe ff ff       	jmp    80106150 <trap+0x160>
801062aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801062b0:	83 ec 0c             	sub    $0xc,%esp
801062b3:	68 80 ad 11 80       	push   $0x8011ad80
801062b8:	e8 b3 e4 ff ff       	call   80104770 <acquire>
      wakeup(&ticks);
801062bd:	c7 04 24 60 ad 11 80 	movl   $0x8011ad60,(%esp)
      ticks++;
801062c4:	83 05 60 ad 11 80 01 	addl   $0x1,0x8011ad60
      wakeup(&ticks);
801062cb:	e8 00 e0 ff ff       	call   801042d0 <wakeup>
      release(&tickslock);
801062d0:	c7 04 24 80 ad 11 80 	movl   $0x8011ad80,(%esp)
801062d7:	e8 34 e4 ff ff       	call   80104710 <release>
801062dc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801062df:	e9 49 fd ff ff       	jmp    8010602d <trap+0x3d>
801062e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            char *mem = kalloc();
801062e8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801062eb:	e8 b0 c3 ff ff       	call   801026a0 <kalloc>
            if (mem == 0) {
801062f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801062f3:	85 c0                	test   %eax,%eax
            char *mem = kalloc();
801062f5:	89 c7                	mov    %eax,%edi
            if (mem == 0) {
801062f7:	0f 84 1b 01 00 00    	je     80106418 <trap+0x428>
            memset(mem, 0, PGSIZE);
801062fd:	83 ec 04             	sub    $0x4,%esp
80106300:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106303:	68 00 10 00 00       	push   $0x1000
80106308:	6a 00                	push   $0x0
8010630a:	50                   	push   %eax
8010630b:	e8 20 e5 ff ff       	call   80104830 <memset>
            if (p->mmaps[i].fd != -1) {
80106310:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106313:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106316:	83 c4 10             	add    $0x10,%esp
80106319:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
8010631c:	8d 04 c2             	lea    (%edx,%eax,8),%eax
8010631f:	8b 88 8c 00 00 00    	mov    0x8c(%eax),%ecx
80106325:	83 f9 ff             	cmp    $0xffffffff,%ecx
80106328:	74 31                	je     8010635b <trap+0x36b>
                struct file *f = p->ofile[p->mmaps[i].fd];
8010632a:	8b 4c 8a 28          	mov    0x28(%edx,%ecx,4),%ecx
                fileseek(f, (fault_addr - p->mmaps[i].addr) + p->mmaps[i].file_offset);
8010632e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80106334:	83 ec 08             	sub    $0x8,%esp
80106337:	01 f2                	add    %esi,%edx
80106339:	2b 50 7c             	sub    0x7c(%eax),%edx
8010633c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010633f:	52                   	push   %edx
80106340:	51                   	push   %ecx
80106341:	e8 7a ae ff ff       	call   801011c0 <fileseek>
                fileread(f, mem, PGSIZE);
80106346:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106349:	83 c4 0c             	add    $0xc,%esp
8010634c:	68 00 10 00 00       	push   $0x1000
80106351:	57                   	push   %edi
80106352:	51                   	push   %ecx
80106353:	e8 c8 ac ff ff       	call   80101020 <fileread>
80106358:	83 c4 10             	add    $0x10,%esp
            if (mappages(p->pgdir, (void *)PGROUNDDOWN(fault_addr),
8010635b:	83 ec 0c             	sub    $0xc,%esp
8010635e:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80106364:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
8010636a:	6a 06                	push   $0x6
8010636c:	50                   	push   %eax
8010636d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106370:	68 00 10 00 00       	push   $0x1000
80106375:	56                   	push   %esi
80106376:	ff 70 04             	push   0x4(%eax)
80106379:	e8 b2 0e 00 00       	call   80107230 <mappages>
8010637e:	83 c4 20             	add    $0x20,%esp
80106381:	85 c0                	test   %eax,%eax
80106383:	0f 89 0d fd ff ff    	jns    80106096 <trap+0xa6>
                kfree(mem);
80106389:	83 ec 0c             	sub    $0xc,%esp
8010638c:	57                   	push   %edi
8010638d:	e8 4e c1 ff ff       	call   801024e0 <kfree>
                cprintf("mappages failed\n");
80106392:	c7 04 24 a1 86 10 80 	movl   $0x801086a1,(%esp)
80106399:	e8 02 a3 ff ff       	call   801006a0 <cprintf>
                break;
8010639e:	83 c4 10             	add    $0x10,%esp
801063a1:	e9 c5 fe ff ff       	jmp    8010626b <trap+0x27b>
801063a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ad:	8d 76 00             	lea    0x0(%esi),%esi
        char *mem = kalloc();
801063b0:	e8 eb c2 ff ff       	call   801026a0 <kalloc>
801063b5:	89 c6                	mov    %eax,%esi
        if (mem == 0) {
801063b7:	85 c0                	test   %eax,%eax
801063b9:	74 48                	je     80106403 <trap+0x413>
        memmove(mem, (char *)P2V(PTE_ADDR(*pte)), PGSIZE);
801063bb:	83 ec 04             	sub    $0x4,%esp
801063be:	68 00 10 00 00       	push   $0x1000
801063c3:	8b 07                	mov    (%edi),%eax
801063c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801063ca:	05 00 00 00 80       	add    $0x80000000,%eax
801063cf:	50                   	push   %eax
801063d0:	56                   	push   %esi
801063d1:	e8 fa e4 ff ff       	call   801048d0 <memmove>
        *pte = V2P(mem) | PTE_FLAGS(*pte);
801063d6:	8b 07                	mov    (%edi),%eax
801063d8:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
801063de:	25 ff 0f 00 00       	and    $0xfff,%eax
801063e3:	09 d0                	or     %edx,%eax
        *pte &= ~PTE_COW;  // Clear COW bit
801063e5:	80 e4 f7             	and    $0xf7,%ah
        *pte |= PTE_W;     // Set write bit
801063e8:	83 c8 02             	or     $0x2,%eax
801063eb:	89 07                	mov    %eax,(%edi)
        lcr3(V2P(p->pgdir));  // Flush TLB
801063ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063f0:	8b 40 04             	mov    0x4(%eax),%eax
801063f3:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801063f8:	0f 22 d8             	mov    %eax,%cr3
        return;  // Handled the page fault
801063fb:	83 c4 10             	add    $0x10,%esp
801063fe:	e9 93 fc ff ff       	jmp    80106096 <trap+0xa6>
            cprintf("Out of memory\n");
80106403:	83 ec 0c             	sub    $0xc,%esp
80106406:	68 92 86 10 80       	push   $0x80108692
8010640b:	e8 90 a2 ff ff       	call   801006a0 <cprintf>
            break;
80106410:	83 c4 10             	add    $0x10,%esp
80106413:	e9 1a fc ff ff       	jmp    80106032 <trap+0x42>
                cprintf("Out of memory\n");
80106418:	83 ec 0c             	sub    $0xc,%esp
8010641b:	68 92 86 10 80       	push   $0x80108692
80106420:	e8 7b a2 ff ff       	call   801006a0 <cprintf>
                break;
80106425:	83 c4 10             	add    $0x10,%esp
80106428:	e9 3e fe ff ff       	jmp    8010626b <trap+0x27b>
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010642d:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106430:	8b 73 38             	mov    0x38(%ebx),%esi
80106433:	e8 48 d5 ff ff       	call   80103980 <cpuid>
80106438:	83 ec 0c             	sub    $0xc,%esp
8010643b:	57                   	push   %edi
8010643c:	56                   	push   %esi
8010643d:	50                   	push   %eax
8010643e:	ff 73 30             	push   0x30(%ebx)
80106441:	68 f0 86 10 80       	push   $0x801086f0
80106446:	e8 55 a2 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010644b:	83 c4 14             	add    $0x14,%esp
8010644e:	68 c6 86 10 80       	push   $0x801086c6
80106453:	e8 28 9f ff ff       	call   80100380 <panic>
80106458:	66 90                	xchg   %ax,%ax
8010645a:	66 90                	xchg   %ax,%ax
8010645c:	66 90                	xchg   %ax,%ax
8010645e:	66 90                	xchg   %ax,%ax

80106460 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106460:	a1 c0 b5 11 80       	mov    0x8011b5c0,%eax
80106465:	85 c0                	test   %eax,%eax
80106467:	74 17                	je     80106480 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106469:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010646e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010646f:	a8 01                	test   $0x1,%al
80106471:	74 0d                	je     80106480 <uartgetc+0x20>
80106473:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106478:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106479:	0f b6 c0             	movzbl %al,%eax
8010647c:	c3                   	ret    
8010647d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106485:	c3                   	ret    
80106486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010648d:	8d 76 00             	lea    0x0(%esi),%esi

80106490 <uartinit>:
{
80106490:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106491:	31 c9                	xor    %ecx,%ecx
80106493:	89 c8                	mov    %ecx,%eax
80106495:	89 e5                	mov    %esp,%ebp
80106497:	57                   	push   %edi
80106498:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010649d:	56                   	push   %esi
8010649e:	89 fa                	mov    %edi,%edx
801064a0:	53                   	push   %ebx
801064a1:	83 ec 1c             	sub    $0x1c,%esp
801064a4:	ee                   	out    %al,(%dx)
801064a5:	be fb 03 00 00       	mov    $0x3fb,%esi
801064aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801064af:	89 f2                	mov    %esi,%edx
801064b1:	ee                   	out    %al,(%dx)
801064b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801064b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064bc:	ee                   	out    %al,(%dx)
801064bd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801064c2:	89 c8                	mov    %ecx,%eax
801064c4:	89 da                	mov    %ebx,%edx
801064c6:	ee                   	out    %al,(%dx)
801064c7:	b8 03 00 00 00       	mov    $0x3,%eax
801064cc:	89 f2                	mov    %esi,%edx
801064ce:	ee                   	out    %al,(%dx)
801064cf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801064d4:	89 c8                	mov    %ecx,%eax
801064d6:	ee                   	out    %al,(%dx)
801064d7:	b8 01 00 00 00       	mov    $0x1,%eax
801064dc:	89 da                	mov    %ebx,%edx
801064de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064df:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064e4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801064e5:	3c ff                	cmp    $0xff,%al
801064e7:	74 78                	je     80106561 <uartinit+0xd1>
  uart = 1;
801064e9:	c7 05 c0 b5 11 80 01 	movl   $0x1,0x8011b5c0
801064f0:	00 00 00 
801064f3:	89 fa                	mov    %edi,%edx
801064f5:	ec                   	in     (%dx),%al
801064f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064fb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801064fc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801064ff:	bf 30 88 10 80       	mov    $0x80108830,%edi
80106504:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106509:	6a 00                	push   $0x0
8010650b:	6a 04                	push   $0x4
8010650d:	e8 8e bf ff ff       	call   801024a0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106512:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106516:	83 c4 10             	add    $0x10,%esp
80106519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106520:	a1 c0 b5 11 80       	mov    0x8011b5c0,%eax
80106525:	bb 80 00 00 00       	mov    $0x80,%ebx
8010652a:	85 c0                	test   %eax,%eax
8010652c:	75 14                	jne    80106542 <uartinit+0xb2>
8010652e:	eb 23                	jmp    80106553 <uartinit+0xc3>
    microdelay(10);
80106530:	83 ec 0c             	sub    $0xc,%esp
80106533:	6a 0a                	push   $0xa
80106535:	e8 16 c4 ff ff       	call   80102950 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010653a:	83 c4 10             	add    $0x10,%esp
8010653d:	83 eb 01             	sub    $0x1,%ebx
80106540:	74 07                	je     80106549 <uartinit+0xb9>
80106542:	89 f2                	mov    %esi,%edx
80106544:	ec                   	in     (%dx),%al
80106545:	a8 20                	test   $0x20,%al
80106547:	74 e7                	je     80106530 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106549:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010654d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106552:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106553:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106557:	83 c7 01             	add    $0x1,%edi
8010655a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010655d:	84 c0                	test   %al,%al
8010655f:	75 bf                	jne    80106520 <uartinit+0x90>
}
80106561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106564:	5b                   	pop    %ebx
80106565:	5e                   	pop    %esi
80106566:	5f                   	pop    %edi
80106567:	5d                   	pop    %ebp
80106568:	c3                   	ret    
80106569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106570 <uartputc>:
  if(!uart)
80106570:	a1 c0 b5 11 80       	mov    0x8011b5c0,%eax
80106575:	85 c0                	test   %eax,%eax
80106577:	74 47                	je     801065c0 <uartputc+0x50>
{
80106579:	55                   	push   %ebp
8010657a:	89 e5                	mov    %esp,%ebp
8010657c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010657d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106582:	53                   	push   %ebx
80106583:	bb 80 00 00 00       	mov    $0x80,%ebx
80106588:	eb 18                	jmp    801065a2 <uartputc+0x32>
8010658a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106590:	83 ec 0c             	sub    $0xc,%esp
80106593:	6a 0a                	push   $0xa
80106595:	e8 b6 c3 ff ff       	call   80102950 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010659a:	83 c4 10             	add    $0x10,%esp
8010659d:	83 eb 01             	sub    $0x1,%ebx
801065a0:	74 07                	je     801065a9 <uartputc+0x39>
801065a2:	89 f2                	mov    %esi,%edx
801065a4:	ec                   	in     (%dx),%al
801065a5:	a8 20                	test   $0x20,%al
801065a7:	74 e7                	je     80106590 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065a9:	8b 45 08             	mov    0x8(%ebp),%eax
801065ac:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065b1:	ee                   	out    %al,(%dx)
}
801065b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065b5:	5b                   	pop    %ebx
801065b6:	5e                   	pop    %esi
801065b7:	5d                   	pop    %ebp
801065b8:	c3                   	ret    
801065b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065c0:	c3                   	ret    
801065c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065cf:	90                   	nop

801065d0 <uartintr>:

void
uartintr(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065d6:	68 60 64 10 80       	push   $0x80106460
801065db:	e8 a0 a2 ff ff       	call   80100880 <consoleintr>
}
801065e0:	83 c4 10             	add    $0x10,%esp
801065e3:	c9                   	leave  
801065e4:	c3                   	ret    

801065e5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $0
801065e7:	6a 00                	push   $0x0
  jmp alltraps
801065e9:	e9 2c f9 ff ff       	jmp    80105f1a <alltraps>

801065ee <vector1>:
.globl vector1
vector1:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $1
801065f0:	6a 01                	push   $0x1
  jmp alltraps
801065f2:	e9 23 f9 ff ff       	jmp    80105f1a <alltraps>

801065f7 <vector2>:
.globl vector2
vector2:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $2
801065f9:	6a 02                	push   $0x2
  jmp alltraps
801065fb:	e9 1a f9 ff ff       	jmp    80105f1a <alltraps>

80106600 <vector3>:
.globl vector3
vector3:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $3
80106602:	6a 03                	push   $0x3
  jmp alltraps
80106604:	e9 11 f9 ff ff       	jmp    80105f1a <alltraps>

80106609 <vector4>:
.globl vector4
vector4:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $4
8010660b:	6a 04                	push   $0x4
  jmp alltraps
8010660d:	e9 08 f9 ff ff       	jmp    80105f1a <alltraps>

80106612 <vector5>:
.globl vector5
vector5:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $5
80106614:	6a 05                	push   $0x5
  jmp alltraps
80106616:	e9 ff f8 ff ff       	jmp    80105f1a <alltraps>

8010661b <vector6>:
.globl vector6
vector6:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $6
8010661d:	6a 06                	push   $0x6
  jmp alltraps
8010661f:	e9 f6 f8 ff ff       	jmp    80105f1a <alltraps>

80106624 <vector7>:
.globl vector7
vector7:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $7
80106626:	6a 07                	push   $0x7
  jmp alltraps
80106628:	e9 ed f8 ff ff       	jmp    80105f1a <alltraps>

8010662d <vector8>:
.globl vector8
vector8:
  pushl $8
8010662d:	6a 08                	push   $0x8
  jmp alltraps
8010662f:	e9 e6 f8 ff ff       	jmp    80105f1a <alltraps>

80106634 <vector9>:
.globl vector9
vector9:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $9
80106636:	6a 09                	push   $0x9
  jmp alltraps
80106638:	e9 dd f8 ff ff       	jmp    80105f1a <alltraps>

8010663d <vector10>:
.globl vector10
vector10:
  pushl $10
8010663d:	6a 0a                	push   $0xa
  jmp alltraps
8010663f:	e9 d6 f8 ff ff       	jmp    80105f1a <alltraps>

80106644 <vector11>:
.globl vector11
vector11:
  pushl $11
80106644:	6a 0b                	push   $0xb
  jmp alltraps
80106646:	e9 cf f8 ff ff       	jmp    80105f1a <alltraps>

8010664b <vector12>:
.globl vector12
vector12:
  pushl $12
8010664b:	6a 0c                	push   $0xc
  jmp alltraps
8010664d:	e9 c8 f8 ff ff       	jmp    80105f1a <alltraps>

80106652 <vector13>:
.globl vector13
vector13:
  pushl $13
80106652:	6a 0d                	push   $0xd
  jmp alltraps
80106654:	e9 c1 f8 ff ff       	jmp    80105f1a <alltraps>

80106659 <vector14>:
.globl vector14
vector14:
  pushl $14
80106659:	6a 0e                	push   $0xe
  jmp alltraps
8010665b:	e9 ba f8 ff ff       	jmp    80105f1a <alltraps>

80106660 <vector15>:
.globl vector15
vector15:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $15
80106662:	6a 0f                	push   $0xf
  jmp alltraps
80106664:	e9 b1 f8 ff ff       	jmp    80105f1a <alltraps>

80106669 <vector16>:
.globl vector16
vector16:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $16
8010666b:	6a 10                	push   $0x10
  jmp alltraps
8010666d:	e9 a8 f8 ff ff       	jmp    80105f1a <alltraps>

80106672 <vector17>:
.globl vector17
vector17:
  pushl $17
80106672:	6a 11                	push   $0x11
  jmp alltraps
80106674:	e9 a1 f8 ff ff       	jmp    80105f1a <alltraps>

80106679 <vector18>:
.globl vector18
vector18:
  pushl $0
80106679:	6a 00                	push   $0x0
  pushl $18
8010667b:	6a 12                	push   $0x12
  jmp alltraps
8010667d:	e9 98 f8 ff ff       	jmp    80105f1a <alltraps>

80106682 <vector19>:
.globl vector19
vector19:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $19
80106684:	6a 13                	push   $0x13
  jmp alltraps
80106686:	e9 8f f8 ff ff       	jmp    80105f1a <alltraps>

8010668b <vector20>:
.globl vector20
vector20:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $20
8010668d:	6a 14                	push   $0x14
  jmp alltraps
8010668f:	e9 86 f8 ff ff       	jmp    80105f1a <alltraps>

80106694 <vector21>:
.globl vector21
vector21:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $21
80106696:	6a 15                	push   $0x15
  jmp alltraps
80106698:	e9 7d f8 ff ff       	jmp    80105f1a <alltraps>

8010669d <vector22>:
.globl vector22
vector22:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $22
8010669f:	6a 16                	push   $0x16
  jmp alltraps
801066a1:	e9 74 f8 ff ff       	jmp    80105f1a <alltraps>

801066a6 <vector23>:
.globl vector23
vector23:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $23
801066a8:	6a 17                	push   $0x17
  jmp alltraps
801066aa:	e9 6b f8 ff ff       	jmp    80105f1a <alltraps>

801066af <vector24>:
.globl vector24
vector24:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $24
801066b1:	6a 18                	push   $0x18
  jmp alltraps
801066b3:	e9 62 f8 ff ff       	jmp    80105f1a <alltraps>

801066b8 <vector25>:
.globl vector25
vector25:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $25
801066ba:	6a 19                	push   $0x19
  jmp alltraps
801066bc:	e9 59 f8 ff ff       	jmp    80105f1a <alltraps>

801066c1 <vector26>:
.globl vector26
vector26:
  pushl $0
801066c1:	6a 00                	push   $0x0
  pushl $26
801066c3:	6a 1a                	push   $0x1a
  jmp alltraps
801066c5:	e9 50 f8 ff ff       	jmp    80105f1a <alltraps>

801066ca <vector27>:
.globl vector27
vector27:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $27
801066cc:	6a 1b                	push   $0x1b
  jmp alltraps
801066ce:	e9 47 f8 ff ff       	jmp    80105f1a <alltraps>

801066d3 <vector28>:
.globl vector28
vector28:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $28
801066d5:	6a 1c                	push   $0x1c
  jmp alltraps
801066d7:	e9 3e f8 ff ff       	jmp    80105f1a <alltraps>

801066dc <vector29>:
.globl vector29
vector29:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $29
801066de:	6a 1d                	push   $0x1d
  jmp alltraps
801066e0:	e9 35 f8 ff ff       	jmp    80105f1a <alltraps>

801066e5 <vector30>:
.globl vector30
vector30:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $30
801066e7:	6a 1e                	push   $0x1e
  jmp alltraps
801066e9:	e9 2c f8 ff ff       	jmp    80105f1a <alltraps>

801066ee <vector31>:
.globl vector31
vector31:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $31
801066f0:	6a 1f                	push   $0x1f
  jmp alltraps
801066f2:	e9 23 f8 ff ff       	jmp    80105f1a <alltraps>

801066f7 <vector32>:
.globl vector32
vector32:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $32
801066f9:	6a 20                	push   $0x20
  jmp alltraps
801066fb:	e9 1a f8 ff ff       	jmp    80105f1a <alltraps>

80106700 <vector33>:
.globl vector33
vector33:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $33
80106702:	6a 21                	push   $0x21
  jmp alltraps
80106704:	e9 11 f8 ff ff       	jmp    80105f1a <alltraps>

80106709 <vector34>:
.globl vector34
vector34:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $34
8010670b:	6a 22                	push   $0x22
  jmp alltraps
8010670d:	e9 08 f8 ff ff       	jmp    80105f1a <alltraps>

80106712 <vector35>:
.globl vector35
vector35:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $35
80106714:	6a 23                	push   $0x23
  jmp alltraps
80106716:	e9 ff f7 ff ff       	jmp    80105f1a <alltraps>

8010671b <vector36>:
.globl vector36
vector36:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $36
8010671d:	6a 24                	push   $0x24
  jmp alltraps
8010671f:	e9 f6 f7 ff ff       	jmp    80105f1a <alltraps>

80106724 <vector37>:
.globl vector37
vector37:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $37
80106726:	6a 25                	push   $0x25
  jmp alltraps
80106728:	e9 ed f7 ff ff       	jmp    80105f1a <alltraps>

8010672d <vector38>:
.globl vector38
vector38:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $38
8010672f:	6a 26                	push   $0x26
  jmp alltraps
80106731:	e9 e4 f7 ff ff       	jmp    80105f1a <alltraps>

80106736 <vector39>:
.globl vector39
vector39:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $39
80106738:	6a 27                	push   $0x27
  jmp alltraps
8010673a:	e9 db f7 ff ff       	jmp    80105f1a <alltraps>

8010673f <vector40>:
.globl vector40
vector40:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $40
80106741:	6a 28                	push   $0x28
  jmp alltraps
80106743:	e9 d2 f7 ff ff       	jmp    80105f1a <alltraps>

80106748 <vector41>:
.globl vector41
vector41:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $41
8010674a:	6a 29                	push   $0x29
  jmp alltraps
8010674c:	e9 c9 f7 ff ff       	jmp    80105f1a <alltraps>

80106751 <vector42>:
.globl vector42
vector42:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $42
80106753:	6a 2a                	push   $0x2a
  jmp alltraps
80106755:	e9 c0 f7 ff ff       	jmp    80105f1a <alltraps>

8010675a <vector43>:
.globl vector43
vector43:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $43
8010675c:	6a 2b                	push   $0x2b
  jmp alltraps
8010675e:	e9 b7 f7 ff ff       	jmp    80105f1a <alltraps>

80106763 <vector44>:
.globl vector44
vector44:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $44
80106765:	6a 2c                	push   $0x2c
  jmp alltraps
80106767:	e9 ae f7 ff ff       	jmp    80105f1a <alltraps>

8010676c <vector45>:
.globl vector45
vector45:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $45
8010676e:	6a 2d                	push   $0x2d
  jmp alltraps
80106770:	e9 a5 f7 ff ff       	jmp    80105f1a <alltraps>

80106775 <vector46>:
.globl vector46
vector46:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $46
80106777:	6a 2e                	push   $0x2e
  jmp alltraps
80106779:	e9 9c f7 ff ff       	jmp    80105f1a <alltraps>

8010677e <vector47>:
.globl vector47
vector47:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $47
80106780:	6a 2f                	push   $0x2f
  jmp alltraps
80106782:	e9 93 f7 ff ff       	jmp    80105f1a <alltraps>

80106787 <vector48>:
.globl vector48
vector48:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $48
80106789:	6a 30                	push   $0x30
  jmp alltraps
8010678b:	e9 8a f7 ff ff       	jmp    80105f1a <alltraps>

80106790 <vector49>:
.globl vector49
vector49:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $49
80106792:	6a 31                	push   $0x31
  jmp alltraps
80106794:	e9 81 f7 ff ff       	jmp    80105f1a <alltraps>

80106799 <vector50>:
.globl vector50
vector50:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $50
8010679b:	6a 32                	push   $0x32
  jmp alltraps
8010679d:	e9 78 f7 ff ff       	jmp    80105f1a <alltraps>

801067a2 <vector51>:
.globl vector51
vector51:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $51
801067a4:	6a 33                	push   $0x33
  jmp alltraps
801067a6:	e9 6f f7 ff ff       	jmp    80105f1a <alltraps>

801067ab <vector52>:
.globl vector52
vector52:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $52
801067ad:	6a 34                	push   $0x34
  jmp alltraps
801067af:	e9 66 f7 ff ff       	jmp    80105f1a <alltraps>

801067b4 <vector53>:
.globl vector53
vector53:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $53
801067b6:	6a 35                	push   $0x35
  jmp alltraps
801067b8:	e9 5d f7 ff ff       	jmp    80105f1a <alltraps>

801067bd <vector54>:
.globl vector54
vector54:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $54
801067bf:	6a 36                	push   $0x36
  jmp alltraps
801067c1:	e9 54 f7 ff ff       	jmp    80105f1a <alltraps>

801067c6 <vector55>:
.globl vector55
vector55:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $55
801067c8:	6a 37                	push   $0x37
  jmp alltraps
801067ca:	e9 4b f7 ff ff       	jmp    80105f1a <alltraps>

801067cf <vector56>:
.globl vector56
vector56:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $56
801067d1:	6a 38                	push   $0x38
  jmp alltraps
801067d3:	e9 42 f7 ff ff       	jmp    80105f1a <alltraps>

801067d8 <vector57>:
.globl vector57
vector57:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $57
801067da:	6a 39                	push   $0x39
  jmp alltraps
801067dc:	e9 39 f7 ff ff       	jmp    80105f1a <alltraps>

801067e1 <vector58>:
.globl vector58
vector58:
  pushl $0
801067e1:	6a 00                	push   $0x0
  pushl $58
801067e3:	6a 3a                	push   $0x3a
  jmp alltraps
801067e5:	e9 30 f7 ff ff       	jmp    80105f1a <alltraps>

801067ea <vector59>:
.globl vector59
vector59:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $59
801067ec:	6a 3b                	push   $0x3b
  jmp alltraps
801067ee:	e9 27 f7 ff ff       	jmp    80105f1a <alltraps>

801067f3 <vector60>:
.globl vector60
vector60:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $60
801067f5:	6a 3c                	push   $0x3c
  jmp alltraps
801067f7:	e9 1e f7 ff ff       	jmp    80105f1a <alltraps>

801067fc <vector61>:
.globl vector61
vector61:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $61
801067fe:	6a 3d                	push   $0x3d
  jmp alltraps
80106800:	e9 15 f7 ff ff       	jmp    80105f1a <alltraps>

80106805 <vector62>:
.globl vector62
vector62:
  pushl $0
80106805:	6a 00                	push   $0x0
  pushl $62
80106807:	6a 3e                	push   $0x3e
  jmp alltraps
80106809:	e9 0c f7 ff ff       	jmp    80105f1a <alltraps>

8010680e <vector63>:
.globl vector63
vector63:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $63
80106810:	6a 3f                	push   $0x3f
  jmp alltraps
80106812:	e9 03 f7 ff ff       	jmp    80105f1a <alltraps>

80106817 <vector64>:
.globl vector64
vector64:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $64
80106819:	6a 40                	push   $0x40
  jmp alltraps
8010681b:	e9 fa f6 ff ff       	jmp    80105f1a <alltraps>

80106820 <vector65>:
.globl vector65
vector65:
  pushl $0
80106820:	6a 00                	push   $0x0
  pushl $65
80106822:	6a 41                	push   $0x41
  jmp alltraps
80106824:	e9 f1 f6 ff ff       	jmp    80105f1a <alltraps>

80106829 <vector66>:
.globl vector66
vector66:
  pushl $0
80106829:	6a 00                	push   $0x0
  pushl $66
8010682b:	6a 42                	push   $0x42
  jmp alltraps
8010682d:	e9 e8 f6 ff ff       	jmp    80105f1a <alltraps>

80106832 <vector67>:
.globl vector67
vector67:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $67
80106834:	6a 43                	push   $0x43
  jmp alltraps
80106836:	e9 df f6 ff ff       	jmp    80105f1a <alltraps>

8010683b <vector68>:
.globl vector68
vector68:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $68
8010683d:	6a 44                	push   $0x44
  jmp alltraps
8010683f:	e9 d6 f6 ff ff       	jmp    80105f1a <alltraps>

80106844 <vector69>:
.globl vector69
vector69:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $69
80106846:	6a 45                	push   $0x45
  jmp alltraps
80106848:	e9 cd f6 ff ff       	jmp    80105f1a <alltraps>

8010684d <vector70>:
.globl vector70
vector70:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $70
8010684f:	6a 46                	push   $0x46
  jmp alltraps
80106851:	e9 c4 f6 ff ff       	jmp    80105f1a <alltraps>

80106856 <vector71>:
.globl vector71
vector71:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $71
80106858:	6a 47                	push   $0x47
  jmp alltraps
8010685a:	e9 bb f6 ff ff       	jmp    80105f1a <alltraps>

8010685f <vector72>:
.globl vector72
vector72:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $72
80106861:	6a 48                	push   $0x48
  jmp alltraps
80106863:	e9 b2 f6 ff ff       	jmp    80105f1a <alltraps>

80106868 <vector73>:
.globl vector73
vector73:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $73
8010686a:	6a 49                	push   $0x49
  jmp alltraps
8010686c:	e9 a9 f6 ff ff       	jmp    80105f1a <alltraps>

80106871 <vector74>:
.globl vector74
vector74:
  pushl $0
80106871:	6a 00                	push   $0x0
  pushl $74
80106873:	6a 4a                	push   $0x4a
  jmp alltraps
80106875:	e9 a0 f6 ff ff       	jmp    80105f1a <alltraps>

8010687a <vector75>:
.globl vector75
vector75:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $75
8010687c:	6a 4b                	push   $0x4b
  jmp alltraps
8010687e:	e9 97 f6 ff ff       	jmp    80105f1a <alltraps>

80106883 <vector76>:
.globl vector76
vector76:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $76
80106885:	6a 4c                	push   $0x4c
  jmp alltraps
80106887:	e9 8e f6 ff ff       	jmp    80105f1a <alltraps>

8010688c <vector77>:
.globl vector77
vector77:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $77
8010688e:	6a 4d                	push   $0x4d
  jmp alltraps
80106890:	e9 85 f6 ff ff       	jmp    80105f1a <alltraps>

80106895 <vector78>:
.globl vector78
vector78:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $78
80106897:	6a 4e                	push   $0x4e
  jmp alltraps
80106899:	e9 7c f6 ff ff       	jmp    80105f1a <alltraps>

8010689e <vector79>:
.globl vector79
vector79:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $79
801068a0:	6a 4f                	push   $0x4f
  jmp alltraps
801068a2:	e9 73 f6 ff ff       	jmp    80105f1a <alltraps>

801068a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $80
801068a9:	6a 50                	push   $0x50
  jmp alltraps
801068ab:	e9 6a f6 ff ff       	jmp    80105f1a <alltraps>

801068b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $81
801068b2:	6a 51                	push   $0x51
  jmp alltraps
801068b4:	e9 61 f6 ff ff       	jmp    80105f1a <alltraps>

801068b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $82
801068bb:	6a 52                	push   $0x52
  jmp alltraps
801068bd:	e9 58 f6 ff ff       	jmp    80105f1a <alltraps>

801068c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $83
801068c4:	6a 53                	push   $0x53
  jmp alltraps
801068c6:	e9 4f f6 ff ff       	jmp    80105f1a <alltraps>

801068cb <vector84>:
.globl vector84
vector84:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $84
801068cd:	6a 54                	push   $0x54
  jmp alltraps
801068cf:	e9 46 f6 ff ff       	jmp    80105f1a <alltraps>

801068d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $85
801068d6:	6a 55                	push   $0x55
  jmp alltraps
801068d8:	e9 3d f6 ff ff       	jmp    80105f1a <alltraps>

801068dd <vector86>:
.globl vector86
vector86:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $86
801068df:	6a 56                	push   $0x56
  jmp alltraps
801068e1:	e9 34 f6 ff ff       	jmp    80105f1a <alltraps>

801068e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $87
801068e8:	6a 57                	push   $0x57
  jmp alltraps
801068ea:	e9 2b f6 ff ff       	jmp    80105f1a <alltraps>

801068ef <vector88>:
.globl vector88
vector88:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $88
801068f1:	6a 58                	push   $0x58
  jmp alltraps
801068f3:	e9 22 f6 ff ff       	jmp    80105f1a <alltraps>

801068f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $89
801068fa:	6a 59                	push   $0x59
  jmp alltraps
801068fc:	e9 19 f6 ff ff       	jmp    80105f1a <alltraps>

80106901 <vector90>:
.globl vector90
vector90:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $90
80106903:	6a 5a                	push   $0x5a
  jmp alltraps
80106905:	e9 10 f6 ff ff       	jmp    80105f1a <alltraps>

8010690a <vector91>:
.globl vector91
vector91:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $91
8010690c:	6a 5b                	push   $0x5b
  jmp alltraps
8010690e:	e9 07 f6 ff ff       	jmp    80105f1a <alltraps>

80106913 <vector92>:
.globl vector92
vector92:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $92
80106915:	6a 5c                	push   $0x5c
  jmp alltraps
80106917:	e9 fe f5 ff ff       	jmp    80105f1a <alltraps>

8010691c <vector93>:
.globl vector93
vector93:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $93
8010691e:	6a 5d                	push   $0x5d
  jmp alltraps
80106920:	e9 f5 f5 ff ff       	jmp    80105f1a <alltraps>

80106925 <vector94>:
.globl vector94
vector94:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $94
80106927:	6a 5e                	push   $0x5e
  jmp alltraps
80106929:	e9 ec f5 ff ff       	jmp    80105f1a <alltraps>

8010692e <vector95>:
.globl vector95
vector95:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $95
80106930:	6a 5f                	push   $0x5f
  jmp alltraps
80106932:	e9 e3 f5 ff ff       	jmp    80105f1a <alltraps>

80106937 <vector96>:
.globl vector96
vector96:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $96
80106939:	6a 60                	push   $0x60
  jmp alltraps
8010693b:	e9 da f5 ff ff       	jmp    80105f1a <alltraps>

80106940 <vector97>:
.globl vector97
vector97:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $97
80106942:	6a 61                	push   $0x61
  jmp alltraps
80106944:	e9 d1 f5 ff ff       	jmp    80105f1a <alltraps>

80106949 <vector98>:
.globl vector98
vector98:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $98
8010694b:	6a 62                	push   $0x62
  jmp alltraps
8010694d:	e9 c8 f5 ff ff       	jmp    80105f1a <alltraps>

80106952 <vector99>:
.globl vector99
vector99:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $99
80106954:	6a 63                	push   $0x63
  jmp alltraps
80106956:	e9 bf f5 ff ff       	jmp    80105f1a <alltraps>

8010695b <vector100>:
.globl vector100
vector100:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $100
8010695d:	6a 64                	push   $0x64
  jmp alltraps
8010695f:	e9 b6 f5 ff ff       	jmp    80105f1a <alltraps>

80106964 <vector101>:
.globl vector101
vector101:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $101
80106966:	6a 65                	push   $0x65
  jmp alltraps
80106968:	e9 ad f5 ff ff       	jmp    80105f1a <alltraps>

8010696d <vector102>:
.globl vector102
vector102:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $102
8010696f:	6a 66                	push   $0x66
  jmp alltraps
80106971:	e9 a4 f5 ff ff       	jmp    80105f1a <alltraps>

80106976 <vector103>:
.globl vector103
vector103:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $103
80106978:	6a 67                	push   $0x67
  jmp alltraps
8010697a:	e9 9b f5 ff ff       	jmp    80105f1a <alltraps>

8010697f <vector104>:
.globl vector104
vector104:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $104
80106981:	6a 68                	push   $0x68
  jmp alltraps
80106983:	e9 92 f5 ff ff       	jmp    80105f1a <alltraps>

80106988 <vector105>:
.globl vector105
vector105:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $105
8010698a:	6a 69                	push   $0x69
  jmp alltraps
8010698c:	e9 89 f5 ff ff       	jmp    80105f1a <alltraps>

80106991 <vector106>:
.globl vector106
vector106:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $106
80106993:	6a 6a                	push   $0x6a
  jmp alltraps
80106995:	e9 80 f5 ff ff       	jmp    80105f1a <alltraps>

8010699a <vector107>:
.globl vector107
vector107:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $107
8010699c:	6a 6b                	push   $0x6b
  jmp alltraps
8010699e:	e9 77 f5 ff ff       	jmp    80105f1a <alltraps>

801069a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $108
801069a5:	6a 6c                	push   $0x6c
  jmp alltraps
801069a7:	e9 6e f5 ff ff       	jmp    80105f1a <alltraps>

801069ac <vector109>:
.globl vector109
vector109:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $109
801069ae:	6a 6d                	push   $0x6d
  jmp alltraps
801069b0:	e9 65 f5 ff ff       	jmp    80105f1a <alltraps>

801069b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $110
801069b7:	6a 6e                	push   $0x6e
  jmp alltraps
801069b9:	e9 5c f5 ff ff       	jmp    80105f1a <alltraps>

801069be <vector111>:
.globl vector111
vector111:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $111
801069c0:	6a 6f                	push   $0x6f
  jmp alltraps
801069c2:	e9 53 f5 ff ff       	jmp    80105f1a <alltraps>

801069c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $112
801069c9:	6a 70                	push   $0x70
  jmp alltraps
801069cb:	e9 4a f5 ff ff       	jmp    80105f1a <alltraps>

801069d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $113
801069d2:	6a 71                	push   $0x71
  jmp alltraps
801069d4:	e9 41 f5 ff ff       	jmp    80105f1a <alltraps>

801069d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $114
801069db:	6a 72                	push   $0x72
  jmp alltraps
801069dd:	e9 38 f5 ff ff       	jmp    80105f1a <alltraps>

801069e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $115
801069e4:	6a 73                	push   $0x73
  jmp alltraps
801069e6:	e9 2f f5 ff ff       	jmp    80105f1a <alltraps>

801069eb <vector116>:
.globl vector116
vector116:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $116
801069ed:	6a 74                	push   $0x74
  jmp alltraps
801069ef:	e9 26 f5 ff ff       	jmp    80105f1a <alltraps>

801069f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $117
801069f6:	6a 75                	push   $0x75
  jmp alltraps
801069f8:	e9 1d f5 ff ff       	jmp    80105f1a <alltraps>

801069fd <vector118>:
.globl vector118
vector118:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $118
801069ff:	6a 76                	push   $0x76
  jmp alltraps
80106a01:	e9 14 f5 ff ff       	jmp    80105f1a <alltraps>

80106a06 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $119
80106a08:	6a 77                	push   $0x77
  jmp alltraps
80106a0a:	e9 0b f5 ff ff       	jmp    80105f1a <alltraps>

80106a0f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $120
80106a11:	6a 78                	push   $0x78
  jmp alltraps
80106a13:	e9 02 f5 ff ff       	jmp    80105f1a <alltraps>

80106a18 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $121
80106a1a:	6a 79                	push   $0x79
  jmp alltraps
80106a1c:	e9 f9 f4 ff ff       	jmp    80105f1a <alltraps>

80106a21 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $122
80106a23:	6a 7a                	push   $0x7a
  jmp alltraps
80106a25:	e9 f0 f4 ff ff       	jmp    80105f1a <alltraps>

80106a2a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $123
80106a2c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a2e:	e9 e7 f4 ff ff       	jmp    80105f1a <alltraps>

80106a33 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $124
80106a35:	6a 7c                	push   $0x7c
  jmp alltraps
80106a37:	e9 de f4 ff ff       	jmp    80105f1a <alltraps>

80106a3c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $125
80106a3e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a40:	e9 d5 f4 ff ff       	jmp    80105f1a <alltraps>

80106a45 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $126
80106a47:	6a 7e                	push   $0x7e
  jmp alltraps
80106a49:	e9 cc f4 ff ff       	jmp    80105f1a <alltraps>

80106a4e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $127
80106a50:	6a 7f                	push   $0x7f
  jmp alltraps
80106a52:	e9 c3 f4 ff ff       	jmp    80105f1a <alltraps>

80106a57 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $128
80106a59:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a5e:	e9 b7 f4 ff ff       	jmp    80105f1a <alltraps>

80106a63 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $129
80106a65:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a6a:	e9 ab f4 ff ff       	jmp    80105f1a <alltraps>

80106a6f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $130
80106a71:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a76:	e9 9f f4 ff ff       	jmp    80105f1a <alltraps>

80106a7b <vector131>:
.globl vector131
vector131:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $131
80106a7d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a82:	e9 93 f4 ff ff       	jmp    80105f1a <alltraps>

80106a87 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $132
80106a89:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a8e:	e9 87 f4 ff ff       	jmp    80105f1a <alltraps>

80106a93 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $133
80106a95:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a9a:	e9 7b f4 ff ff       	jmp    80105f1a <alltraps>

80106a9f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $134
80106aa1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106aa6:	e9 6f f4 ff ff       	jmp    80105f1a <alltraps>

80106aab <vector135>:
.globl vector135
vector135:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $135
80106aad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ab2:	e9 63 f4 ff ff       	jmp    80105f1a <alltraps>

80106ab7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $136
80106ab9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106abe:	e9 57 f4 ff ff       	jmp    80105f1a <alltraps>

80106ac3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $137
80106ac5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106aca:	e9 4b f4 ff ff       	jmp    80105f1a <alltraps>

80106acf <vector138>:
.globl vector138
vector138:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $138
80106ad1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ad6:	e9 3f f4 ff ff       	jmp    80105f1a <alltraps>

80106adb <vector139>:
.globl vector139
vector139:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $139
80106add:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ae2:	e9 33 f4 ff ff       	jmp    80105f1a <alltraps>

80106ae7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $140
80106ae9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106aee:	e9 27 f4 ff ff       	jmp    80105f1a <alltraps>

80106af3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $141
80106af5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106afa:	e9 1b f4 ff ff       	jmp    80105f1a <alltraps>

80106aff <vector142>:
.globl vector142
vector142:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $142
80106b01:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b06:	e9 0f f4 ff ff       	jmp    80105f1a <alltraps>

80106b0b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $143
80106b0d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b12:	e9 03 f4 ff ff       	jmp    80105f1a <alltraps>

80106b17 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $144
80106b19:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b1e:	e9 f7 f3 ff ff       	jmp    80105f1a <alltraps>

80106b23 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $145
80106b25:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b2a:	e9 eb f3 ff ff       	jmp    80105f1a <alltraps>

80106b2f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $146
80106b31:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b36:	e9 df f3 ff ff       	jmp    80105f1a <alltraps>

80106b3b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $147
80106b3d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b42:	e9 d3 f3 ff ff       	jmp    80105f1a <alltraps>

80106b47 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $148
80106b49:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b4e:	e9 c7 f3 ff ff       	jmp    80105f1a <alltraps>

80106b53 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $149
80106b55:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b5a:	e9 bb f3 ff ff       	jmp    80105f1a <alltraps>

80106b5f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $150
80106b61:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b66:	e9 af f3 ff ff       	jmp    80105f1a <alltraps>

80106b6b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $151
80106b6d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b72:	e9 a3 f3 ff ff       	jmp    80105f1a <alltraps>

80106b77 <vector152>:
.globl vector152
vector152:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $152
80106b79:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b7e:	e9 97 f3 ff ff       	jmp    80105f1a <alltraps>

80106b83 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $153
80106b85:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b8a:	e9 8b f3 ff ff       	jmp    80105f1a <alltraps>

80106b8f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $154
80106b91:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b96:	e9 7f f3 ff ff       	jmp    80105f1a <alltraps>

80106b9b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $155
80106b9d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ba2:	e9 73 f3 ff ff       	jmp    80105f1a <alltraps>

80106ba7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $156
80106ba9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bae:	e9 67 f3 ff ff       	jmp    80105f1a <alltraps>

80106bb3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $157
80106bb5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bba:	e9 5b f3 ff ff       	jmp    80105f1a <alltraps>

80106bbf <vector158>:
.globl vector158
vector158:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $158
80106bc1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bc6:	e9 4f f3 ff ff       	jmp    80105f1a <alltraps>

80106bcb <vector159>:
.globl vector159
vector159:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $159
80106bcd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bd2:	e9 43 f3 ff ff       	jmp    80105f1a <alltraps>

80106bd7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $160
80106bd9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bde:	e9 37 f3 ff ff       	jmp    80105f1a <alltraps>

80106be3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $161
80106be5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bea:	e9 2b f3 ff ff       	jmp    80105f1a <alltraps>

80106bef <vector162>:
.globl vector162
vector162:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $162
80106bf1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106bf6:	e9 1f f3 ff ff       	jmp    80105f1a <alltraps>

80106bfb <vector163>:
.globl vector163
vector163:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $163
80106bfd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c02:	e9 13 f3 ff ff       	jmp    80105f1a <alltraps>

80106c07 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $164
80106c09:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c0e:	e9 07 f3 ff ff       	jmp    80105f1a <alltraps>

80106c13 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $165
80106c15:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c1a:	e9 fb f2 ff ff       	jmp    80105f1a <alltraps>

80106c1f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $166
80106c21:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c26:	e9 ef f2 ff ff       	jmp    80105f1a <alltraps>

80106c2b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $167
80106c2d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c32:	e9 e3 f2 ff ff       	jmp    80105f1a <alltraps>

80106c37 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $168
80106c39:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c3e:	e9 d7 f2 ff ff       	jmp    80105f1a <alltraps>

80106c43 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $169
80106c45:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c4a:	e9 cb f2 ff ff       	jmp    80105f1a <alltraps>

80106c4f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $170
80106c51:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c56:	e9 bf f2 ff ff       	jmp    80105f1a <alltraps>

80106c5b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $171
80106c5d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c62:	e9 b3 f2 ff ff       	jmp    80105f1a <alltraps>

80106c67 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $172
80106c69:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c6e:	e9 a7 f2 ff ff       	jmp    80105f1a <alltraps>

80106c73 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $173
80106c75:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c7a:	e9 9b f2 ff ff       	jmp    80105f1a <alltraps>

80106c7f <vector174>:
.globl vector174
vector174:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $174
80106c81:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c86:	e9 8f f2 ff ff       	jmp    80105f1a <alltraps>

80106c8b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $175
80106c8d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c92:	e9 83 f2 ff ff       	jmp    80105f1a <alltraps>

80106c97 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $176
80106c99:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c9e:	e9 77 f2 ff ff       	jmp    80105f1a <alltraps>

80106ca3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $177
80106ca5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106caa:	e9 6b f2 ff ff       	jmp    80105f1a <alltraps>

80106caf <vector178>:
.globl vector178
vector178:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $178
80106cb1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cb6:	e9 5f f2 ff ff       	jmp    80105f1a <alltraps>

80106cbb <vector179>:
.globl vector179
vector179:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $179
80106cbd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106cc2:	e9 53 f2 ff ff       	jmp    80105f1a <alltraps>

80106cc7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $180
80106cc9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cce:	e9 47 f2 ff ff       	jmp    80105f1a <alltraps>

80106cd3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $181
80106cd5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cda:	e9 3b f2 ff ff       	jmp    80105f1a <alltraps>

80106cdf <vector182>:
.globl vector182
vector182:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $182
80106ce1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ce6:	e9 2f f2 ff ff       	jmp    80105f1a <alltraps>

80106ceb <vector183>:
.globl vector183
vector183:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $183
80106ced:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106cf2:	e9 23 f2 ff ff       	jmp    80105f1a <alltraps>

80106cf7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $184
80106cf9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106cfe:	e9 17 f2 ff ff       	jmp    80105f1a <alltraps>

80106d03 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $185
80106d05:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d0a:	e9 0b f2 ff ff       	jmp    80105f1a <alltraps>

80106d0f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $186
80106d11:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d16:	e9 ff f1 ff ff       	jmp    80105f1a <alltraps>

80106d1b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $187
80106d1d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d22:	e9 f3 f1 ff ff       	jmp    80105f1a <alltraps>

80106d27 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $188
80106d29:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d2e:	e9 e7 f1 ff ff       	jmp    80105f1a <alltraps>

80106d33 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $189
80106d35:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d3a:	e9 db f1 ff ff       	jmp    80105f1a <alltraps>

80106d3f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $190
80106d41:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d46:	e9 cf f1 ff ff       	jmp    80105f1a <alltraps>

80106d4b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $191
80106d4d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d52:	e9 c3 f1 ff ff       	jmp    80105f1a <alltraps>

80106d57 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $192
80106d59:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d5e:	e9 b7 f1 ff ff       	jmp    80105f1a <alltraps>

80106d63 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $193
80106d65:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d6a:	e9 ab f1 ff ff       	jmp    80105f1a <alltraps>

80106d6f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $194
80106d71:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d76:	e9 9f f1 ff ff       	jmp    80105f1a <alltraps>

80106d7b <vector195>:
.globl vector195
vector195:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $195
80106d7d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d82:	e9 93 f1 ff ff       	jmp    80105f1a <alltraps>

80106d87 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $196
80106d89:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d8e:	e9 87 f1 ff ff       	jmp    80105f1a <alltraps>

80106d93 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $197
80106d95:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d9a:	e9 7b f1 ff ff       	jmp    80105f1a <alltraps>

80106d9f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $198
80106da1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106da6:	e9 6f f1 ff ff       	jmp    80105f1a <alltraps>

80106dab <vector199>:
.globl vector199
vector199:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $199
80106dad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106db2:	e9 63 f1 ff ff       	jmp    80105f1a <alltraps>

80106db7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $200
80106db9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dbe:	e9 57 f1 ff ff       	jmp    80105f1a <alltraps>

80106dc3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $201
80106dc5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dca:	e9 4b f1 ff ff       	jmp    80105f1a <alltraps>

80106dcf <vector202>:
.globl vector202
vector202:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $202
80106dd1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dd6:	e9 3f f1 ff ff       	jmp    80105f1a <alltraps>

80106ddb <vector203>:
.globl vector203
vector203:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $203
80106ddd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106de2:	e9 33 f1 ff ff       	jmp    80105f1a <alltraps>

80106de7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $204
80106de9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106dee:	e9 27 f1 ff ff       	jmp    80105f1a <alltraps>

80106df3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $205
80106df5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106dfa:	e9 1b f1 ff ff       	jmp    80105f1a <alltraps>

80106dff <vector206>:
.globl vector206
vector206:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $206
80106e01:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e06:	e9 0f f1 ff ff       	jmp    80105f1a <alltraps>

80106e0b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $207
80106e0d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e12:	e9 03 f1 ff ff       	jmp    80105f1a <alltraps>

80106e17 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $208
80106e19:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e1e:	e9 f7 f0 ff ff       	jmp    80105f1a <alltraps>

80106e23 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $209
80106e25:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e2a:	e9 eb f0 ff ff       	jmp    80105f1a <alltraps>

80106e2f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $210
80106e31:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e36:	e9 df f0 ff ff       	jmp    80105f1a <alltraps>

80106e3b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $211
80106e3d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e42:	e9 d3 f0 ff ff       	jmp    80105f1a <alltraps>

80106e47 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $212
80106e49:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e4e:	e9 c7 f0 ff ff       	jmp    80105f1a <alltraps>

80106e53 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $213
80106e55:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e5a:	e9 bb f0 ff ff       	jmp    80105f1a <alltraps>

80106e5f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $214
80106e61:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e66:	e9 af f0 ff ff       	jmp    80105f1a <alltraps>

80106e6b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $215
80106e6d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e72:	e9 a3 f0 ff ff       	jmp    80105f1a <alltraps>

80106e77 <vector216>:
.globl vector216
vector216:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $216
80106e79:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e7e:	e9 97 f0 ff ff       	jmp    80105f1a <alltraps>

80106e83 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $217
80106e85:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e8a:	e9 8b f0 ff ff       	jmp    80105f1a <alltraps>

80106e8f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $218
80106e91:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e96:	e9 7f f0 ff ff       	jmp    80105f1a <alltraps>

80106e9b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $219
80106e9d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ea2:	e9 73 f0 ff ff       	jmp    80105f1a <alltraps>

80106ea7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $220
80106ea9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106eae:	e9 67 f0 ff ff       	jmp    80105f1a <alltraps>

80106eb3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $221
80106eb5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106eba:	e9 5b f0 ff ff       	jmp    80105f1a <alltraps>

80106ebf <vector222>:
.globl vector222
vector222:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $222
80106ec1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ec6:	e9 4f f0 ff ff       	jmp    80105f1a <alltraps>

80106ecb <vector223>:
.globl vector223
vector223:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $223
80106ecd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ed2:	e9 43 f0 ff ff       	jmp    80105f1a <alltraps>

80106ed7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $224
80106ed9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ede:	e9 37 f0 ff ff       	jmp    80105f1a <alltraps>

80106ee3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $225
80106ee5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106eea:	e9 2b f0 ff ff       	jmp    80105f1a <alltraps>

80106eef <vector226>:
.globl vector226
vector226:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $226
80106ef1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ef6:	e9 1f f0 ff ff       	jmp    80105f1a <alltraps>

80106efb <vector227>:
.globl vector227
vector227:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $227
80106efd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f02:	e9 13 f0 ff ff       	jmp    80105f1a <alltraps>

80106f07 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $228
80106f09:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f0e:	e9 07 f0 ff ff       	jmp    80105f1a <alltraps>

80106f13 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $229
80106f15:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f1a:	e9 fb ef ff ff       	jmp    80105f1a <alltraps>

80106f1f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $230
80106f21:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f26:	e9 ef ef ff ff       	jmp    80105f1a <alltraps>

80106f2b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $231
80106f2d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f32:	e9 e3 ef ff ff       	jmp    80105f1a <alltraps>

80106f37 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $232
80106f39:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f3e:	e9 d7 ef ff ff       	jmp    80105f1a <alltraps>

80106f43 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $233
80106f45:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f4a:	e9 cb ef ff ff       	jmp    80105f1a <alltraps>

80106f4f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $234
80106f51:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f56:	e9 bf ef ff ff       	jmp    80105f1a <alltraps>

80106f5b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $235
80106f5d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f62:	e9 b3 ef ff ff       	jmp    80105f1a <alltraps>

80106f67 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $236
80106f69:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f6e:	e9 a7 ef ff ff       	jmp    80105f1a <alltraps>

80106f73 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $237
80106f75:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f7a:	e9 9b ef ff ff       	jmp    80105f1a <alltraps>

80106f7f <vector238>:
.globl vector238
vector238:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $238
80106f81:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f86:	e9 8f ef ff ff       	jmp    80105f1a <alltraps>

80106f8b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $239
80106f8d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f92:	e9 83 ef ff ff       	jmp    80105f1a <alltraps>

80106f97 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $240
80106f99:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f9e:	e9 77 ef ff ff       	jmp    80105f1a <alltraps>

80106fa3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $241
80106fa5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106faa:	e9 6b ef ff ff       	jmp    80105f1a <alltraps>

80106faf <vector242>:
.globl vector242
vector242:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $242
80106fb1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fb6:	e9 5f ef ff ff       	jmp    80105f1a <alltraps>

80106fbb <vector243>:
.globl vector243
vector243:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $243
80106fbd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fc2:	e9 53 ef ff ff       	jmp    80105f1a <alltraps>

80106fc7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $244
80106fc9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fce:	e9 47 ef ff ff       	jmp    80105f1a <alltraps>

80106fd3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $245
80106fd5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fda:	e9 3b ef ff ff       	jmp    80105f1a <alltraps>

80106fdf <vector246>:
.globl vector246
vector246:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $246
80106fe1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106fe6:	e9 2f ef ff ff       	jmp    80105f1a <alltraps>

80106feb <vector247>:
.globl vector247
vector247:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $247
80106fed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ff2:	e9 23 ef ff ff       	jmp    80105f1a <alltraps>

80106ff7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $248
80106ff9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106ffe:	e9 17 ef ff ff       	jmp    80105f1a <alltraps>

80107003 <vector249>:
.globl vector249
vector249:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $249
80107005:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010700a:	e9 0b ef ff ff       	jmp    80105f1a <alltraps>

8010700f <vector250>:
.globl vector250
vector250:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $250
80107011:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107016:	e9 ff ee ff ff       	jmp    80105f1a <alltraps>

8010701b <vector251>:
.globl vector251
vector251:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $251
8010701d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107022:	e9 f3 ee ff ff       	jmp    80105f1a <alltraps>

80107027 <vector252>:
.globl vector252
vector252:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $252
80107029:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010702e:	e9 e7 ee ff ff       	jmp    80105f1a <alltraps>

80107033 <vector253>:
.globl vector253
vector253:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $253
80107035:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010703a:	e9 db ee ff ff       	jmp    80105f1a <alltraps>

8010703f <vector254>:
.globl vector254
vector254:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $254
80107041:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107046:	e9 cf ee ff ff       	jmp    80105f1a <alltraps>

8010704b <vector255>:
.globl vector255
vector255:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $255
8010704d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107052:	e9 c3 ee ff ff       	jmp    80105f1a <alltraps>
80107057:	66 90                	xchg   %ax,%ax
80107059:	66 90                	xchg   %ax,%ax
8010705b:	66 90                	xchg   %ax,%ax
8010705d:	66 90                	xchg   %ax,%ax
8010705f:	90                   	nop

80107060 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107066:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010706c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107072:	83 ec 1c             	sub    $0x1c,%esp
80107075:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107078:	39 d3                	cmp    %edx,%ebx
8010707a:	73 49                	jae    801070c5 <deallocuvm.part.0+0x65>
8010707c:	89 c7                	mov    %eax,%edi
8010707e:	eb 0c                	jmp    8010708c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107080:	83 c0 01             	add    $0x1,%eax
80107083:	c1 e0 16             	shl    $0x16,%eax
80107086:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107088:	39 da                	cmp    %ebx,%edx
8010708a:	76 39                	jbe    801070c5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010708c:	89 d8                	mov    %ebx,%eax
8010708e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107091:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107094:	f6 c1 01             	test   $0x1,%cl
80107097:	74 e7                	je     80107080 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107099:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010709b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801070a1:	c1 ee 0a             	shr    $0xa,%esi
801070a4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801070aa:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801070b1:	85 f6                	test   %esi,%esi
801070b3:	74 cb                	je     80107080 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801070b5:	8b 06                	mov    (%esi),%eax
801070b7:	a8 01                	test   $0x1,%al
801070b9:	75 15                	jne    801070d0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801070bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070c1:	39 da                	cmp    %ebx,%edx
801070c3:	77 c7                	ja     8010708c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801070c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070cb:	5b                   	pop    %ebx
801070cc:	5e                   	pop    %esi
801070cd:	5f                   	pop    %edi
801070ce:	5d                   	pop    %ebp
801070cf:	c3                   	ret    
      if(pa == 0)
801070d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070d5:	74 25                	je     801070fc <deallocuvm.part.0+0x9c>
      kfree(v);
801070d7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801070da:	05 00 00 00 80       	add    $0x80000000,%eax
801070df:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801070e2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801070e8:	50                   	push   %eax
801070e9:	e8 f2 b3 ff ff       	call   801024e0 <kfree>
      *pte = 0;
801070ee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801070f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070f7:	83 c4 10             	add    $0x10,%esp
801070fa:	eb 8c                	jmp    80107088 <deallocuvm.part.0+0x28>
        panic("kfree");
801070fc:	83 ec 0c             	sub    $0xc,%esp
801070ff:	68 66 81 10 80       	push   $0x80108166
80107104:	e8 77 92 ff ff       	call   80100380 <panic>
80107109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107110 <seginit>:
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107116:	e8 65 c8 ff ff       	call   80103980 <cpuid>
  pd[0] = size-1;
8010711b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107120:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107126:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010712a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107131:	ff 00 00 
80107134:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010713b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010713e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107145:	ff 00 00 
80107148:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010714f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107152:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107159:	ff 00 00 
8010715c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107163:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107166:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010716d:	ff 00 00 
80107170:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107177:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010717a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
8010717f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107183:	c1 e8 10             	shr    $0x10,%eax
80107186:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010718a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010718d:	0f 01 10             	lgdtl  (%eax)
}
80107190:	c9                   	leave  
80107191:	c3                   	ret    
80107192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071a0 <walkpgdir>:
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 0c             	sub    $0xc,%esp
801071a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
801071ac:	8b 55 08             	mov    0x8(%ebp),%edx
801071af:	89 fe                	mov    %edi,%esi
801071b1:	c1 ee 16             	shr    $0x16,%esi
801071b4:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
801071b7:	8b 1e                	mov    (%esi),%ebx
801071b9:	f6 c3 01             	test   $0x1,%bl
801071bc:	74 22                	je     801071e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801071c4:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
801071ca:	89 f8                	mov    %edi,%eax
}
801071cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801071cf:	c1 e8 0a             	shr    $0xa,%eax
801071d2:	25 fc 0f 00 00       	and    $0xffc,%eax
801071d7:	01 d8                	add    %ebx,%eax
}
801071d9:	5b                   	pop    %ebx
801071da:	5e                   	pop    %esi
801071db:	5f                   	pop    %edi
801071dc:	5d                   	pop    %ebp
801071dd:	c3                   	ret    
801071de:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801071e0:	8b 45 10             	mov    0x10(%ebp),%eax
801071e3:	85 c0                	test   %eax,%eax
801071e5:	74 31                	je     80107218 <walkpgdir+0x78>
801071e7:	e8 b4 b4 ff ff       	call   801026a0 <kalloc>
801071ec:	89 c3                	mov    %eax,%ebx
801071ee:	85 c0                	test   %eax,%eax
801071f0:	74 26                	je     80107218 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
801071f2:	83 ec 04             	sub    $0x4,%esp
801071f5:	68 00 10 00 00       	push   $0x1000
801071fa:	6a 00                	push   $0x0
801071fc:	50                   	push   %eax
801071fd:	e8 2e d6 ff ff       	call   80104830 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107202:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107208:	83 c4 10             	add    $0x10,%esp
8010720b:	83 c8 07             	or     $0x7,%eax
8010720e:	89 06                	mov    %eax,(%esi)
80107210:	eb b8                	jmp    801071ca <walkpgdir+0x2a>
80107212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80107218:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
8010721b:	31 c0                	xor    %eax,%eax
}
8010721d:	5b                   	pop    %ebx
8010721e:	5e                   	pop    %esi
8010721f:	5f                   	pop    %edi
80107220:	5d                   	pop    %ebp
80107221:	c3                   	ret    
80107222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107230 <mappages>:
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	53                   	push   %ebx
80107236:	83 ec 1c             	sub    $0x1c,%esp
80107239:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010723c:	8b 55 10             	mov    0x10(%ebp),%edx
  a = (char*)PGROUNDDOWN((uint)va);
8010723f:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107241:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80107245:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
8010724a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107250:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107253:	8b 45 14             	mov    0x14(%ebp),%eax
80107256:	29 d8                	sub    %ebx,%eax
80107258:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010725b:	eb 3a                	jmp    80107297 <mappages+0x67>
8010725d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107260:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107262:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107267:	c1 ea 0a             	shr    $0xa,%edx
8010726a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107270:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107277:	85 c0                	test   %eax,%eax
80107279:	74 75                	je     801072f0 <mappages+0xc0>
    if(*pte & PTE_P)
8010727b:	f6 00 01             	testb  $0x1,(%eax)
8010727e:	0f 85 86 00 00 00    	jne    8010730a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107284:	0b 75 18             	or     0x18(%ebp),%esi
80107287:	83 ce 01             	or     $0x1,%esi
8010728a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010728c:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
8010728f:	74 6f                	je     80107300 <mappages+0xd0>
    a += PGSIZE;
80107291:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010729a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010729d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801072a0:	89 d8                	mov    %ebx,%eax
801072a2:	c1 e8 16             	shr    $0x16,%eax
801072a5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801072a8:	8b 07                	mov    (%edi),%eax
801072aa:	a8 01                	test   $0x1,%al
801072ac:	75 b2                	jne    80107260 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801072ae:	e8 ed b3 ff ff       	call   801026a0 <kalloc>
801072b3:	85 c0                	test   %eax,%eax
801072b5:	74 39                	je     801072f0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801072b7:	83 ec 04             	sub    $0x4,%esp
801072ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
801072bd:	68 00 10 00 00       	push   $0x1000
801072c2:	6a 00                	push   $0x0
801072c4:	50                   	push   %eax
801072c5:	e8 66 d5 ff ff       	call   80104830 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801072ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
801072cd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801072d0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801072d6:	83 c8 07             	or     $0x7,%eax
801072d9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801072db:	89 d8                	mov    %ebx,%eax
801072dd:	c1 e8 0a             	shr    $0xa,%eax
801072e0:	25 fc 0f 00 00       	and    $0xffc,%eax
801072e5:	01 d0                	add    %edx,%eax
801072e7:	eb 92                	jmp    8010727b <mappages+0x4b>
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801072f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072f8:	5b                   	pop    %ebx
801072f9:	5e                   	pop    %esi
801072fa:	5f                   	pop    %edi
801072fb:	5d                   	pop    %ebp
801072fc:	c3                   	ret    
801072fd:	8d 76 00             	lea    0x0(%esi),%esi
80107300:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107303:	31 c0                	xor    %eax,%eax
}
80107305:	5b                   	pop    %ebx
80107306:	5e                   	pop    %esi
80107307:	5f                   	pop    %edi
80107308:	5d                   	pop    %ebp
80107309:	c3                   	ret    
      panic("remap");
8010730a:	83 ec 0c             	sub    $0xc,%esp
8010730d:	68 38 88 10 80       	push   $0x80108838
80107312:	e8 69 90 ff ff       	call   80100380 <panic>
80107317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010731e:	66 90                	xchg   %ax,%ax

80107320 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107320:	a1 c4 b5 11 80       	mov    0x8011b5c4,%eax
80107325:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010732a:	0f 22 d8             	mov    %eax,%cr3
}
8010732d:	c3                   	ret    
8010732e:	66 90                	xchg   %ax,%ax

80107330 <switchuvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 1c             	sub    $0x1c,%esp
80107339:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010733c:	85 f6                	test   %esi,%esi
8010733e:	0f 84 cb 00 00 00    	je     8010740f <switchuvm+0xdf>
  if(p->kstack == 0)
80107344:	8b 46 08             	mov    0x8(%esi),%eax
80107347:	85 c0                	test   %eax,%eax
80107349:	0f 84 da 00 00 00    	je     80107429 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010734f:	8b 46 04             	mov    0x4(%esi),%eax
80107352:	85 c0                	test   %eax,%eax
80107354:	0f 84 c2 00 00 00    	je     8010741c <switchuvm+0xec>
  pushcli();
8010735a:	e8 c1 d2 ff ff       	call   80104620 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010735f:	e8 bc c5 ff ff       	call   80103920 <mycpu>
80107364:	89 c3                	mov    %eax,%ebx
80107366:	e8 b5 c5 ff ff       	call   80103920 <mycpu>
8010736b:	89 c7                	mov    %eax,%edi
8010736d:	e8 ae c5 ff ff       	call   80103920 <mycpu>
80107372:	83 c7 08             	add    $0x8,%edi
80107375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107378:	e8 a3 c5 ff ff       	call   80103920 <mycpu>
8010737d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107380:	ba 67 00 00 00       	mov    $0x67,%edx
80107385:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010738c:	83 c0 08             	add    $0x8,%eax
8010738f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107396:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010739b:	83 c1 08             	add    $0x8,%ecx
8010739e:	c1 e8 18             	shr    $0x18,%eax
801073a1:	c1 e9 10             	shr    $0x10,%ecx
801073a4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801073aa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801073b0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801073b5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073bc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801073c1:	e8 5a c5 ff ff       	call   80103920 <mycpu>
801073c6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073cd:	e8 4e c5 ff ff       	call   80103920 <mycpu>
801073d2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073d6:	8b 5e 08             	mov    0x8(%esi),%ebx
801073d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073df:	e8 3c c5 ff ff       	call   80103920 <mycpu>
801073e4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073e7:	e8 34 c5 ff ff       	call   80103920 <mycpu>
801073ec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073f0:	b8 28 00 00 00       	mov    $0x28,%eax
801073f5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073f8:	8b 46 04             	mov    0x4(%esi),%eax
801073fb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107400:	0f 22 d8             	mov    %eax,%cr3
}
80107403:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107406:	5b                   	pop    %ebx
80107407:	5e                   	pop    %esi
80107408:	5f                   	pop    %edi
80107409:	5d                   	pop    %ebp
  popcli();
8010740a:	e9 61 d2 ff ff       	jmp    80104670 <popcli>
    panic("switchuvm: no process");
8010740f:	83 ec 0c             	sub    $0xc,%esp
80107412:	68 3e 88 10 80       	push   $0x8010883e
80107417:	e8 64 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010741c:	83 ec 0c             	sub    $0xc,%esp
8010741f:	68 69 88 10 80       	push   $0x80108869
80107424:	e8 57 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107429:	83 ec 0c             	sub    $0xc,%esp
8010742c:	68 54 88 10 80       	push   $0x80108854
80107431:	e8 4a 8f ff ff       	call   80100380 <panic>
80107436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010743d:	8d 76 00             	lea    0x0(%esi),%esi

80107440 <inituvm>:
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	57                   	push   %edi
80107444:	56                   	push   %esi
80107445:	53                   	push   %ebx
80107446:	83 ec 1c             	sub    $0x1c,%esp
80107449:	8b 75 10             	mov    0x10(%ebp),%esi
8010744c:	8b 55 08             	mov    0x8(%ebp),%edx
8010744f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107452:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107458:	77 50                	ja     801074aa <inituvm+0x6a>
8010745a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
8010745d:	e8 3e b2 ff ff       	call   801026a0 <kalloc>
  memset(mem, 0, PGSIZE);
80107462:	83 ec 04             	sub    $0x4,%esp
80107465:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010746a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010746c:	6a 00                	push   $0x0
8010746e:	50                   	push   %eax
8010746f:	e8 bc d3 ff ff       	call   80104830 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107474:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107477:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010747d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80107484:	50                   	push   %eax
80107485:	68 00 10 00 00       	push   $0x1000
8010748a:	6a 00                	push   $0x0
8010748c:	52                   	push   %edx
8010748d:	e8 9e fd ff ff       	call   80107230 <mappages>
  memmove(mem, init, sz);
80107492:	89 75 10             	mov    %esi,0x10(%ebp)
80107495:	83 c4 20             	add    $0x20,%esp
80107498:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010749b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010749e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074a1:	5b                   	pop    %ebx
801074a2:	5e                   	pop    %esi
801074a3:	5f                   	pop    %edi
801074a4:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801074a5:	e9 26 d4 ff ff       	jmp    801048d0 <memmove>
    panic("inituvm: more than a page");
801074aa:	83 ec 0c             	sub    $0xc,%esp
801074ad:	68 7d 88 10 80       	push   $0x8010887d
801074b2:	e8 c9 8e ff ff       	call   80100380 <panic>
801074b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074be:	66 90                	xchg   %ax,%ax

801074c0 <loaduvm>:
{
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	57                   	push   %edi
801074c4:	56                   	push   %esi
801074c5:	53                   	push   %ebx
801074c6:	83 ec 1c             	sub    $0x1c,%esp
801074c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801074cc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801074cf:	a9 ff 0f 00 00       	test   $0xfff,%eax
801074d4:	0f 85 bb 00 00 00    	jne    80107595 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801074da:	01 f0                	add    %esi,%eax
801074dc:	89 f3                	mov    %esi,%ebx
801074de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074e1:	8b 45 14             	mov    0x14(%ebp),%eax
801074e4:	01 f0                	add    %esi,%eax
801074e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074e9:	85 f6                	test   %esi,%esi
801074eb:	0f 84 87 00 00 00    	je     80107578 <loaduvm+0xb8>
801074f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801074f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801074fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801074fe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107500:	89 c2                	mov    %eax,%edx
80107502:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107505:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107508:	f6 c2 01             	test   $0x1,%dl
8010750b:	75 13                	jne    80107520 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010750d:	83 ec 0c             	sub    $0xc,%esp
80107510:	68 97 88 10 80       	push   $0x80108897
80107515:	e8 66 8e ff ff       	call   80100380 <panic>
8010751a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107520:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107523:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107529:	25 fc 0f 00 00       	and    $0xffc,%eax
8010752e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107535:	85 c0                	test   %eax,%eax
80107537:	74 d4                	je     8010750d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107539:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010753b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010753e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107543:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107548:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010754e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107551:	29 d9                	sub    %ebx,%ecx
80107553:	05 00 00 00 80       	add    $0x80000000,%eax
80107558:	57                   	push   %edi
80107559:	51                   	push   %ecx
8010755a:	50                   	push   %eax
8010755b:	ff 75 10             	push   0x10(%ebp)
8010755e:	e8 4d a5 ff ff       	call   80101ab0 <readi>
80107563:	83 c4 10             	add    $0x10,%esp
80107566:	39 f8                	cmp    %edi,%eax
80107568:	75 1e                	jne    80107588 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010756a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107570:	89 f0                	mov    %esi,%eax
80107572:	29 d8                	sub    %ebx,%eax
80107574:	39 c6                	cmp    %eax,%esi
80107576:	77 80                	ja     801074f8 <loaduvm+0x38>
}
80107578:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010757b:	31 c0                	xor    %eax,%eax
}
8010757d:	5b                   	pop    %ebx
8010757e:	5e                   	pop    %esi
8010757f:	5f                   	pop    %edi
80107580:	5d                   	pop    %ebp
80107581:	c3                   	ret    
80107582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107588:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010758b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107590:	5b                   	pop    %ebx
80107591:	5e                   	pop    %esi
80107592:	5f                   	pop    %edi
80107593:	5d                   	pop    %ebp
80107594:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107595:	83 ec 0c             	sub    $0xc,%esp
80107598:	68 38 89 10 80       	push   $0x80108938
8010759d:	e8 de 8d ff ff       	call   80100380 <panic>
801075a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075b0 <allocuvm>:
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	57                   	push   %edi
801075b4:	56                   	push   %esi
801075b5:	53                   	push   %ebx
801075b6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801075b9:	8b 7d 10             	mov    0x10(%ebp),%edi
801075bc:	85 ff                	test   %edi,%edi
801075be:	0f 88 bc 00 00 00    	js     80107680 <allocuvm+0xd0>
  if(newsz < oldsz)
801075c4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801075c7:	0f 82 a3 00 00 00    	jb     80107670 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801075cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801075d0:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075d6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801075dc:	39 75 10             	cmp    %esi,0x10(%ebp)
801075df:	0f 86 8e 00 00 00    	jbe    80107673 <allocuvm+0xc3>
801075e5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801075e8:	8b 7d 08             	mov    0x8(%ebp),%edi
801075eb:	eb 43                	jmp    80107630 <allocuvm+0x80>
801075ed:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801075f0:	83 ec 04             	sub    $0x4,%esp
801075f3:	68 00 10 00 00       	push   $0x1000
801075f8:	6a 00                	push   $0x0
801075fa:	50                   	push   %eax
801075fb:	e8 30 d2 ff ff       	call   80104830 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107600:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107606:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010760d:	50                   	push   %eax
8010760e:	68 00 10 00 00       	push   $0x1000
80107613:	56                   	push   %esi
80107614:	57                   	push   %edi
80107615:	e8 16 fc ff ff       	call   80107230 <mappages>
8010761a:	83 c4 20             	add    $0x20,%esp
8010761d:	85 c0                	test   %eax,%eax
8010761f:	78 6f                	js     80107690 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80107621:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107627:	39 75 10             	cmp    %esi,0x10(%ebp)
8010762a:	0f 86 a0 00 00 00    	jbe    801076d0 <allocuvm+0x120>
    mem = kalloc();
80107630:	e8 6b b0 ff ff       	call   801026a0 <kalloc>
80107635:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107637:	85 c0                	test   %eax,%eax
80107639:	75 b5                	jne    801075f0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010763b:	83 ec 0c             	sub    $0xc,%esp
8010763e:	68 b5 88 10 80       	push   $0x801088b5
80107643:	e8 58 90 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107648:	8b 45 0c             	mov    0xc(%ebp),%eax
8010764b:	83 c4 10             	add    $0x10,%esp
8010764e:	39 45 10             	cmp    %eax,0x10(%ebp)
80107651:	74 2d                	je     80107680 <allocuvm+0xd0>
80107653:	8b 55 10             	mov    0x10(%ebp),%edx
80107656:	89 c1                	mov    %eax,%ecx
80107658:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
8010765b:	31 ff                	xor    %edi,%edi
8010765d:	e8 fe f9 ff ff       	call   80107060 <deallocuvm.part.0>
}
80107662:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107665:	89 f8                	mov    %edi,%eax
80107667:	5b                   	pop    %ebx
80107668:	5e                   	pop    %esi
80107669:	5f                   	pop    %edi
8010766a:	5d                   	pop    %ebp
8010766b:	c3                   	ret    
8010766c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107670:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107673:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107676:	89 f8                	mov    %edi,%eax
80107678:	5b                   	pop    %ebx
80107679:	5e                   	pop    %esi
8010767a:	5f                   	pop    %edi
8010767b:	5d                   	pop    %ebp
8010767c:	c3                   	ret    
8010767d:	8d 76 00             	lea    0x0(%esi),%esi
80107680:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107683:	31 ff                	xor    %edi,%edi
}
80107685:	5b                   	pop    %ebx
80107686:	89 f8                	mov    %edi,%eax
80107688:	5e                   	pop    %esi
80107689:	5f                   	pop    %edi
8010768a:	5d                   	pop    %ebp
8010768b:	c3                   	ret    
8010768c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107690:	83 ec 0c             	sub    $0xc,%esp
80107693:	68 cd 88 10 80       	push   $0x801088cd
80107698:	e8 03 90 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
8010769d:	8b 45 0c             	mov    0xc(%ebp),%eax
801076a0:	83 c4 10             	add    $0x10,%esp
801076a3:	39 45 10             	cmp    %eax,0x10(%ebp)
801076a6:	74 0d                	je     801076b5 <allocuvm+0x105>
801076a8:	89 c1                	mov    %eax,%ecx
801076aa:	8b 55 10             	mov    0x10(%ebp),%edx
801076ad:	8b 45 08             	mov    0x8(%ebp),%eax
801076b0:	e8 ab f9 ff ff       	call   80107060 <deallocuvm.part.0>
      kfree(mem);
801076b5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801076b8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801076ba:	53                   	push   %ebx
801076bb:	e8 20 ae ff ff       	call   801024e0 <kfree>
      return 0;
801076c0:	83 c4 10             	add    $0x10,%esp
}
801076c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076c6:	89 f8                	mov    %edi,%eax
801076c8:	5b                   	pop    %ebx
801076c9:	5e                   	pop    %esi
801076ca:	5f                   	pop    %edi
801076cb:	5d                   	pop    %ebp
801076cc:	c3                   	ret    
801076cd:	8d 76 00             	lea    0x0(%esi),%esi
801076d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801076d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d6:	5b                   	pop    %ebx
801076d7:	5e                   	pop    %esi
801076d8:	89 f8                	mov    %edi,%eax
801076da:	5f                   	pop    %edi
801076db:	5d                   	pop    %ebp
801076dc:	c3                   	ret    
801076dd:	8d 76 00             	lea    0x0(%esi),%esi

801076e0 <deallocuvm>:
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801076e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801076e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801076ec:	39 d1                	cmp    %edx,%ecx
801076ee:	73 10                	jae    80107700 <deallocuvm+0x20>
}
801076f0:	5d                   	pop    %ebp
801076f1:	e9 6a f9 ff ff       	jmp    80107060 <deallocuvm.part.0>
801076f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076fd:	8d 76 00             	lea    0x0(%esi),%esi
80107700:	89 d0                	mov    %edx,%eax
80107702:	5d                   	pop    %ebp
80107703:	c3                   	ret    
80107704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop

80107710 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	57                   	push   %edi
80107714:	56                   	push   %esi
80107715:	53                   	push   %ebx
80107716:	83 ec 0c             	sub    $0xc,%esp
80107719:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010771c:	85 f6                	test   %esi,%esi
8010771e:	74 59                	je     80107779 <freevm+0x69>
  if(newsz >= oldsz)
80107720:	31 c9                	xor    %ecx,%ecx
80107722:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107727:	89 f0                	mov    %esi,%eax
80107729:	89 f3                	mov    %esi,%ebx
8010772b:	e8 30 f9 ff ff       	call   80107060 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107730:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107736:	eb 0f                	jmp    80107747 <freevm+0x37>
80107738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010773f:	90                   	nop
80107740:	83 c3 04             	add    $0x4,%ebx
80107743:	39 df                	cmp    %ebx,%edi
80107745:	74 23                	je     8010776a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107747:	8b 03                	mov    (%ebx),%eax
80107749:	a8 01                	test   $0x1,%al
8010774b:	74 f3                	je     80107740 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010774d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107752:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107755:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107758:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010775d:	50                   	push   %eax
8010775e:	e8 7d ad ff ff       	call   801024e0 <kfree>
80107763:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107766:	39 df                	cmp    %ebx,%edi
80107768:	75 dd                	jne    80107747 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010776a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010776d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107770:	5b                   	pop    %ebx
80107771:	5e                   	pop    %esi
80107772:	5f                   	pop    %edi
80107773:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107774:	e9 67 ad ff ff       	jmp    801024e0 <kfree>
    panic("freevm: no pgdir");
80107779:	83 ec 0c             	sub    $0xc,%esp
8010777c:	68 e9 88 10 80       	push   $0x801088e9
80107781:	e8 fa 8b ff ff       	call   80100380 <panic>
80107786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778d:	8d 76 00             	lea    0x0(%esi),%esi

80107790 <setupkvm>:
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	56                   	push   %esi
80107794:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107795:	e8 06 af ff ff       	call   801026a0 <kalloc>
8010779a:	89 c6                	mov    %eax,%esi
8010779c:	85 c0                	test   %eax,%eax
8010779e:	74 42                	je     801077e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801077a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077a3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801077a8:	68 00 10 00 00       	push   $0x1000
801077ad:	6a 00                	push   $0x0
801077af:	50                   	push   %eax
801077b0:	e8 7b d0 ff ff       	call   80104830 <memset>
801077b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801077b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077bb:	8b 53 08             	mov    0x8(%ebx),%edx
801077be:	83 ec 0c             	sub    $0xc,%esp
801077c1:	ff 73 0c             	push   0xc(%ebx)
801077c4:	29 c2                	sub    %eax,%edx
801077c6:	50                   	push   %eax
801077c7:	52                   	push   %edx
801077c8:	ff 33                	push   (%ebx)
801077ca:	56                   	push   %esi
801077cb:	e8 60 fa ff ff       	call   80107230 <mappages>
801077d0:	83 c4 20             	add    $0x20,%esp
801077d3:	85 c0                	test   %eax,%eax
801077d5:	78 19                	js     801077f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077d7:	83 c3 10             	add    $0x10,%ebx
801077da:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801077e0:	75 d6                	jne    801077b8 <setupkvm+0x28>
}
801077e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077e5:	89 f0                	mov    %esi,%eax
801077e7:	5b                   	pop    %ebx
801077e8:	5e                   	pop    %esi
801077e9:	5d                   	pop    %ebp
801077ea:	c3                   	ret    
801077eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077ef:	90                   	nop
      freevm(pgdir);
801077f0:	83 ec 0c             	sub    $0xc,%esp
801077f3:	56                   	push   %esi
      return 0;
801077f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801077f6:	e8 15 ff ff ff       	call   80107710 <freevm>
      return 0;
801077fb:	83 c4 10             	add    $0x10,%esp
}
801077fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107801:	89 f0                	mov    %esi,%eax
80107803:	5b                   	pop    %ebx
80107804:	5e                   	pop    %esi
80107805:	5d                   	pop    %ebp
80107806:	c3                   	ret    
80107807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010780e:	66 90                	xchg   %ax,%ax

80107810 <kvmalloc>:
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107816:	e8 75 ff ff ff       	call   80107790 <setupkvm>
8010781b:	a3 c4 b5 11 80       	mov    %eax,0x8011b5c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107820:	05 00 00 00 80       	add    $0x80000000,%eax
80107825:	0f 22 d8             	mov    %eax,%cr3
}
80107828:	c9                   	leave  
80107829:	c3                   	ret    
8010782a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107830 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	83 ec 08             	sub    $0x8,%esp
80107836:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107839:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010783c:	89 c1                	mov    %eax,%ecx
8010783e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107841:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107844:	f6 c2 01             	test   $0x1,%dl
80107847:	75 17                	jne    80107860 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107849:	83 ec 0c             	sub    $0xc,%esp
8010784c:	68 fa 88 10 80       	push   $0x801088fa
80107851:	e8 2a 8b ff ff       	call   80100380 <panic>
80107856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010785d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107860:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107863:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107869:	25 fc 0f 00 00       	and    $0xffc,%eax
8010786e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107875:	85 c0                	test   %eax,%eax
80107877:	74 d0                	je     80107849 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107879:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010787c:	c9                   	leave  
8010787d:	c3                   	ret    
8010787e:	66 90                	xchg   %ax,%ax

80107880 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
80107886:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107889:	e8 02 ff ff ff       	call   80107790 <setupkvm>
8010788e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107891:	85 c0                	test   %eax,%eax
80107893:	0f 84 c0 00 00 00    	je     80107959 <copyuvm+0xd9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107899:	8b 55 0c             	mov    0xc(%ebp),%edx
8010789c:	85 d2                	test   %edx,%edx
8010789e:	0f 84 b5 00 00 00    	je     80107959 <copyuvm+0xd9>
801078a4:	31 f6                	xor    %esi,%esi
801078a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801078b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801078b3:	89 f0                	mov    %esi,%eax
801078b5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801078b8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801078bb:	a8 01                	test   $0x1,%al
801078bd:	75 11                	jne    801078d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801078bf:	83 ec 0c             	sub    $0xc,%esp
801078c2:	68 04 89 10 80       	push   $0x80108904
801078c7:	e8 b4 8a ff ff       	call   80100380 <panic>
801078cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801078d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801078d7:	c1 ea 0a             	shr    $0xa,%edx
801078da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801078e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801078e7:	85 c0                	test   %eax,%eax
801078e9:	74 d4                	je     801078bf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801078eb:	8b 38                	mov    (%eax),%edi
801078ed:	f7 c7 01 00 00 00    	test   $0x1,%edi
801078f3:	0f 84 9b 00 00 00    	je     80107994 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801078f9:	89 fb                	mov    %edi,%ebx
    flags = PTE_FLAGS(*pte);
801078fb:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80107901:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107904:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
8010790a:	e8 91 ad ff ff       	call   801026a0 <kalloc>
8010790f:	89 c7                	mov    %eax,%edi
80107911:	85 c0                	test   %eax,%eax
80107913:	74 5f                	je     80107974 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107915:	83 ec 04             	sub    $0x4,%esp
80107918:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
8010791e:	68 00 10 00 00       	push   $0x1000
80107923:	53                   	push   %ebx
80107924:	50                   	push   %eax
80107925:	e8 a6 cf ff ff       	call   801048d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010792a:	58                   	pop    %eax
8010792b:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107931:	ff 75 e4             	push   -0x1c(%ebp)
80107934:	50                   	push   %eax
80107935:	68 00 10 00 00       	push   $0x1000
8010793a:	56                   	push   %esi
8010793b:	ff 75 e0             	push   -0x20(%ebp)
8010793e:	e8 ed f8 ff ff       	call   80107230 <mappages>
80107943:	83 c4 20             	add    $0x20,%esp
80107946:	85 c0                	test   %eax,%eax
80107948:	78 1e                	js     80107968 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
8010794a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107950:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107953:	0f 87 57 ff ff ff    	ja     801078b0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107959:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010795c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795f:	5b                   	pop    %ebx
80107960:	5e                   	pop    %esi
80107961:	5f                   	pop    %edi
80107962:	5d                   	pop    %ebp
80107963:	c3                   	ret    
80107964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107968:	83 ec 0c             	sub    $0xc,%esp
8010796b:	57                   	push   %edi
8010796c:	e8 6f ab ff ff       	call   801024e0 <kfree>
      goto bad;
80107971:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107974:	83 ec 0c             	sub    $0xc,%esp
80107977:	ff 75 e0             	push   -0x20(%ebp)
8010797a:	e8 91 fd ff ff       	call   80107710 <freevm>
  return 0;
8010797f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107986:	83 c4 10             	add    $0x10,%esp
}
80107989:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010798c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010798f:	5b                   	pop    %ebx
80107990:	5e                   	pop    %esi
80107991:	5f                   	pop    %edi
80107992:	5d                   	pop    %ebp
80107993:	c3                   	ret    
      panic("copyuvm: page not present");
80107994:	83 ec 0c             	sub    $0xc,%esp
80107997:	68 1e 89 10 80       	push   $0x8010891e
8010799c:	e8 df 89 ff ff       	call   80100380 <panic>
801079a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079af:	90                   	nop

801079b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801079b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801079b9:	89 c1                	mov    %eax,%ecx
801079bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801079be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801079c1:	f6 c2 01             	test   $0x1,%dl
801079c4:	0f 84 24 05 00 00    	je     80107eee <uva2ka.cold>
  return &pgtab[PTX(va)];
801079ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801079d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801079d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801079d9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801079e0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801079e7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079ea:	05 00 00 00 80       	add    $0x80000000,%eax
801079ef:	83 fa 05             	cmp    $0x5,%edx
801079f2:	ba 00 00 00 00       	mov    $0x0,%edx
801079f7:	0f 45 c2             	cmovne %edx,%eax
}
801079fa:	c3                   	ret    
801079fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079ff:	90                   	nop

80107a00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	57                   	push   %edi
80107a04:	56                   	push   %esi
80107a05:	53                   	push   %ebx
80107a06:	83 ec 0c             	sub    $0xc,%esp
80107a09:	8b 75 14             	mov    0x14(%ebp),%esi
80107a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a0f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a12:	85 f6                	test   %esi,%esi
80107a14:	75 51                	jne    80107a67 <copyout+0x67>
80107a16:	e9 a5 00 00 00       	jmp    80107ac0 <copyout+0xc0>
80107a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a1f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107a20:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107a26:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107a2c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107a32:	74 75                	je     80107aa9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107a34:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a36:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107a39:	29 c3                	sub    %eax,%ebx
80107a3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a41:	39 f3                	cmp    %esi,%ebx
80107a43:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107a46:	29 f8                	sub    %edi,%eax
80107a48:	83 ec 04             	sub    $0x4,%esp
80107a4b:	01 c1                	add    %eax,%ecx
80107a4d:	53                   	push   %ebx
80107a4e:	52                   	push   %edx
80107a4f:	51                   	push   %ecx
80107a50:	e8 7b ce ff ff       	call   801048d0 <memmove>
    len -= n;
    buf += n;
80107a55:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107a58:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107a5e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107a61:	01 da                	add    %ebx,%edx
  while(len > 0){
80107a63:	29 de                	sub    %ebx,%esi
80107a65:	74 59                	je     80107ac0 <copyout+0xc0>
  if(*pde & PTE_P){
80107a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107a6a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a6c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107a6e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a71:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107a77:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107a7a:	f6 c1 01             	test   $0x1,%cl
80107a7d:	0f 84 72 04 00 00    	je     80107ef5 <copyout.cold>
  return &pgtab[PTX(va)];
80107a83:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a85:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a8b:	c1 eb 0c             	shr    $0xc,%ebx
80107a8e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107a94:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107a9b:	89 d9                	mov    %ebx,%ecx
80107a9d:	83 e1 05             	and    $0x5,%ecx
80107aa0:	83 f9 05             	cmp    $0x5,%ecx
80107aa3:	0f 84 77 ff ff ff    	je     80107a20 <copyout+0x20>
  }
  return 0;
}
80107aa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107aac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ab1:	5b                   	pop    %ebx
80107ab2:	5e                   	pop    %esi
80107ab3:	5f                   	pop    %edi
80107ab4:	5d                   	pop    %ebp
80107ab5:	c3                   	ret    
80107ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107abd:	8d 76 00             	lea    0x0(%esi),%esi
80107ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ac3:	31 c0                	xor    %eax,%eax
}
80107ac5:	5b                   	pop    %ebx
80107ac6:	5e                   	pop    %esi
80107ac7:	5f                   	pop    %edi
80107ac8:	5d                   	pop    %ebp
80107ac9:	c3                   	ret    
80107aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ad0 <find_available_region>:

// Helper function to find an available region in the virtual address space
uint find_available_region(struct proc *p, uint length) {
80107ad0:	55                   	push   %ebp
80107ad1:	89 e5                	mov    %esp,%ebp
80107ad3:	57                   	push   %edi
80107ad4:	56                   	push   %esi
    uint start = 0x60000000;  // Start of the region where mappings are allowed
    uint end = 0x80000000;    // End of the region where mappings are allowed

    // Sort the mappings by their starting address
    for (int i = 0; i < MAX_WMMAP_INFO - 1; i++) {
80107ad5:	31 f6                	xor    %esi,%esi
uint find_available_region(struct proc *p, uint length) {
80107ad7:	53                   	push   %ebx
80107ad8:	89 f1                	mov    %esi,%ecx
80107ada:	83 ec 14             	sub    $0x14,%esp
80107add:	8b 45 08             	mov    0x8(%ebp),%eax
80107ae0:	8d 98 fc 01 00 00    	lea    0x1fc(%eax),%ebx
80107ae6:	8d b8 94 00 00 00    	lea    0x94(%eax),%edi
80107aec:	89 de                	mov    %ebx,%esi
80107aee:	89 fb                	mov    %edi,%ebx
        for (int j = i + 1; j < MAX_WMMAP_INFO; j++) {
80107af0:	83 c1 01             	add    $0x1,%ecx
80107af3:	89 df                	mov    %ebx,%edi
80107af5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80107af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aff:	90                   	nop
            if (p->mmaps[i].used && p->mmaps[j].used && p->mmaps[i].addr > p->mmaps[j].addr) {
80107b00:	8b 43 f4             	mov    -0xc(%ebx),%eax
80107b03:	85 c0                	test   %eax,%eax
80107b05:	74 69                	je     80107b70 <find_available_region+0xa0>
80107b07:	8b 57 0c             	mov    0xc(%edi),%edx
80107b0a:	85 d2                	test   %edx,%edx
80107b0c:	74 62                	je     80107b70 <find_available_region+0xa0>
80107b0e:	8b 53 e8             	mov    -0x18(%ebx),%edx
80107b11:	3b 17                	cmp    (%edi),%edx
80107b13:	76 5b                	jbe    80107b70 <find_available_region+0xa0>
                // Swap the mappings
                struct mmap temp = p->mmaps[i];
80107b15:	8b 4b ec             	mov    -0x14(%ebx),%ecx
80107b18:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107b1b:	8b 4b f0             	mov    -0x10(%ebx),%ecx
80107b1e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
80107b21:	8b 4b f8             	mov    -0x8(%ebx),%ecx
80107b24:	89 4d ec             	mov    %ecx,-0x14(%ebp)
80107b27:	8b 4b fc             	mov    -0x4(%ebx),%ecx
80107b2a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
                p->mmaps[i] = p->mmaps[j];
80107b2d:	8b 0f                	mov    (%edi),%ecx
80107b2f:	89 4b e8             	mov    %ecx,-0x18(%ebx)
80107b32:	8b 4f 04             	mov    0x4(%edi),%ecx
80107b35:	89 4b ec             	mov    %ecx,-0x14(%ebx)
80107b38:	8b 4f 08             	mov    0x8(%edi),%ecx
80107b3b:	89 4b f0             	mov    %ecx,-0x10(%ebx)
80107b3e:	8b 4f 0c             	mov    0xc(%edi),%ecx
80107b41:	89 4b f4             	mov    %ecx,-0xc(%ebx)
80107b44:	8b 4f 10             	mov    0x10(%edi),%ecx
80107b47:	89 4b f8             	mov    %ecx,-0x8(%ebx)
80107b4a:	8b 4f 14             	mov    0x14(%edi),%ecx
80107b4d:	89 4b fc             	mov    %ecx,-0x4(%ebx)
                p->mmaps[j] = temp;
80107b50:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107b53:	89 17                	mov    %edx,(%edi)
80107b55:	89 4f 04             	mov    %ecx,0x4(%edi)
80107b58:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107b5b:	89 47 0c             	mov    %eax,0xc(%edi)
80107b5e:	89 4f 08             	mov    %ecx,0x8(%edi)
80107b61:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80107b64:	89 4f 10             	mov    %ecx,0x10(%edi)
80107b67:	8b 4d e8             	mov    -0x18(%ebp),%ecx
80107b6a:	89 4f 14             	mov    %ecx,0x14(%edi)
80107b6d:	8d 76 00             	lea    0x0(%esi),%esi
        for (int j = i + 1; j < MAX_WMMAP_INFO; j++) {
80107b70:	83 c7 18             	add    $0x18,%edi
80107b73:	39 f7                	cmp    %esi,%edi
80107b75:	75 89                	jne    80107b00 <find_available_region+0x30>
    for (int i = 0; i < MAX_WMMAP_INFO - 1; i++) {
80107b77:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107b7a:	83 c3 18             	add    $0x18,%ebx
80107b7d:	83 f9 0f             	cmp    $0xf,%ecx
80107b80:	0f 85 6a ff ff ff    	jne    80107af0 <find_available_region+0x20>
80107b86:	8b 45 08             	mov    0x8(%ebp),%eax
80107b89:	8b 75 0c             	mov    0xc(%ebp),%esi
80107b8c:	8d 50 7c             	lea    0x7c(%eax),%edx
80107b8f:	8d 98 e4 01 00 00    	lea    0x1e4(%eax),%ebx
        }
    }

    // Look for available regions between mappings
    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
        uint gap_start = (i == 0) ? start : p->mmaps[i - 1].addr + p->mmaps[i - 1].length;
80107b95:	b8 00 00 00 60       	mov    $0x60000000,%eax
80107b9a:	eb 0d                	jmp    80107ba9 <find_available_region+0xd9>
80107b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ba0:	8b 42 04             	mov    0x4(%edx),%eax
80107ba3:	83 c2 18             	add    $0x18,%edx
80107ba6:	03 42 e8             	add    -0x18(%edx),%eax
        uint gap_end = (i < MAX_WMMAP_INFO && p->mmaps[i].used) ? p->mmaps[i].addr : end;
80107ba9:	8b 7a 0c             	mov    0xc(%edx),%edi
80107bac:	b9 00 00 00 80       	mov    $0x80000000,%ecx
80107bb1:	85 ff                	test   %edi,%edi
80107bb3:	74 02                	je     80107bb7 <find_available_region+0xe7>
80107bb5:	8b 0a                	mov    (%edx),%ecx

        if (gap_end - gap_start >= length) {
80107bb7:	29 c1                	sub    %eax,%ecx
80107bb9:	39 f1                	cmp    %esi,%ecx
80107bbb:	73 06                	jae    80107bc3 <find_available_region+0xf3>
    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80107bbd:	39 d3                	cmp    %edx,%ebx
80107bbf:	75 df                	jne    80107ba0 <find_available_region+0xd0>
            return gap_start;  // Found an available region
        }
    }

    return 0;  // No available region found
80107bc1:	31 c0                	xor    %eax,%eax
}
80107bc3:	83 c4 14             	add    $0x14,%esp
80107bc6:	5b                   	pop    %ebx
80107bc7:	5e                   	pop    %esi
80107bc8:	5f                   	pop    %edi
80107bc9:	5d                   	pop    %ebp
80107bca:	c3                   	ret    
80107bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107bcf:	90                   	nop

80107bd0 <unmap_pages>:

// Helper function to unmap pages
int unmap_pages(struct proc *p, uint addr) {
80107bd0:	55                   	push   %ebp
80107bd1:	89 e5                	mov    %esp,%ebp
80107bd3:	57                   	push   %edi
80107bd4:	56                   	push   %esi
80107bd5:	53                   	push   %ebx
    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80107bd6:	31 db                	xor    %ebx,%ebx
int unmap_pages(struct proc *p, uint addr) {
80107bd8:	83 ec 1c             	sub    $0x1c,%esp
80107bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80107bde:	8b 75 0c             	mov    0xc(%ebp),%esi
80107be1:	83 c0 7c             	add    $0x7c,%eax
80107be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->mmaps[i].used && p->mmaps[i].addr == addr) {
80107be8:	8b 50 0c             	mov    0xc(%eax),%edx
80107beb:	85 d2                	test   %edx,%edx
80107bed:	74 04                	je     80107bf3 <unmap_pages+0x23>
80107bef:	39 30                	cmp    %esi,(%eax)
80107bf1:	74 1d                	je     80107c10 <unmap_pages+0x40>
    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80107bf3:	83 c3 01             	add    $0x1,%ebx
80107bf6:	83 c0 18             	add    $0x18,%eax
80107bf9:	83 fb 10             	cmp    $0x10,%ebx
80107bfc:	75 ea                	jne    80107be8 <unmap_pages+0x18>

            return 0;  // Success
        }
    }
    return -1;  // Mapping not found
}
80107bfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;  // Mapping not found
80107c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c06:	5b                   	pop    %ebx
80107c07:	5e                   	pop    %esi
80107c08:	5f                   	pop    %edi
80107c09:	5d                   	pop    %ebp
80107c0a:	c3                   	ret    
80107c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c0f:	90                   	nop
            int is_shared = p->mmaps[i].flags & MAP_SHARED;
80107c10:	8b 7d 08             	mov    0x8(%ebp),%edi
80107c13:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
80107c16:	8d 0c c7             	lea    (%edi,%eax,8),%ecx
80107c19:	8b 81 84 00 00 00    	mov    0x84(%ecx),%eax
80107c1f:	89 c2                	mov    %eax,%edx
80107c21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            int is_file_backed = p->mmaps[i].fd != -1;
80107c24:	8b 81 8c 00 00 00    	mov    0x8c(%ecx),%eax
            int is_shared = p->mmaps[i].flags & MAP_SHARED;
80107c2a:	83 e2 02             	and    $0x2,%edx
            if (is_shared && is_file_backed) {
80107c2d:	83 f8 ff             	cmp    $0xffffffff,%eax
80107c30:	74 08                	je     80107c3a <unmap_pages+0x6a>
80107c32:	85 d2                	test   %edx,%edx
80107c34:	0f 85 cc 00 00 00    	jne    80107d06 <unmap_pages+0x136>
            lcr3(V2P(p->pgdir));
80107c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80107c3d:	8b 40 04             	mov    0x4(%eax),%eax
            if(!is_shared) {
80107c40:	85 d2                	test   %edx,%edx
80107c42:	0f 85 9b 00 00 00    	jne    80107ce3 <unmap_pages+0x113>
              for (uint a = addr; a < addr + p->mmaps[i].length; a += PGSIZE) {
80107c48:	8b 7d 08             	mov    0x8(%ebp),%edi
80107c4b:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
80107c4e:	8d 0c d7             	lea    (%edi,%edx,8),%ecx
80107c51:	8b 91 80 00 00 00    	mov    0x80(%ecx),%edx
80107c57:	01 f2                	add    %esi,%edx
80107c59:	39 d6                	cmp    %edx,%esi
80107c5b:	0f 83 82 00 00 00    	jae    80107ce3 <unmap_pages+0x113>
80107c61:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80107c64:	89 f7                	mov    %esi,%edi
80107c66:	89 cb                	mov    %ecx,%ebx
80107c68:	eb 18                	jmp    80107c82 <unmap_pages+0xb2>
80107c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c70:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
80107c76:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107c7c:	01 f2                	add    %esi,%edx
80107c7e:	39 fa                	cmp    %edi,%edx
80107c80:	76 5e                	jbe    80107ce0 <unmap_pages+0x110>
  pde = &pgdir[PDX(va)];
80107c82:	89 fa                	mov    %edi,%edx
80107c84:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107c87:	8b 14 90             	mov    (%eax,%edx,4),%edx
80107c8a:	f6 c2 01             	test   $0x1,%dl
80107c8d:	74 e1                	je     80107c70 <unmap_pages+0xa0>
  return &pgtab[PTX(va)];
80107c8f:	89 f9                	mov    %edi,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c91:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107c97:	c1 e9 0a             	shr    $0xa,%ecx
80107c9a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80107ca0:	8d 8c 0a 00 00 00 80 	lea    -0x80000000(%edx,%ecx,1),%ecx
                  if (pte && (*pte & PTE_P)) {
80107ca7:	85 c9                	test   %ecx,%ecx
80107ca9:	74 c5                	je     80107c70 <unmap_pages+0xa0>
80107cab:	8b 11                	mov    (%ecx),%edx
80107cad:	f6 c2 01             	test   $0x1,%dl
80107cb0:	74 be                	je     80107c70 <unmap_pages+0xa0>
                      uint pa = PTE_ADDR(*pte);
80107cb2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
                      kfree(v);
80107cb8:	83 ec 0c             	sub    $0xc,%esp
80107cbb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
                      char *v = P2V(pa);
80107cbe:	81 c2 00 00 00 80    	add    $0x80000000,%edx
                      kfree(v);
80107cc4:	52                   	push   %edx
80107cc5:	e8 16 a8 ff ff       	call   801024e0 <kfree>
                      *pte = 0;
80107cca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
            lcr3(V2P(p->pgdir));
80107ccd:	8b 45 08             	mov    0x8(%ebp),%eax
80107cd0:	83 c4 10             	add    $0x10,%esp
                      *pte = 0;
80107cd3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
            lcr3(V2P(p->pgdir));
80107cd9:	8b 40 04             	mov    0x4(%eax),%eax
80107cdc:	eb 92                	jmp    80107c70 <unmap_pages+0xa0>
80107cde:	66 90                	xchg   %ax,%ax
80107ce0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
            p->mmaps[i].used = 0;
80107ce3:	8b 7d 08             	mov    0x8(%ebp),%edi
80107ce6:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
            lcr3(V2P(p->pgdir));
80107ce9:	05 00 00 00 80       	add    $0x80000000,%eax
            p->mmaps[i].used = 0;
80107cee:	c7 84 d7 88 00 00 00 	movl   $0x0,0x88(%edi,%edx,8)
80107cf5:	00 00 00 00 
80107cf9:	0f 22 d8             	mov    %eax,%cr3
}
80107cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;  // Success
80107cff:	31 c0                	xor    %eax,%eax
}
80107d01:	5b                   	pop    %ebx
80107d02:	5e                   	pop    %esi
80107d03:	5f                   	pop    %edi
80107d04:	5d                   	pop    %ebp
80107d05:	c3                   	ret    
                struct file *f = p->ofile[p->mmaps[i].fd];
80107d06:	8b 44 87 28          	mov    0x28(%edi,%eax,4),%eax
                fileseek(f, p->mmaps[i].file_offset);  // Seek to the correct position in the file
80107d0a:	83 ec 08             	sub    $0x8,%esp
80107d0d:	ff b1 90 00 00 00    	push   0x90(%ecx)
80107d13:	89 cf                	mov    %ecx,%edi
80107d15:	50                   	push   %eax
                struct file *f = p->ofile[p->mmaps[i].fd];
80107d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                fileseek(f, p->mmaps[i].file_offset);  // Seek to the correct position in the file
80107d19:	e8 a2 94 ff ff       	call   801011c0 <fileseek>
                for (uint a = addr; a < addr + p->mmaps[i].length; a += PGSIZE) {
80107d1e:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80107d24:	83 c4 10             	add    $0x10,%esp
80107d27:	89 f9                	mov    %edi,%ecx
80107d29:	01 f0                	add    %esi,%eax
80107d2b:	39 c6                	cmp    %eax,%esi
            lcr3(V2P(p->pgdir));
80107d2d:	8b 45 08             	mov    0x8(%ebp),%eax
80107d30:	8b 40 04             	mov    0x4(%eax),%eax
                for (uint a = addr; a < addr + p->mmaps[i].length; a += PGSIZE) {
80107d33:	73 ae                	jae    80107ce3 <unmap_pages+0x113>
            lcr3(V2P(p->pgdir));
80107d35:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80107d38:	89 f7                	mov    %esi,%edi
80107d3a:	89 cb                	mov    %ecx,%ebx
80107d3c:	eb 14                	jmp    80107d52 <unmap_pages+0x182>
80107d3e:	66 90                	xchg   %ax,%ax
                for (uint a = addr; a < addr + p->mmaps[i].length; a += PGSIZE) {
80107d40:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
80107d46:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107d4c:	01 f2                	add    %esi,%edx
80107d4e:	39 fa                	cmp    %edi,%edx
80107d50:	76 8e                	jbe    80107ce0 <unmap_pages+0x110>
  pde = &pgdir[PDX(va)];
80107d52:	89 fa                	mov    %edi,%edx
80107d54:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107d57:	8b 14 90             	mov    (%eax,%edx,4),%edx
80107d5a:	f6 c2 01             	test   $0x1,%dl
80107d5d:	74 e1                	je     80107d40 <unmap_pages+0x170>
  return &pgtab[PTX(va)];
80107d5f:	89 f9                	mov    %edi,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d61:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107d67:	c1 e9 0a             	shr    $0xa,%ecx
80107d6a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80107d70:	8d 94 0a 00 00 00 80 	lea    -0x80000000(%edx,%ecx,1),%edx
                    if (pte && (*pte & PTE_P)) {
80107d77:	85 d2                	test   %edx,%edx
80107d79:	74 c5                	je     80107d40 <unmap_pages+0x170>
80107d7b:	8b 12                	mov    (%edx),%edx
80107d7d:	f6 c2 01             	test   $0x1,%dl
80107d80:	74 be                	je     80107d40 <unmap_pages+0x170>
                        uint pa = PTE_ADDR(*pte);
80107d82:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
                        filewrite(f, v, PGSIZE);
80107d88:	83 ec 04             	sub    $0x4,%esp
                        char *v = P2V(pa);
80107d8b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
                        filewrite(f, v, PGSIZE);
80107d91:	68 00 10 00 00       	push   $0x1000
80107d96:	52                   	push   %edx
80107d97:	ff 75 e4             	push   -0x1c(%ebp)
80107d9a:	e8 11 93 ff ff       	call   801010b0 <filewrite>
            lcr3(V2P(p->pgdir));
80107d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80107da2:	83 c4 10             	add    $0x10,%esp
80107da5:	8b 40 04             	mov    0x4(%eax),%eax
80107da8:	eb 96                	jmp    80107d40 <unmap_pages+0x170>
80107daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107db0 <find_mapping_index>:

// Helper function to find the index of the mapping in the process's mmaps array
// Returns -1 if the mapping is not found
int find_mapping_index(struct proc *p, int addr, int size) {
80107db0:	55                   	push   %ebp
    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80107db1:	31 d2                	xor    %edx,%edx
int find_mapping_index(struct proc *p, int addr, int size) {
80107db3:	89 e5                	mov    %esp,%ebp
80107db5:	53                   	push   %ebx
80107db6:	8b 45 08             	mov    0x8(%ebp),%eax
80107db9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107dbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
80107dbf:	83 c0 7c             	add    $0x7c,%eax
80107dc2:	eb 0f                	jmp    80107dd3 <find_mapping_index+0x23>
80107dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (int i = 0; i < MAX_WMMAP_INFO; i++) {
80107dc8:	83 c2 01             	add    $0x1,%edx
80107dcb:	83 c0 18             	add    $0x18,%eax
80107dce:	83 fa 10             	cmp    $0x10,%edx
80107dd1:	74 1d                	je     80107df0 <find_mapping_index+0x40>
        if (p->mmaps[i].used && p->mmaps[i].addr == addr && p->mmaps[i].length == size) {
80107dd3:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
80107dd7:	74 ef                	je     80107dc8 <find_mapping_index+0x18>
80107dd9:	39 08                	cmp    %ecx,(%eax)
80107ddb:	75 eb                	jne    80107dc8 <find_mapping_index+0x18>
80107ddd:	39 58 04             	cmp    %ebx,0x4(%eax)
80107de0:	75 e6                	jne    80107dc8 <find_mapping_index+0x18>
            return i;
        }
    }
    return -1;
}
80107de2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107de5:	89 d0                	mov    %edx,%eax
80107de7:	c9                   	leave  
80107de8:	c3                   	ret    
80107de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107df0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
80107df5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107df8:	c9                   	leave  
80107df9:	89 d0                	mov    %edx,%eax
80107dfb:	c3                   	ret    
80107dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107e00 <copy_mapping>:

// Helper function to copy the contents of the old mapping to the new address
// Returns 0 on success, or -1 on failure
int copy_mapping(struct proc *p, uint oldaddr, int oldsize, uint newaddr) {
80107e00:	55                   	push   %ebp
80107e01:	89 e5                	mov    %esp,%ebp
80107e03:	57                   	push   %edi
80107e04:	56                   	push   %esi
80107e05:	53                   	push   %ebx
80107e06:	83 ec 1c             	sub    $0x1c,%esp
    // Determine the number of pages to copy
    int num_pages = PGROUNDUP(oldsize) / PGSIZE;
80107e09:	8b 45 10             	mov    0x10(%ebp),%eax
int copy_mapping(struct proc *p, uint oldaddr, int oldsize, uint newaddr) {
80107e0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int num_pages = PGROUNDUP(oldsize) / PGSIZE;
80107e0f:	05 ff 0f 00 00       	add    $0xfff,%eax
80107e14:	c1 f8 0c             	sar    $0xc,%eax
    char *src, *dst;
    pte_t *pte;

    for (int i = 0; i < num_pages; i++) {
80107e17:	85 c0                	test   %eax,%eax
80107e19:	0f 8e b1 00 00 00    	jle    80107ed0 <copy_mapping+0xd0>
80107e1f:	c1 e0 0c             	shl    $0xc,%eax
80107e22:	03 45 0c             	add    0xc(%ebp),%eax
80107e25:	8b 75 0c             	mov    0xc(%ebp),%esi
80107e28:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107e2b:	8b 45 14             	mov    0x14(%ebp),%eax
80107e2e:	29 f0                	sub    %esi,%eax
80107e30:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107e33:	eb 6d                	jmp    80107ea2 <copy_mapping+0xa2>
80107e35:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107e38:	89 f1                	mov    %esi,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107e3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107e3f:	c1 e9 0a             	shr    $0xa,%ecx
80107e42:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80107e48:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
        src = (char *)oldaddr + (i * PGSIZE);
        dst = (char *)newaddr + (i * PGSIZE);

        // Get the page table entry for the old address
        pte = walkpgdir(p->pgdir, src, 0);
        if (!pte || !(*pte & PTE_P)) {
80107e4f:	85 c0                	test   %eax,%eax
80107e51:	74 6a                	je     80107ebd <copy_mapping+0xbd>
80107e53:	f6 00 01             	testb  $0x1,(%eax)
80107e56:	74 65                	je     80107ebd <copy_mapping+0xbd>
            return -1;  // Page table entry not found or not present
        }

        // Allocate a new physical page for the copy
        char *new_page = kalloc();
80107e58:	e8 43 a8 ff ff       	call   801026a0 <kalloc>
80107e5d:	89 c7                	mov    %eax,%edi
        if (!new_page) {
80107e5f:	85 c0                	test   %eax,%eax
80107e61:	74 5a                	je     80107ebd <copy_mapping+0xbd>
            return -1;  // Failed to allocate memory
        }

        // Copy the contents of the old page to the new page
        memmove(new_page, src, PGSIZE);
80107e63:	83 ec 04             	sub    $0x4,%esp
80107e66:	68 00 10 00 00       	push   $0x1000
80107e6b:	56                   	push   %esi
80107e6c:	50                   	push   %eax
80107e6d:	e8 5e ca ff ff       	call   801048d0 <memmove>

        // Map the new physical page to the new virtual address
        if (mappages(p->pgdir, dst, PGSIZE, V2P(new_page), PTE_W | PTE_U) < 0) {
80107e72:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107e78:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80107e7f:	50                   	push   %eax
80107e80:	68 00 10 00 00       	push   $0x1000
80107e85:	ff 75 e4             	push   -0x1c(%ebp)
80107e88:	ff 73 04             	push   0x4(%ebx)
80107e8b:	e8 a0 f3 ff ff       	call   80107230 <mappages>
80107e90:	83 c4 20             	add    $0x20,%esp
80107e93:	85 c0                	test   %eax,%eax
80107e95:	78 49                	js     80107ee0 <copy_mapping+0xe0>
    for (int i = 0; i < num_pages; i++) {
80107e97:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107e9d:	39 75 dc             	cmp    %esi,-0x24(%ebp)
80107ea0:	74 2e                	je     80107ed0 <copy_mapping+0xd0>
        dst = (char *)newaddr + (i * PGSIZE);
80107ea2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80107ea5:	89 f1                	mov    %esi,%ecx
80107ea7:	c1 e9 16             	shr    $0x16,%ecx
80107eaa:	01 f0                	add    %esi,%eax
80107eac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(*pde & PTE_P){
80107eaf:	8b 43 04             	mov    0x4(%ebx),%eax
80107eb2:	8b 04 88             	mov    (%eax,%ecx,4),%eax
80107eb5:	a8 01                	test   $0x1,%al
80107eb7:	0f 85 7b ff ff ff    	jne    80107e38 <copy_mapping+0x38>
            return -1;  // Failed to map new page
        }
    }

    return 0;  // Copy successful
}
80107ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;  // Failed to map new page
80107ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ec5:	5b                   	pop    %ebx
80107ec6:	5e                   	pop    %esi
80107ec7:	5f                   	pop    %edi
80107ec8:	5d                   	pop    %ebp
80107ec9:	c3                   	ret    
80107eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;  // Copy successful
80107ed3:	31 c0                	xor    %eax,%eax
}
80107ed5:	5b                   	pop    %ebx
80107ed6:	5e                   	pop    %esi
80107ed7:	5f                   	pop    %edi
80107ed8:	5d                   	pop    %ebp
80107ed9:	c3                   	ret    
80107eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            kfree(new_page);
80107ee0:	83 ec 0c             	sub    $0xc,%esp
80107ee3:	57                   	push   %edi
80107ee4:	e8 f7 a5 ff ff       	call   801024e0 <kfree>
            return -1;  // Failed to map new page
80107ee9:	83 c4 10             	add    $0x10,%esp
80107eec:	eb cf                	jmp    80107ebd <copy_mapping+0xbd>

80107eee <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107eee:	a1 00 00 00 00       	mov    0x0,%eax
80107ef3:	0f 0b                	ud2    

80107ef5 <copyout.cold>:
80107ef5:	a1 00 00 00 00       	mov    0x0,%eax
80107efa:	0f 0b                	ud2    
