
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 2e 10 80       	mov    $0x80102e00,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 20 6e 10 	movl   $0x80106e20,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 00 40 00 00       	call   80104060 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 27 6e 10 	movl   $0x80106e27,0x4(%esp)
8010009b:	80 
8010009c:	e8 af 3e 00 00       	call   80103f50 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 65 40 00 00       	call   80104150 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
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
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 da 40 00 00       	call   80104240 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 1f 3e 00 00       	call   80103f90 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 b2 1f 00 00       	call   80102130 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 2e 6e 10 80 	movl   $0x80106e2e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 7b 3e 00 00       	call   80104030 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 3f 6e 10 80 	movl   $0x80106e3f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 3a 3e 00 00       	call   80104030 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 ee 3d 00 00       	call   80103ff0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 42 3f 00 00       	call   80104150 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 eb 3f 00 00       	jmp    80104240 <release>
    panic("brelse");
80100255:	c7 04 24 46 6e 10 80 	movl   $0x80106e46,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 19 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 bd 3e 00 00       	call   80104150 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 03 34 00 00       	call   801036b0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 48 39 00 00       	call   80103c10 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 2a 3f 00 00       	call   80104240 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 a2 13 00 00       	call   801016c0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 0c 3f 00 00       	call   80104240 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 84 13 00 00       	call   801016c0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 f5 23 00 00       	call   80102770 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 4d 6e 10 80 	movl   $0x80106e4d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 8b 78 10 80 	movl   $0x8010788b,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 cc 3c 00 00       	call   80104080 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 61 6e 10 80 	movl   $0x80106e61,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 22 54 00 00       	call   80105830 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 72 53 00 00       	call   80105830 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 66 53 00 00       	call   80105830 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 5a 53 00 00       	call   80105830 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 2f 3e 00 00       	call   80104330 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 72 3d 00 00       	call   80104290 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 65 6e 10 80 	movl   $0x80106e65,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 90 6e 10 80 	movzbl -0x7fef9170(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 99 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 3d 3b 00 00       	call   80104150 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 05 3c 00 00       	call   80104240 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 7a 10 00 00       	call   801016c0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 48 3b 00 00       	call   80104240 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 78 6e 10 80       	mov    $0x80106e78,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 b4 39 00 00       	call   80104150 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 7f 6e 10 80 	movl   $0x80106e7f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 86 39 00 00       	call   80104150 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 14 3a 00 00       	call   80104240 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 e9 34 00 00       	call   80103da0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 54 35 00 00       	jmp    80103e80 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 88 6e 10 	movl   $0x80106e88,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 f6 36 00 00       	call   80104060 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 24 19 00 00       	call   801022c0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 ff 2c 00 00       	call   801036b0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 64 21 00 00       	call   80102b20 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 49 15 00 00       	call   80101f10 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 43 02 00 00    	je     80100c14 <exec+0x274>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 e7 0c 00 00       	call   801016c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 75 0f 00 00       	call   80101970 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 18 0f 00 00       	call   80101920 <iunlockput>
    end_op();
80100a08:	e8 83 21 00 00       	call   80102b90 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 0f 60 00 00       	call   80106a40 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 dd 0e 00 00       	call   80101970 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 c9 5d 00 00       	call   801068a0 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 c8 5c 00 00       	call   801067e0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 92 5e 00 00       	call   801069c0 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 e5 0d 00 00       	call   80101920 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 4b 20 00 00       	call   80102b90 <end_op>
  if((allocuvm(pgdir, KERNBASE - PGSIZE - 1, KERNBASE - 1)) == 0) {
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	c7 44 24 08 ff ff ff 	movl   $0x7fffffff,0x8(%esp)
80100b52:	7f 
80100b53:	c7 44 24 04 ff ef ff 	movl   $0x7fffefff,0x4(%esp)
80100b5a:	7f 
80100b5b:	89 04 24             	mov    %eax,(%esp)
80100b5e:	e8 3d 5d 00 00       	call   801068a0 <allocuvm>
80100b63:	85 c0                	test   %eax,%eax
80100b65:	0f 84 c4 00 00 00    	je     80100c2f <exec+0x28f>
  for(argc = 0; argv[argc]; argc++) {
80100b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b6e:	8b 00                	mov    (%eax),%eax
80100b70:	85 c0                	test   %eax,%eax
80100b72:	0f 84 c5 00 00 00    	je     80100c3d <exec+0x29d>
80100b78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100b7b:	bb fc ff ff 7f       	mov    $0x7ffffffc,%ebx
80100b80:	31 f6                	xor    %esi,%esi
80100b82:	8d 51 04             	lea    0x4(%ecx),%edx
80100b85:	89 cf                	mov    %ecx,%edi
80100b87:	eb 31                	jmp    80100bba <exec+0x21a>
80100b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b90:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
    ustack[3+argc] = sp;
80100b96:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100b9c:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100ba3:	83 c6 01             	add    $0x1,%esi
80100ba6:	8b 02                	mov    (%edx),%eax
80100ba8:	89 d7                	mov    %edx,%edi
80100baa:	85 c0                	test   %eax,%eax
80100bac:	0f 84 98 00 00 00    	je     80100c4a <exec+0x2aa>
80100bb2:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bb5:	83 fe 20             	cmp    $0x20,%esi
80100bb8:	74 42                	je     80100bfc <exec+0x25c>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bba:	89 04 24             	mov    %eax,(%esp)
80100bbd:	89 95 e8 fe ff ff    	mov    %edx,-0x118(%ebp)
80100bc3:	e8 e8 38 00 00       	call   801044b0 <strlen>
80100bc8:	f7 d0                	not    %eax
80100bca:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bcc:	8b 07                	mov    (%edi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bce:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bd1:	89 04 24             	mov    %eax,(%esp)
80100bd4:	e8 d7 38 00 00       	call   801044b0 <strlen>
80100bd9:	83 c0 01             	add    $0x1,%eax
80100bdc:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100be0:	8b 07                	mov    (%edi),%eax
80100be2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100be6:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bea:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bf0:	89 04 24             	mov    %eax,(%esp)
80100bf3:	e8 18 61 00 00       	call   80106d10 <copyout>
80100bf8:	85 c0                	test   %eax,%eax
80100bfa:	79 94                	jns    80100b90 <exec+0x1f0>
    freevm(pgdir);
80100bfc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c02:	89 04 24             	mov    %eax,(%esp)
80100c05:	e8 b6 5d 00 00       	call   801069c0 <freevm>
  return -1;
80100c0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c0f:	e9 fe fd ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100c14:	e8 77 1f 00 00       	call   80102b90 <end_op>
    cprintf("exec: fail\n");
80100c19:	c7 04 24 a1 6e 10 80 	movl   $0x80106ea1,(%esp)
80100c20:	e8 2b fa ff ff       	call   80100650 <cprintf>
    return -1;
80100c25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c2a:	e9 e3 fd ff ff       	jmp    80100a12 <exec+0x72>
    cprintf("goto bad; (exec.c)\n");
80100c2f:	c7 04 24 ad 6e 10 80 	movl   $0x80106ead,(%esp)
80100c36:	e8 15 fa ff ff       	call   80100650 <cprintf>
    goto bad;
80100c3b:	eb bf                	jmp    80100bfc <exec+0x25c>
  for(argc = 0; argv[argc]; argc++) {
80100c3d:	bb fc ff ff 7f       	mov    $0x7ffffffc,%ebx
80100c42:	31 f6                	xor    %esi,%esi
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c4a:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c51:	89 da                	mov    %ebx,%edx
80100c53:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c55:	83 c0 0c             	add    $0xc,%eax
80100c58:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c5e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c64:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c68:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[3+argc] = 0;
80100c6c:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c73:	00 00 00 00 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c77:	89 04 24             	mov    %eax,(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c7a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c81:	ff ff ff 
  ustack[1] = argc;
80100c84:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8a:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c90:	e8 7b 60 00 00       	call   80106d10 <copyout>
80100c95:	85 c0                	test   %eax,%eax
80100c97:	0f 88 5f ff ff ff    	js     80100bfc <exec+0x25c>
  for(last=s=path; *s; s++)
80100c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80100ca0:	0f b6 10             	movzbl (%eax),%edx
80100ca3:	84 d2                	test   %dl,%dl
80100ca5:	74 19                	je     80100cc0 <exec+0x320>
80100ca7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100caa:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100cad:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cb0:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cb3:	0f 44 c8             	cmove  %eax,%ecx
80100cb6:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100cb9:	84 d2                	test   %dl,%dl
80100cbb:	75 f0                	jne    80100cad <exec+0x30d>
80100cbd:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cc0:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80100cc9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cd0:	00 
80100cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cd5:	89 f8                	mov    %edi,%eax
80100cd7:	83 c0 6c             	add    $0x6c,%eax
80100cda:	89 04 24             	mov    %eax,(%esp)
80100cdd:	e8 8e 37 00 00       	call   80104470 <safestrcpy>
  sz = PGROUNDUP(sz);
80100ce2:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  curproc->pgdir = pgdir;
80100ce8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100cee:	8b 77 04             	mov    0x4(%edi),%esi
  sz = PGROUNDUP(sz);
80100cf1:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cf6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cfb:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100cfd:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100d00:	89 57 04             	mov    %edx,0x4(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d03:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d09:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d0c:	8b 47 18             	mov    0x18(%edi),%eax
80100d0f:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->stackSize = 1;
80100d12:	c7 47 7c 01 00 00 00 	movl   $0x1,0x7c(%edi)
  cprintf("Starting number of pages allocated: %d\n", curproc->stackSize); 
80100d19:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80100d20:	00 
80100d21:	c7 04 24 c4 6e 10 80 	movl   $0x80106ec4,(%esp)
80100d28:	e8 23 f9 ff ff       	call   80100650 <cprintf>
  switchuvm(curproc);
80100d2d:	89 3c 24             	mov    %edi,(%esp)
80100d30:	e8 0b 59 00 00       	call   80106640 <switchuvm>
  freevm(oldpgdir);
80100d35:	89 34 24             	mov    %esi,(%esp)
80100d38:	e8 83 5c 00 00       	call   801069c0 <freevm>
  return 0;
80100d3d:	31 c0                	xor    %eax,%eax
80100d3f:	e9 ce fc ff ff       	jmp    80100a12 <exec+0x72>
80100d44:	66 90                	xchg   %ax,%ax
80100d46:	66 90                	xchg   %ax,%ax
80100d48:	66 90                	xchg   %ax,%ax
80100d4a:	66 90                	xchg   %ax,%ax
80100d4c:	66 90                	xchg   %ax,%ax
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	c7 44 24 04 ec 6e 10 	movl   $0x80106eec,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 f6 32 00 00       	call   80104060 <initlock>
}
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d7c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d83:	e8 c8 33 00 00       	call   80104150 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 8b 34 00 00       	call   80104240 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100db5:	83 c4 14             	add    $0x14,%esp
      return f;
80100db8:	89 d8                	mov    %ebx,%eax
}
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100dc0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc7:	e8 74 34 00 00       	call   80104240 <release>
}
80100dcc:	83 c4 14             	add    $0x14,%esp
  return 0;
80100dcf:	31 c0                	xor    %eax,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df1:	e8 5a 33 00 00       	call   80104150 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e0a:	e8 31 34 00 00       	call   80104240 <release>
  return f;
}
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
    panic("filedup");
80100e17:	c7 04 24 f3 6e 10 80 	movl   $0x80106ef3,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e43:	e8 08 33 00 00       	call   80104150 <acquire>
  if(f->ref < 1)
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
    release(&ftable.lock);
80100e5d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e6b:	e9 d0 33 00 00       	jmp    80104240 <release>
  ff = *f;
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e8f:	e8 ac 33 00 00       	call   80104240 <release>
  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
}
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 b8 23 00 00       	call   80103270 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ec0:	e8 5b 1c 00 00       	call   80102b20 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 10 09 00 00       	call   801017e0 <iput>
}
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
    end_op();
80100ed7:	e9 b4 1c 00 00       	jmp    80102b90 <end_op>
    panic("fileclose");
80100edc:	c7 04 24 fb 6e 10 80 	movl   $0x80106efb,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 b6 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 24 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 79 08 00 00       	call   801017a0 <iunlock>
    return 0;
  }
  return -1;
}
80100f27:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f2a:	31 c0                	xor    %eax,%eax
}
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
    ilock(f->ip);
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 51 07 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 e7 09 00 00       	call   80101970 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 03 08 00 00       	call   801017a0 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9d:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fb5:	e9 36 24 00 00       	jmp    801033f0 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
  panic("fileread");
80100fc7:	c7 04 24 05 6f 10 80 	movl   $0x80106f05,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 67 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101039:	e8 52 1b 00 00       	call   80102b90 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101049:	01 c3                	add    %eax,%ebx
    while(i < n){
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101063:	e8 b8 1a 00 00       	call   80102b20 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 4d 06 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 de 09 00 00       	call   80101a70 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 fc 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010a4:	e8 e7 1a 00 00       	call   80102b90 <end_op>
      if(r < 0)
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
}
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 1f 22 00 00       	jmp    80103300 <pipewrite>
        panic("short filewrite");
801010e1:	c7 04 24 0e 6f 10 80 	movl   $0x80106f0e,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010ed:	c7 04 24 14 6f 10 80 	movl   $0x80106f14,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 2c             	sub    $0x2c,%esp
80101109:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010110c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101111:	85 c0                	test   %eax,%eax
80101113:	0f 84 8c 00 00 00    	je     801011a5 <balloc+0xa5>
80101119:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101120:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101123:	89 f0                	mov    %esi,%eax
80101125:	c1 f8 0c             	sar    $0xc,%eax
80101128:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010112e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101132:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101135:	89 04 24             	mov    %eax,(%esp)
80101138:	e8 93 ef ff ff       	call   801000d0 <bread>
8010113d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101140:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101145:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101148:	31 c0                	xor    %eax,%eax
8010114a:	eb 33                	jmp    8010117f <balloc+0x7f>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101150:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101153:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
80101155:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	bf 01 00 00 00       	mov    $0x1,%edi
80101162:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101164:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
80101169:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116b:	0f b6 fb             	movzbl %bl,%edi
8010116e:	85 cf                	test   %ecx,%edi
80101170:	74 46                	je     801011b8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101172:	83 c0 01             	add    $0x1,%eax
80101175:	83 c6 01             	add    $0x1,%esi
80101178:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010117d:	74 05                	je     80101184 <balloc+0x84>
8010117f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101182:	72 cc                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101187:	89 04 24             	mov    %eax,(%esp)
8010118a:	e8 51 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010118f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010119f:	0f 82 7b ff ff ff    	jb     80101120 <balloc+0x20>
  }
  panic("balloc: out of blocks");
801011a5:	c7 04 24 1e 6f 10 80 	movl   $0x80106f1e,(%esp)
801011ac:	e8 af f1 ff ff       	call   80100360 <panic>
801011b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	09 d9                	or     %ebx,%ecx
801011ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011bd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011c1:	89 1c 24             	mov    %ebx,(%esp)
801011c4:	e8 f7 1a 00 00       	call   80102cc0 <log_write>
        brelse(bp);
801011c9:	89 1c 24             	mov    %ebx,(%esp)
801011cc:	e8 0f f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011d4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011d8:	89 04 24             	mov    %eax,(%esp)
801011db:	e8 f0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011e7:	00 
801011e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011ef:	00 
  bp = bread(dev, bno);
801011f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011f5:	89 04 24             	mov    %eax,(%esp)
801011f8:	e8 93 30 00 00       	call   80104290 <memset>
  log_write(bp);
801011fd:	89 1c 24             	mov    %ebx,(%esp)
80101200:	e8 bb 1a 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101205:	89 1c 24             	mov    %ebx,(%esp)
80101208:	e8 d3 ef ff ff       	call   801001e0 <brelse>
}
8010120d:	83 c4 2c             	add    $0x2c,%esp
80101210:	89 f0                	mov    %esi,%eax
80101212:	5b                   	pop    %ebx
80101213:	5e                   	pop    %esi
80101214:	5f                   	pop    %edi
80101215:	5d                   	pop    %ebp
80101216:	c3                   	ret    
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	89 c7                	mov    %eax,%edi
80101226:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101227:	31 f6                	xor    %esi,%esi
{
80101229:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010122f:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
80101232:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
80101239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010123c:	e8 0f 2f 00 00       	call   80104150 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101244:	eb 14                	jmp    8010125a <iget+0x3a>
80101246:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101248:	85 f6                	test   %esi,%esi
8010124a:	74 3c                	je     80101288 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101252:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101258:	74 46                	je     801012a0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010125d:	85 c9                	test   %ecx,%ecx
8010125f:	7e e7                	jle    80101248 <iget+0x28>
80101261:	39 3b                	cmp    %edi,(%ebx)
80101263:	75 e3                	jne    80101248 <iget+0x28>
80101265:	39 53 04             	cmp    %edx,0x4(%ebx)
80101268:	75 de                	jne    80101248 <iget+0x28>
      ip->ref++;
8010126a:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010126d:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010126f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101276:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101279:	e8 c2 2f 00 00       	call   80104240 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127e:	83 c4 1c             	add    $0x1c,%esp
80101281:	89 f0                	mov    %esi,%eax
80101283:	5b                   	pop    %ebx
80101284:	5e                   	pop    %esi
80101285:	5f                   	pop    %edi
80101286:	5d                   	pop    %ebp
80101287:	c3                   	ret    
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101299:	75 bf                	jne    8010125a <iget+0x3a>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 29                	je     801012cd <iget+0xad>
  ip->dev = dev;
801012a4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012a9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012b7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012be:	e8 7d 2f 00 00       	call   80104240 <release>
}
801012c3:	83 c4 1c             	add    $0x1c,%esp
801012c6:	89 f0                	mov    %esi,%eax
801012c8:	5b                   	pop    %ebx
801012c9:	5e                   	pop    %esi
801012ca:	5f                   	pop    %edi
801012cb:	5d                   	pop    %ebp
801012cc:	c3                   	ret    
    panic("iget: no inodes");
801012cd:	c7 04 24 34 6f 10 80 	movl   $0x80106f34,(%esp)
801012d4:	e8 87 f0 ff ff       	call   80100360 <panic>
801012d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c3                	mov    %eax,%ebx
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 66                	je     80101360 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	83 c4 1c             	add    $0x1c,%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
80101308:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010130b:	83 fe 7f             	cmp    $0x7f,%esi
8010130e:	77 77                	ja     80101387 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101310:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101316:	85 c0                	test   %eax,%eax
80101318:	74 5e                	je     80101378 <bmap+0x98>
    bp = bread(ip->dev, addr);
8010131a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131e:	8b 03                	mov    (%ebx),%eax
80101320:	89 04 24             	mov    %eax,(%esp)
80101323:	e8 a8 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101328:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
8010132c:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010132e:	8b 32                	mov    (%edx),%esi
80101330:	85 f6                	test   %esi,%esi
80101332:	75 19                	jne    8010134d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101334:	8b 03                	mov    (%ebx),%eax
80101336:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101339:	e8 c2 fd ff ff       	call   80101100 <balloc>
8010133e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101341:	89 02                	mov    %eax,(%edx)
80101343:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101345:	89 3c 24             	mov    %edi,(%esp)
80101348:	e8 73 19 00 00       	call   80102cc0 <log_write>
    brelse(bp);
8010134d:	89 3c 24             	mov    %edi,(%esp)
80101350:	e8 8b ee ff ff       	call   801001e0 <brelse>
}
80101355:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
80101358:	89 f0                	mov    %esi,%eax
}
8010135a:	5b                   	pop    %ebx
8010135b:	5e                   	pop    %esi
8010135c:	5f                   	pop    %edi
8010135d:	5d                   	pop    %ebp
8010135e:	c3                   	ret    
8010135f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101360:	8b 03                	mov    (%ebx),%eax
80101362:	e8 99 fd ff ff       	call   80101100 <balloc>
80101367:	89 46 5c             	mov    %eax,0x5c(%esi)
}
8010136a:	83 c4 1c             	add    $0x1c,%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101378:	8b 03                	mov    (%ebx),%eax
8010137a:	e8 81 fd ff ff       	call   80101100 <balloc>
8010137f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101385:	eb 93                	jmp    8010131a <bmap+0x3a>
  panic("bmap: out of range");
80101387:	c7 04 24 44 6f 10 80 	movl   $0x80106f44,(%esp)
8010138e:	e8 cd ef ff ff       	call   80100360 <panic>
80101393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <readsb>:
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	56                   	push   %esi
801013a4:	53                   	push   %ebx
801013a5:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
801013a8:	8b 45 08             	mov    0x8(%ebp),%eax
801013ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013b2:	00 
{
801013b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013b6:	89 04 24             	mov    %eax,(%esp)
801013b9:	e8 12 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013be:	89 34 24             	mov    %esi,(%esp)
801013c1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013c8:	00 
  bp = bread(dev, 1);
801013c9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013cb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801013d2:	e8 59 2f 00 00       	call   80104330 <memmove>
  brelse(bp);
801013d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013da:	83 c4 10             	add    $0x10,%esp
801013dd:	5b                   	pop    %ebx
801013de:	5e                   	pop    %esi
801013df:	5d                   	pop    %ebp
  brelse(bp);
801013e0:	e9 fb ed ff ff       	jmp    801001e0 <brelse>
801013e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	89 d7                	mov    %edx,%edi
801013f6:	56                   	push   %esi
801013f7:	53                   	push   %ebx
801013f8:	89 c3                	mov    %eax,%ebx
801013fa:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
801013fd:	89 04 24             	mov    %eax,(%esp)
80101400:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101407:	80 
80101408:	e8 93 ff ff ff       	call   801013a0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010140d:	89 fa                	mov    %edi,%edx
8010140f:	c1 ea 0c             	shr    $0xc,%edx
80101412:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101418:	89 1c 24             	mov    %ebx,(%esp)
  m = 1 << (bi % 8);
8010141b:	bb 01 00 00 00       	mov    $0x1,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101420:	89 54 24 04          	mov    %edx,0x4(%esp)
80101424:	e8 a7 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101429:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
8010142b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101431:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101433:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101436:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101439:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
8010143b:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
8010143d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101442:	0f b6 c8             	movzbl %al,%ecx
80101445:	85 d9                	test   %ebx,%ecx
80101447:	74 20                	je     80101469 <bfree+0x79>
  bp->data[bi/8] &= ~m;
80101449:	f7 d3                	not    %ebx
8010144b:	21 c3                	and    %eax,%ebx
8010144d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 67 18 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101459:	89 34 24             	mov    %esi,(%esp)
8010145c:	e8 7f ed ff ff       	call   801001e0 <brelse>
}
80101461:	83 c4 1c             	add    $0x1c,%esp
80101464:	5b                   	pop    %ebx
80101465:	5e                   	pop    %esi
80101466:	5f                   	pop    %edi
80101467:	5d                   	pop    %ebp
80101468:	c3                   	ret    
    panic("freeing free block");
80101469:	c7 04 24 57 6f 10 80 	movl   $0x80106f57,(%esp)
80101470:	e8 eb ee ff ff       	call   80100360 <panic>
80101475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010148c:	c7 44 24 04 6a 6f 10 	movl   $0x80106f6a,0x4(%esp)
80101493:	80 
80101494:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010149b:	e8 c0 2b 00 00       	call   80104060 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	89 1c 24             	mov    %ebx,(%esp)
801014a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a9:	c7 44 24 04 71 6f 10 	movl   $0x80106f71,0x4(%esp)
801014b0:	80 
801014b1:	e8 9a 2a 00 00       	call   80103f50 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bc:	75 e2                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014be:	8b 45 08             	mov    0x8(%ebp),%eax
801014c1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014c8:	80 
801014c9:	89 04 24             	mov    %eax,(%esp)
801014cc:	e8 cf fe ff ff       	call   801013a0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014d1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014d6:	c7 04 24 d4 6f 10 80 	movl   $0x80106fd4,(%esp)
801014dd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014e1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014e6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ea:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014ef:	89 44 24 14          	mov    %eax,0x14(%esp)
801014f3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014f8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014fc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101501:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101505:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010150a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010150e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101513:	89 44 24 04          	mov    %eax,0x4(%esp)
80101517:	e8 34 f1 ff ff       	call   80100650 <cprintf>
}
8010151c:	83 c4 24             	add    $0x24,%esp
8010151f:	5b                   	pop    %ebx
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
80101522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <ialloc>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 2c             	sub    $0x2c,%esp
80101539:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101543:	8b 7d 08             	mov    0x8(%ebp),%edi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 a2 00 00 00    	jbe    801015f1 <ialloc+0xc1>
8010154f:	be 01 00 00 00       	mov    $0x1,%esi
80101554:	bb 01 00 00 00       	mov    $0x1,%ebx
80101559:	eb 1a                	jmp    80101575 <ialloc+0x45>
8010155b:	90                   	nop
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101560:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101566:	e8 75 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010156b:	89 de                	mov    %ebx,%esi
8010156d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101573:	73 7c                	jae    801015f1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101575:	89 f0                	mov    %esi,%eax
80101577:	c1 e8 03             	shr    $0x3,%eax
8010157a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101580:	89 3c 24             	mov    %edi,(%esp)
80101583:	89 44 24 04          	mov    %eax,0x4(%esp)
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 f0                	mov    %esi,%eax
80101590:	83 e0 07             	and    $0x7,%eax
80101593:	c1 e0 06             	shl    $0x6,%eax
80101596:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010159e:	75 c0                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a0:	89 0c 24             	mov    %ecx,(%esp)
801015a3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015aa:	00 
801015ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015b2:	00 
801015b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	e8 d2 2c 00 00       	call   80104290 <memset>
      dip->type = type;
801015be:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015cb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ce:	89 14 24             	mov    %edx,(%esp)
801015d1:	e8 ea 16 00 00       	call   80102cc0 <log_write>
      brelse(bp);
801015d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015d9:	89 14 24             	mov    %edx,(%esp)
801015dc:	e8 ff eb ff ff       	call   801001e0 <brelse>
}
801015e1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015e4:	89 f2                	mov    %esi,%edx
}
801015e6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015e7:	89 f8                	mov    %edi,%eax
}
801015e9:	5e                   	pop    %esi
801015ea:	5f                   	pop    %edi
801015eb:	5d                   	pop    %ebp
      return iget(dev, inum);
801015ec:	e9 2f fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015f1:	c7 04 24 77 6f 10 80 	movl   $0x80106f77,(%esp)
801015f8:	e8 63 ed ff ff       	call   80100360 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	83 ec 10             	sub    $0x10,%esp
80101608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010161a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010161e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101621:	89 04 24             	mov    %eax,(%esp)
80101624:	e8 a7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101629:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010162c:	83 e2 07             	and    $0x7,%edx
8010162f:	c1 e2 06             	shl    $0x6,%edx
80101632:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101636:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101638:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010163f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101643:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101647:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010164b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010164f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101653:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101657:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010165b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010165e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101661:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101665:	89 14 24             	mov    %edx,(%esp)
80101668:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010166f:	00 
80101670:	e8 bb 2c 00 00       	call   80104330 <memmove>
  log_write(bp);
80101675:	89 34 24             	mov    %esi,(%esp)
80101678:	e8 43 16 00 00       	call   80102cc0 <log_write>
  brelse(bp);
8010167d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101680:	83 c4 10             	add    $0x10,%esp
80101683:	5b                   	pop    %ebx
80101684:	5e                   	pop    %esi
80101685:	5d                   	pop    %ebp
  brelse(bp);
80101686:	e9 55 eb ff ff       	jmp    801001e0 <brelse>
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <idup>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 14             	sub    $0x14,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 aa 2a 00 00       	call   80104150 <acquire>
  ip->ref++;
801016a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 8a 2b 00 00       	call   80104240 <release>
}
801016b6:	83 c4 14             	add    $0x14,%esp
801016b9:	89 d8                	mov    %ebx,%eax
801016bb:	5b                   	pop    %ebx
801016bc:	5d                   	pop    %ebp
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax

801016c0 <ilock>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 10             	sub    $0x10,%esp
801016c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016cb:	85 db                	test   %ebx,%ebx
801016cd:	0f 84 b3 00 00 00    	je     80101786 <ilock+0xc6>
801016d3:	8b 53 08             	mov    0x8(%ebx),%edx
801016d6:	85 d2                	test   %edx,%edx
801016d8:	0f 8e a8 00 00 00    	jle    80101786 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016de:	8d 43 0c             	lea    0xc(%ebx),%eax
801016e1:	89 04 24             	mov    %eax,(%esp)
801016e4:	e8 a7 28 00 00       	call   80103f90 <acquiresleep>
  if(ip->valid == 0){
801016e9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ec:	85 c0                	test   %eax,%eax
801016ee:	74 08                	je     801016f8 <ilock+0x38>
}
801016f0:	83 c4 10             	add    $0x10,%esp
801016f3:	5b                   	pop    %ebx
801016f4:	5e                   	pop    %esi
801016f5:	5d                   	pop    %ebp
801016f6:	c3                   	ret    
801016f7:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
801016fb:	c1 e8 03             	shr    $0x3,%eax
801016fe:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101704:	89 44 24 04          	mov    %eax,0x4(%esp)
80101708:	8b 03                	mov    (%ebx),%eax
8010170a:	89 04 24             	mov    %eax,(%esp)
8010170d:	e8 be e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101712:	8b 53 04             	mov    0x4(%ebx),%edx
80101715:	83 e2 07             	and    $0x7,%edx
80101718:	c1 e2 06             	shl    $0x6,%edx
8010171b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101721:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101724:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101727:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010172b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010172f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101733:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101737:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010173b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010173f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101743:	8b 42 fc             	mov    -0x4(%edx),%eax
80101746:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101749:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010174c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101750:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101757:	00 
80101758:	89 04 24             	mov    %eax,(%esp)
8010175b:	e8 d0 2b 00 00       	call   80104330 <memmove>
    brelse(bp);
80101760:	89 34 24             	mov    %esi,(%esp)
80101763:	e8 78 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 76 ff ff ff    	jne    801016f0 <ilock+0x30>
      panic("ilock: no type");
8010177a:	c7 04 24 8f 6f 10 80 	movl   $0x80106f8f,(%esp)
80101781:	e8 da eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101786:	c7 04 24 89 6f 10 80 	movl   $0x80106f89,(%esp)
8010178d:	e8 ce eb ff ff       	call   80100360 <panic>
80101792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017a0 <iunlock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	83 ec 10             	sub    $0x10,%esp
801017a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017ab:	85 db                	test   %ebx,%ebx
801017ad:	74 24                	je     801017d3 <iunlock+0x33>
801017af:	8d 73 0c             	lea    0xc(%ebx),%esi
801017b2:	89 34 24             	mov    %esi,(%esp)
801017b5:	e8 76 28 00 00       	call   80104030 <holdingsleep>
801017ba:	85 c0                	test   %eax,%eax
801017bc:	74 15                	je     801017d3 <iunlock+0x33>
801017be:	8b 43 08             	mov    0x8(%ebx),%eax
801017c1:	85 c0                	test   %eax,%eax
801017c3:	7e 0e                	jle    801017d3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017c5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	5b                   	pop    %ebx
801017cc:	5e                   	pop    %esi
801017cd:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017ce:	e9 1d 28 00 00       	jmp    80103ff0 <releasesleep>
    panic("iunlock");
801017d3:	c7 04 24 9e 6f 10 80 	movl   $0x80106f9e,(%esp)
801017da:	e8 81 eb ff ff       	call   80100360 <panic>
801017df:	90                   	nop

801017e0 <iput>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 1c             	sub    $0x1c,%esp
801017e9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ec:	8d 7e 0c             	lea    0xc(%esi),%edi
801017ef:	89 3c 24             	mov    %edi,(%esp)
801017f2:	e8 99 27 00 00       	call   80103f90 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017fa:	85 d2                	test   %edx,%edx
801017fc:	74 07                	je     80101805 <iput+0x25>
801017fe:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101803:	74 2b                	je     80101830 <iput+0x50>
  releasesleep(&ip->lock);
80101805:	89 3c 24             	mov    %edi,(%esp)
80101808:	e8 e3 27 00 00       	call   80103ff0 <releasesleep>
  acquire(&icache.lock);
8010180d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101814:	e8 37 29 00 00       	call   80104150 <acquire>
  ip->ref--;
80101819:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010181d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101824:	83 c4 1c             	add    $0x1c,%esp
80101827:	5b                   	pop    %ebx
80101828:	5e                   	pop    %esi
80101829:	5f                   	pop    %edi
8010182a:	5d                   	pop    %ebp
  release(&icache.lock);
8010182b:	e9 10 2a 00 00       	jmp    80104240 <release>
    acquire(&icache.lock);
80101830:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101837:	e8 14 29 00 00       	call   80104150 <acquire>
    int r = ip->ref;
8010183c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010183f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101846:	e8 f5 29 00 00       	call   80104240 <release>
    if(r == 1){
8010184b:	83 fb 01             	cmp    $0x1,%ebx
8010184e:	75 b5                	jne    80101805 <iput+0x25>
80101850:	8d 4e 30             	lea    0x30(%esi),%ecx
80101853:	89 f3                	mov    %esi,%ebx
80101855:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101858:	89 cf                	mov    %ecx,%edi
8010185a:	eb 0b                	jmp    80101867 <iput+0x87>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101863:	39 fb                	cmp    %edi,%ebx
80101865:	74 19                	je     80101880 <iput+0xa0>
    if(ip->addrs[i]){
80101867:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010186a:	85 d2                	test   %edx,%edx
8010186c:	74 f2                	je     80101860 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010186e:	8b 06                	mov    (%esi),%eax
80101870:	e8 7b fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101875:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010187c:	eb e2                	jmp    80101860 <iput+0x80>
8010187e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101880:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101889:	85 c0                	test   %eax,%eax
8010188b:	75 2b                	jne    801018b8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010188d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101894:	89 34 24             	mov    %esi,(%esp)
80101897:	e8 64 fd ff ff       	call   80101600 <iupdate>
      ip->type = 0;
8010189c:	31 c0                	xor    %eax,%eax
8010189e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018a2:	89 34 24             	mov    %esi,(%esp)
801018a5:	e8 56 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018aa:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018b1:	e9 4f ff ff ff       	jmp    80101805 <iput+0x25>
801018b6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018bc:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018be:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c0:	89 04 24             	mov    %eax,(%esp)
801018c3:	e8 08 e8 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018c8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018cb:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018d1:	89 cf                	mov    %ecx,%edi
801018d3:	31 c0                	xor    %eax,%eax
801018d5:	eb 0e                	jmp    801018e5 <iput+0x105>
801018d7:	90                   	nop
801018d8:	83 c3 01             	add    $0x1,%ebx
801018db:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018e1:	89 d8                	mov    %ebx,%eax
801018e3:	74 10                	je     801018f5 <iput+0x115>
      if(a[j])
801018e5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018e8:	85 d2                	test   %edx,%edx
801018ea:	74 ec                	je     801018d8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018ec:	8b 06                	mov    (%esi),%eax
801018ee:	e8 fd fa ff ff       	call   801013f0 <bfree>
801018f3:	eb e3                	jmp    801018d8 <iput+0xf8>
    brelse(bp);
801018f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018fb:	89 04 24             	mov    %eax,(%esp)
801018fe:	e8 dd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101903:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101909:	8b 06                	mov    (%esi),%eax
8010190b:	e8 e0 fa ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101910:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101917:	00 00 00 
8010191a:	e9 6e ff ff ff       	jmp    8010188d <iput+0xad>
8010191f:	90                   	nop

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 14             	sub    $0x14,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	89 1c 24             	mov    %ebx,(%esp)
8010192d:	e8 6e fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101932:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101935:	83 c4 14             	add    $0x14,%esp
80101938:	5b                   	pop    %ebx
80101939:	5d                   	pop    %ebp
  iput(ip);
8010193a:	e9 a1 fe ff ff       	jmp    801017e0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 2c             	sub    $0x2c,%esp
80101979:	8b 45 0c             	mov    0xc(%ebp),%eax
8010197c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010197f:	8b 75 10             	mov    0x10(%ebp),%esi
80101982:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101985:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101988:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010198d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101990:	0f 84 aa 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101996:	8b 47 58             	mov    0x58(%edi),%eax
80101999:	39 f0                	cmp    %esi,%eax
8010199b:	0f 82 c7 00 00 00    	jb     80101a68 <readi+0xf8>
801019a1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019a4:	89 da                	mov    %ebx,%edx
801019a6:	01 f2                	add    %esi,%edx
801019a8:	0f 82 ba 00 00 00    	jb     80101a68 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ae:	89 c1                	mov    %eax,%ecx
801019b0:	29 f1                	sub    %esi,%ecx
801019b2:	39 d0                	cmp    %edx,%eax
801019b4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b7:	31 c0                	xor    %eax,%eax
801019b9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019bb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019be:	74 70                	je     80101a30 <readi+0xc0>
801019c0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019c3:	89 c7                	mov    %eax,%edi
801019c5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019cb:	89 f2                	mov    %esi,%edx
801019cd:	c1 ea 09             	shr    $0x9,%edx
801019d0:	89 d8                	mov    %ebx,%eax
801019d2:	e8 09 f9 ff ff       	call   801012e0 <bmap>
801019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019db:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019dd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e2:	89 04 24             	mov    %eax,(%esp)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019ed:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ef:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019f1:	89 f0                	mov    %esi,%eax
801019f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fa:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019fe:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a0e:	01 df                	add    %ebx,%edi
80101a10:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a15:	89 04 24             	mov    %eax,(%esp)
80101a18:	e8 13 29 00 00       	call   80104330 <memmove>
    brelse(bp);
80101a1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a20:	89 14 24             	mov    %edx,(%esp)
80101a23:	e8 b8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a28:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a2e:	77 98                	ja     801019c8 <readi+0x58>
  }
  return n;
80101a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a33:	83 c4 2c             	add    $0x2c,%esp
80101a36:	5b                   	pop    %ebx
80101a37:	5e                   	pop    %esi
80101a38:	5f                   	pop    %edi
80101a39:	5d                   	pop    %ebp
80101a3a:	c3                   	ret    
80101a3b:	90                   	nop
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 1e                	ja     80101a68 <readi+0xf8>
80101a4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 13                	je     80101a68 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a58:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a5b:	83 c4 2c             	add    $0x2c,%esp
80101a5e:	5b                   	pop    %ebx
80101a5f:	5e                   	pop    %esi
80101a60:	5f                   	pop    %edi
80101a61:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a62:	ff e0                	jmp    *%eax
80101a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a6d:	eb c4                	jmp    80101a33 <readi+0xc3>
80101a6f:	90                   	nop

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 2c             	sub    $0x2c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a90:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 e3 00 00 00    	jb     80101b88 <writei+0x118>
80101aa5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aa8:	89 c8                	mov    %ecx,%eax
80101aaa:	01 f0                	add    %esi,%eax
80101aac:	0f 82 d6 00 00 00    	jb     80101b88 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab7:	0f 87 cb 00 00 00    	ja     80101b88 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101abd:	85 c9                	test   %ecx,%ecx
80101abf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ac6:	74 77                	je     80101b3f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101acb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101acd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad2:	c1 ea 09             	shr    $0x9,%edx
80101ad5:	89 f8                	mov    %edi,%eax
80101ad7:	e8 04 f8 ff ff       	call   801012e0 <bmap>
80101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ae0:	8b 07                	mov    (%edi),%eax
80101ae2:	89 04 24             	mov    %eax,(%esp)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aed:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af5:	89 f0                	mov    %esi,%eax
80101af7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afc:	29 c3                	sub    %eax,%ebx
80101afe:	39 cb                	cmp    %ecx,%ebx
80101b00:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b07:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b09:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b0d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b11:	89 04 24             	mov    %eax,(%esp)
80101b14:	e8 17 28 00 00       	call   80104330 <memmove>
    log_write(bp);
80101b19:	89 3c 24             	mov    %edi,(%esp)
80101b1c:	e8 9f 11 00 00       	call   80102cc0 <log_write>
    brelse(bp);
80101b21:	89 3c 24             	mov    %edi,(%esp)
80101b24:	e8 b7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b29:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b2f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b32:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b35:	77 91                	ja     80101ac8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b37:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b3d:	72 39                	jb     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b42:	83 c4 2c             	add    $0x2c,%esp
80101b45:	5b                   	pop    %ebx
80101b46:	5e                   	pop    %esi
80101b47:	5f                   	pop    %edi
80101b48:	5d                   	pop    %ebp
80101b49:	c3                   	ret    
80101b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 2e                	ja     80101b88 <writei+0x118>
80101b5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 23                	je     80101b88 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b68:	83 c4 2c             	add    $0x2c,%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b7e:	89 04 24             	mov    %eax,(%esp)
80101b81:	e8 7a fa ff ff       	call   80101600 <iupdate>
80101b86:	eb b7                	jmp    80101b3f <writei+0xcf>
}
80101b88:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101b90:	5b                   	pop    %ebx
80101b91:	5e                   	pop    %esi
80101b92:	5f                   	pop    %edi
80101b93:	5d                   	pop    %ebp
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bb0:	00 
80101bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb8:	89 04 24             	mov    %eax,(%esp)
80101bbb:	e8 f0 27 00 00       	call   801043b0 <strncmp>
}
80101bc0:	c9                   	leave  
80101bc1:	c3                   	ret    
80101bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 2c             	sub    $0x2c,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101be1:	0f 85 97 00 00 00    	jne    80101c7e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101be7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bea:	31 ff                	xor    %edi,%edi
80101bec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bef:	85 d2                	test   %edx,%edx
80101bf1:	75 0d                	jne    80101c00 <dirlookup+0x30>
80101bf3:	eb 73                	jmp    80101c68 <dirlookup+0x98>
80101bf5:	8d 76 00             	lea    0x0(%esi),%esi
80101bf8:	83 c7 10             	add    $0x10,%edi
80101bfb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bfe:	76 68                	jbe    80101c68 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c00:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c07:	00 
80101c08:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c0c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c10:	89 1c 24             	mov    %ebx,(%esp)
80101c13:	e8 58 fd ff ff       	call   80101970 <readi>
80101c18:	83 f8 10             	cmp    $0x10,%eax
80101c1b:	75 55                	jne    80101c72 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c1d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c22:	74 d4                	je     80101bf8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c27:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c2e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c35:	00 
80101c36:	89 04 24             	mov    %eax,(%esp)
80101c39:	e8 72 27 00 00       	call   801043b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c3e:	85 c0                	test   %eax,%eax
80101c40:	75 b6                	jne    80101bf8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c42:	8b 45 10             	mov    0x10(%ebp),%eax
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 05                	je     80101c4e <dirlookup+0x7e>
        *poff = off;
80101c49:	8b 45 10             	mov    0x10(%ebp),%eax
80101c4c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c4e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c52:	8b 03                	mov    (%ebx),%eax
80101c54:	e8 c7 f5 ff ff       	call   80101220 <iget>
    }
  }

  return 0;
}
80101c59:	83 c4 2c             	add    $0x2c,%esp
80101c5c:	5b                   	pop    %ebx
80101c5d:	5e                   	pop    %esi
80101c5e:	5f                   	pop    %edi
80101c5f:	5d                   	pop    %ebp
80101c60:	c3                   	ret    
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c68:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c6b:	31 c0                	xor    %eax,%eax
}
80101c6d:	5b                   	pop    %ebx
80101c6e:	5e                   	pop    %esi
80101c6f:	5f                   	pop    %edi
80101c70:	5d                   	pop    %ebp
80101c71:	c3                   	ret    
      panic("dirlookup read");
80101c72:	c7 04 24 b8 6f 10 80 	movl   $0x80106fb8,(%esp)
80101c79:	e8 e2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c7e:	c7 04 24 a6 6f 10 80 	movl   $0x80106fa6,(%esp)
80101c85:	e8 d6 e6 ff ff       	call   80100360 <panic>
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	89 cf                	mov    %ecx,%edi
80101c96:	56                   	push   %esi
80101c97:	53                   	push   %ebx
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ca3:	0f 84 51 01 00 00    	je     80101dfa <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca9:	e8 02 1a 00 00       	call   801036b0 <myproc>
80101cae:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb8:	e8 93 24 00 00       	call   80104150 <acquire>
  ip->ref++;
80101cbd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cc8:	e8 73 25 00 00       	call   80104240 <release>
80101ccd:	eb 04                	jmp    80101cd3 <namex+0x43>
80101ccf:	90                   	nop
    path++;
80101cd0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cd3:	0f b6 03             	movzbl (%ebx),%eax
80101cd6:	3c 2f                	cmp    $0x2f,%al
80101cd8:	74 f6                	je     80101cd0 <namex+0x40>
  if(*path == 0)
80101cda:	84 c0                	test   %al,%al
80101cdc:	0f 84 ed 00 00 00    	je     80101dcf <namex+0x13f>
  while(*path != '/' && *path != 0)
80101ce2:	0f b6 03             	movzbl (%ebx),%eax
80101ce5:	89 da                	mov    %ebx,%edx
80101ce7:	84 c0                	test   %al,%al
80101ce9:	0f 84 b1 00 00 00    	je     80101da0 <namex+0x110>
80101cef:	3c 2f                	cmp    $0x2f,%al
80101cf1:	75 0f                	jne    80101d02 <namex+0x72>
80101cf3:	e9 a8 00 00 00       	jmp    80101da0 <namex+0x110>
80101cf8:	3c 2f                	cmp    $0x2f,%al
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d00:	74 0a                	je     80101d0c <namex+0x7c>
    path++;
80101d02:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d05:	0f b6 02             	movzbl (%edx),%eax
80101d08:	84 c0                	test   %al,%al
80101d0a:	75 ec                	jne    80101cf8 <namex+0x68>
80101d0c:	89 d1                	mov    %edx,%ecx
80101d0e:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d10:	83 f9 0d             	cmp    $0xd,%ecx
80101d13:	0f 8e 8f 00 00 00    	jle    80101da8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d1d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d24:	00 
80101d25:	89 3c 24             	mov    %edi,(%esp)
80101d28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d2b:	e8 00 26 00 00       	call   80104330 <memmove>
    path++;
80101d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d33:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d35:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d38:	75 0e                	jne    80101d48 <namex+0xb8>
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d48:	89 34 24             	mov    %esi,(%esp)
80101d4b:	e8 70 f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d50:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d55:	0f 85 85 00 00 00    	jne    80101de0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d5e:	85 d2                	test   %edx,%edx
80101d60:	74 09                	je     80101d6b <namex+0xdb>
80101d62:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d65:	0f 84 a5 00 00 00    	je     80101e10 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d72:	00 
80101d73:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d77:	89 34 24             	mov    %esi,(%esp)
80101d7a:	e8 51 fe ff ff       	call   80101bd0 <dirlookup>
80101d7f:	85 c0                	test   %eax,%eax
80101d81:	74 5d                	je     80101de0 <namex+0x150>
  iunlock(ip);
80101d83:	89 34 24             	mov    %esi,(%esp)
80101d86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d89:	e8 12 fa ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	89 c6                	mov    %eax,%esi
80101d9b:	e9 33 ff ff ff       	jmp    80101cd3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101da0:	31 c9                	xor    %ecx,%ecx
80101da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101da8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101db0:	89 3c 24             	mov    %edi,(%esp)
80101db3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db9:	e8 72 25 00 00       	call   80104330 <memmove>
    name[len] = 0;
80101dbe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dc8:	89 d3                	mov    %edx,%ebx
80101dca:	e9 66 ff ff ff       	jmp    80101d35 <namex+0xa5>
  }
  if(nameiparent){
80101dcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dd2:	85 c0                	test   %eax,%eax
80101dd4:	75 4c                	jne    80101e22 <namex+0x192>
80101dd6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd8:	83 c4 2c             	add    $0x2c,%esp
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
  iunlock(ip);
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 b8 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101de8:	89 34 24             	mov    %esi,(%esp)
80101deb:	e8 f0 f9 ff ff       	call   801017e0 <iput>
}
80101df0:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101df3:	31 c0                	xor    %eax,%eax
}
80101df5:	5b                   	pop    %ebx
80101df6:	5e                   	pop    %esi
80101df7:	5f                   	pop    %edi
80101df8:	5d                   	pop    %ebp
80101df9:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dfa:	ba 01 00 00 00       	mov    $0x1,%edx
80101dff:	b8 01 00 00 00       	mov    $0x1,%eax
80101e04:	e8 17 f4 ff ff       	call   80101220 <iget>
80101e09:	89 c6                	mov    %eax,%esi
80101e0b:	e9 c3 fe ff ff       	jmp    80101cd3 <namex+0x43>
      iunlock(ip);
80101e10:	89 34 24             	mov    %esi,(%esp)
80101e13:	e8 88 f9 ff ff       	call   801017a0 <iunlock>
}
80101e18:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e1b:	89 f0                	mov    %esi,%eax
}
80101e1d:	5b                   	pop    %ebx
80101e1e:	5e                   	pop    %esi
80101e1f:	5f                   	pop    %edi
80101e20:	5d                   	pop    %ebp
80101e21:	c3                   	ret    
    iput(ip);
80101e22:	89 34 24             	mov    %esi,(%esp)
80101e25:	e8 b6 f9 ff ff       	call   801017e0 <iput>
    return 0;
80101e2a:	31 c0                	xor    %eax,%eax
80101e2c:	eb aa                	jmp    80101dd8 <namex+0x148>
80101e2e:	66 90                	xchg   %ax,%ax

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 2c             	sub    $0x2c,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e46:	00 
80101e47:	89 1c 24             	mov    %ebx,(%esp)
80101e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e4e:	e8 7d fd ff ff       	call   80101bd0 <dirlookup>
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 8b 00 00 00    	jne    80101ee6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e5b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e5e:	31 ff                	xor    %edi,%edi
80101e60:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e63:	85 c0                	test   %eax,%eax
80101e65:	75 13                	jne    80101e7a <dirlink+0x4a>
80101e67:	eb 35                	jmp    80101e9e <dirlink+0x6e>
80101e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e70:	8d 57 10             	lea    0x10(%edi),%edx
80101e73:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e76:	89 d7                	mov    %edx,%edi
80101e78:	76 24                	jbe    80101e9e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e7a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e81:	00 
80101e82:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e86:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e8a:	89 1c 24             	mov    %ebx,(%esp)
80101e8d:	e8 de fa ff ff       	call   80101970 <readi>
80101e92:	83 f8 10             	cmp    $0x10,%eax
80101e95:	75 5e                	jne    80101ef5 <dirlink+0xc5>
    if(de.inum == 0)
80101e97:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9c:	75 d2                	jne    80101e70 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ea8:	00 
80101ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ead:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb0:	89 04 24             	mov    %eax,(%esp)
80101eb3:	e8 68 25 00 00       	call   80104420 <strncpy>
  de.inum = inum;
80101eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ebb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ec2:	00 
80101ec3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ec7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ecb:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101ece:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ed2:	e8 99 fb ff ff       	call   80101a70 <writei>
80101ed7:	83 f8 10             	cmp    $0x10,%eax
80101eda:	75 25                	jne    80101f01 <dirlink+0xd1>
  return 0;
80101edc:	31 c0                	xor    %eax,%eax
}
80101ede:	83 c4 2c             	add    $0x2c,%esp
80101ee1:	5b                   	pop    %ebx
80101ee2:	5e                   	pop    %esi
80101ee3:	5f                   	pop    %edi
80101ee4:	5d                   	pop    %ebp
80101ee5:	c3                   	ret    
    iput(ip);
80101ee6:	89 04 24             	mov    %eax,(%esp)
80101ee9:	e8 f2 f8 ff ff       	call   801017e0 <iput>
    return -1;
80101eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef3:	eb e9                	jmp    80101ede <dirlink+0xae>
      panic("dirlink read");
80101ef5:	c7 04 24 c7 6f 10 80 	movl   $0x80106fc7,(%esp)
80101efc:	e8 5f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101f01:	c7 04 24 c6 75 10 80 	movl   $0x801075c6,(%esp)
80101f08:	e8 53 e4 ff ff       	call   80100360 <panic>
80101f0d:	8d 76 00             	lea    0x0(%esi),%esi

80101f10 <namei>:

struct inode*
namei(char *path)
{
80101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f11:	31 d2                	xor    %edx,%edx
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f30:	55                   	push   %ebp
  return namex(path, 1, name);
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f36:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f3e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
80101f44:	66 90                	xchg   %ax,%ax
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	66 90                	xchg   %ax,%ax
80101f4a:	66 90                	xchg   %ax,%ax
80101f4c:	66 90                	xchg   %ax,%ax
80101f4e:	66 90                	xchg   %ax,%ax

80101f50 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	56                   	push   %esi
80101f54:	89 c6                	mov    %eax,%esi
80101f56:	53                   	push   %ebx
80101f57:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f5a:	85 c0                	test   %eax,%eax
80101f5c:	0f 84 99 00 00 00    	je     80101ffb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f62:	8b 48 08             	mov    0x8(%eax),%ecx
80101f65:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f6b:	0f 87 7e 00 00 00    	ja     80101fef <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f71:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f76:	66 90                	xchg   %ax,%ax
80101f78:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f79:	83 e0 c0             	and    $0xffffffc0,%eax
80101f7c:	3c 40                	cmp    $0x40,%al
80101f7e:	75 f8                	jne    80101f78 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f80:	31 db                	xor    %ebx,%ebx
80101f82:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ee                   	out    %al,(%dx)
80101f8a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f8f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f94:	ee                   	out    %al,(%dx)
80101f95:	0f b6 c1             	movzbl %cl,%eax
80101f98:	b2 f3                	mov    $0xf3,%dl
80101f9a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f9b:	89 c8                	mov    %ecx,%eax
80101f9d:	b2 f4                	mov    $0xf4,%dl
80101f9f:	c1 f8 08             	sar    $0x8,%eax
80101fa2:	ee                   	out    %al,(%dx)
80101fa3:	b2 f5                	mov    $0xf5,%dl
80101fa5:	89 d8                	mov    %ebx,%eax
80101fa7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fa8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fac:	b2 f6                	mov    $0xf6,%dl
80101fae:	83 e0 01             	and    $0x1,%eax
80101fb1:	c1 e0 04             	shl    $0x4,%eax
80101fb4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fb7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fb8:	f6 06 04             	testb  $0x4,(%esi)
80101fbb:	75 13                	jne    80101fd0 <idestart+0x80>
80101fbd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fc2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fc7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
80101fcf:	90                   	nop
80101fd0:	b2 f7                	mov    $0xf7,%dl
80101fd2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fd7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fd8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fdd:	83 c6 5c             	add    $0x5c,%esi
80101fe0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fe5:	fc                   	cld    
80101fe6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
    panic("incorrect blockno");
80101fef:	c7 04 24 30 70 10 80 	movl   $0x80107030,(%esp)
80101ff6:	e8 65 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
80101ffb:	c7 04 24 27 70 10 80 	movl   $0x80107027,(%esp)
80102002:	e8 59 e3 ff ff       	call   80100360 <panic>
80102007:	89 f6                	mov    %esi,%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102016:	c7 44 24 04 42 70 10 	movl   $0x80107042,0x4(%esp)
8010201d:	80 
8010201e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102025:	e8 36 20 00 00       	call   80104060 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010202a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010202f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102036:	83 e8 01             	sub    $0x1,%eax
80102039:	89 44 24 04          	mov    %eax,0x4(%esp)
8010203d:	e8 7e 02 00 00       	call   801022c0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102042:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102047:	90                   	nop
80102048:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102049:	83 e0 c0             	and    $0xffffffc0,%eax
8010204c:	3c 40                	cmp    $0x40,%al
8010204e:	75 f8                	jne    80102048 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102050:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102055:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010205a:	ee                   	out    %al,(%dx)
8010205b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102060:	b2 f7                	mov    $0xf7,%dl
80102062:	eb 09                	jmp    8010206d <ideinit+0x5d>
80102064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102068:	83 e9 01             	sub    $0x1,%ecx
8010206b:	74 0f                	je     8010207c <ideinit+0x6c>
8010206d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010206e:	84 c0                	test   %al,%al
80102070:	74 f6                	je     80102068 <ideinit+0x58>
      havedisk1 = 1;
80102072:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102079:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010207c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102081:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102086:	ee                   	out    %al,(%dx)
}
80102087:	c9                   	leave  
80102088:	c3                   	ret    
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020a0:	e8 ab 20 00 00       	call   80104150 <acquire>

  if((b = idequeue) == 0){
801020a5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020ab:	85 db                	test   %ebx,%ebx
801020ad:	74 30                	je     801020df <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020af:	8b 43 58             	mov    0x58(%ebx),%eax
801020b2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b7:	8b 33                	mov    (%ebx),%esi
801020b9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020bf:	74 37                	je     801020f8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020c1:	83 e6 fb             	and    $0xfffffffb,%esi
801020c4:	83 ce 02             	or     $0x2,%esi
801020c7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020c9:	89 1c 24             	mov    %ebx,(%esp)
801020cc:	e8 cf 1c 00 00       	call   80103da0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020d6:	85 c0                	test   %eax,%eax
801020d8:	74 05                	je     801020df <ideintr+0x4f>
    idestart(idequeue);
801020da:	e8 71 fe ff ff       	call   80101f50 <idestart>
    release(&idelock);
801020df:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020e6:	e8 55 21 00 00       	call   80104240 <release>

  release(&idelock);
}
801020eb:	83 c4 1c             	add    $0x1c,%esp
801020ee:	5b                   	pop    %ebx
801020ef:	5e                   	pop    %esi
801020f0:	5f                   	pop    %edi
801020f1:	5d                   	pop    %ebp
801020f2:	c3                   	ret    
801020f3:	90                   	nop
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020fd:	8d 76 00             	lea    0x0(%esi),%esi
80102100:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	89 c1                	mov    %eax,%ecx
80102103:	83 e1 c0             	and    $0xffffffc0,%ecx
80102106:	80 f9 40             	cmp    $0x40,%cl
80102109:	75 f5                	jne    80102100 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010210b:	a8 21                	test   $0x21,%al
8010210d:	75 b2                	jne    801020c1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
8010210f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102112:	b9 80 00 00 00       	mov    $0x80,%ecx
80102117:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211c:	fc                   	cld    
8010211d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010211f:	8b 33                	mov    (%ebx),%esi
80102121:	eb 9e                	jmp    801020c1 <ideintr+0x31>
80102123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 14             	sub    $0x14,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	89 04 24             	mov    %eax,(%esp)
80102140:	e8 eb 1e 00 00       	call   80104030 <holdingsleep>
80102145:	85 c0                	test   %eax,%eax
80102147:	0f 84 9e 00 00 00    	je     801021eb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214d:	8b 03                	mov    (%ebx),%eax
8010214f:	83 e0 06             	and    $0x6,%eax
80102152:	83 f8 02             	cmp    $0x2,%eax
80102155:	0f 84 a8 00 00 00    	je     80102203 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215b:	8b 53 04             	mov    0x4(%ebx),%edx
8010215e:	85 d2                	test   %edx,%edx
80102160:	74 0d                	je     8010216f <iderw+0x3f>
80102162:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102167:	85 c0                	test   %eax,%eax
80102169:	0f 84 88 00 00 00    	je     801021f7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010216f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102176:	e8 d5 1f 00 00       	call   80104150 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102180:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102187:	85 c0                	test   %eax,%eax
80102189:	75 07                	jne    80102192 <iderw+0x62>
8010218b:	eb 4e                	jmp    801021db <iderw+0xab>
8010218d:	8d 76 00             	lea    0x0(%esi),%esi
80102190:	89 d0                	mov    %edx,%eax
80102192:	8b 50 58             	mov    0x58(%eax),%edx
80102195:	85 d2                	test   %edx,%edx
80102197:	75 f7                	jne    80102190 <iderw+0x60>
80102199:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010219c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010219e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021a4:	74 3c                	je     801021e2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a6:	8b 03                	mov    (%ebx),%eax
801021a8:	83 e0 06             	and    $0x6,%eax
801021ab:	83 f8 02             	cmp    $0x2,%eax
801021ae:	74 1a                	je     801021ca <iderw+0x9a>
    sleep(b, &idelock);
801021b0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021b7:	80 
801021b8:	89 1c 24             	mov    %ebx,(%esp)
801021bb:	e8 50 1a 00 00       	call   80103c10 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021c0:	8b 13                	mov    (%ebx),%edx
801021c2:	83 e2 06             	and    $0x6,%edx
801021c5:	83 fa 02             	cmp    $0x2,%edx
801021c8:	75 e6                	jne    801021b0 <iderw+0x80>
  }


  release(&idelock);
801021ca:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021d1:	83 c4 14             	add    $0x14,%esp
801021d4:	5b                   	pop    %ebx
801021d5:	5d                   	pop    %ebp
  release(&idelock);
801021d6:	e9 65 20 00 00       	jmp    80104240 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021db:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021e0:	eb ba                	jmp    8010219c <iderw+0x6c>
    idestart(b);
801021e2:	89 d8                	mov    %ebx,%eax
801021e4:	e8 67 fd ff ff       	call   80101f50 <idestart>
801021e9:	eb bb                	jmp    801021a6 <iderw+0x76>
    panic("iderw: buf not locked");
801021eb:	c7 04 24 46 70 10 80 	movl   $0x80107046,(%esp)
801021f2:	e8 69 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801021f7:	c7 04 24 71 70 10 80 	movl   $0x80107071,(%esp)
801021fe:	e8 5d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102203:	c7 04 24 5c 70 10 80 	movl   $0x8010705c,(%esp)
8010220a:	e8 51 e1 ff ff       	call   80100360 <panic>
8010220f:	90                   	nop

80102210 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	56                   	push   %esi
80102214:	53                   	push   %ebx
80102215:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102218:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010221f:	00 c0 fe 
  ioapic->reg = reg;
80102222:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102229:	00 00 00 
  return ioapic->data;
8010222c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102232:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102235:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010223b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102241:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102248:	c1 e8 10             	shr    $0x10,%eax
8010224b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010224e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102251:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102254:	39 c2                	cmp    %eax,%edx
80102256:	74 12                	je     8010226a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102258:	c7 04 24 90 70 10 80 	movl   $0x80107090,(%esp)
8010225f:	e8 ec e3 ff ff       	call   80100650 <cprintf>
80102264:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010226a:	ba 10 00 00 00       	mov    $0x10,%edx
8010226f:	31 c0                	xor    %eax,%eax
80102271:	eb 07                	jmp    8010227a <ioapicinit+0x6a>
80102273:	90                   	nop
80102274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102278:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010227a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010227c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102282:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102285:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010228b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010228e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102291:	8d 4a 01             	lea    0x1(%edx),%ecx
80102294:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102297:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102299:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010229f:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
801022a1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022a8:	7d ce                	jge    80102278 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	5b                   	pop    %ebx
801022ae:	5e                   	pop    %esi
801022af:	5d                   	pop    %ebp
801022b0:	c3                   	ret    
801022b1:	eb 0d                	jmp    801022c0 <ioapicenable>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	8b 55 08             	mov    0x8(%ebp),%edx
801022c6:	53                   	push   %ebx
801022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ca:	8d 5a 20             	lea    0x20(%edx),%ebx
801022cd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022d1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022da:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022dc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022e5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022e8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ea:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022f0:	89 42 10             	mov    %eax,0x10(%edx)
}
801022f3:	5b                   	pop    %ebx
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
801022f6:	66 90                	xchg   %ax,%ax
801022f8:	66 90                	xchg   %ax,%ax
801022fa:	66 90                	xchg   %ax,%ax
801022fc:	66 90                	xchg   %ax,%ax
801022fe:	66 90                	xchg   %ax,%ax

80102300 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 14             	sub    $0x14,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010230a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102310:	75 7c                	jne    8010238e <kfree+0x8e>
80102312:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
80102318:	72 74                	jb     8010238e <kfree+0x8e>
8010231a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102320:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102325:	77 67                	ja     8010238e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102327:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010232e:	00 
8010232f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102336:	00 
80102337:	89 1c 24             	mov    %ebx,(%esp)
8010233a:	e8 51 1f 00 00       	call   80104290 <memset>

  if(kmem.use_lock)
8010233f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102345:	85 d2                	test   %edx,%edx
80102347:	75 37                	jne    80102380 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102349:	a1 78 26 11 80       	mov    0x80112678,%eax
8010234e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102350:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102355:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010235b:	85 c0                	test   %eax,%eax
8010235d:	75 09                	jne    80102368 <kfree+0x68>
    release(&kmem.lock);
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
80102364:	c3                   	ret    
80102365:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102368:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010236f:	83 c4 14             	add    $0x14,%esp
80102372:	5b                   	pop    %ebx
80102373:	5d                   	pop    %ebp
    release(&kmem.lock);
80102374:	e9 c7 1e 00 00       	jmp    80104240 <release>
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102380:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102387:	e8 c4 1d 00 00       	call   80104150 <acquire>
8010238c:	eb bb                	jmp    80102349 <kfree+0x49>
    panic("kfree");
8010238e:	c7 04 24 c2 70 10 80 	movl   $0x801070c2,(%esp)
80102395:	e8 c6 df ff ff       	call   80100360 <panic>
8010239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801023a8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ba:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023c0:	39 de                	cmp    %ebx,%esi
801023c2:	73 08                	jae    801023cc <freerange+0x2c>
801023c4:	eb 18                	jmp    801023de <freerange+0x3e>
801023c6:	66 90                	xchg   %ax,%ax
801023c8:	89 da                	mov    %ebx,%edx
801023ca:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023cc:	89 14 24             	mov    %edx,(%esp)
801023cf:	e8 2c ff ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023da:	39 f0                	cmp    %esi,%eax
801023dc:	76 ea                	jbe    801023c8 <freerange+0x28>
}
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	5b                   	pop    %ebx
801023e2:	5e                   	pop    %esi
801023e3:	5d                   	pop    %ebp
801023e4:	c3                   	ret    
801023e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	83 ec 10             	sub    $0x10,%esp
801023f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023fb:	c7 44 24 04 c8 70 10 	movl   $0x801070c8,0x4(%esp)
80102402:	80 
80102403:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010240a:	e8 51 1c 00 00       	call   80104060 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240f:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102412:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102419:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102422:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102428:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010242e:	39 de                	cmp    %ebx,%esi
80102430:	73 0a                	jae    8010243c <kinit1+0x4c>
80102432:	eb 1a                	jmp    8010244e <kinit1+0x5e>
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102438:	89 da                	mov    %ebx,%edx
8010243a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010243c:	89 14 24             	mov    %edx,(%esp)
8010243f:	e8 bc fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102444:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010244a:	39 c6                	cmp    %eax,%esi
8010244c:	73 ea                	jae    80102438 <kinit1+0x48>
}
8010244e:	83 c4 10             	add    $0x10,%esp
80102451:	5b                   	pop    %ebx
80102452:	5e                   	pop    %esi
80102453:	5d                   	pop    %ebp
80102454:	c3                   	ret    
80102455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102468:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010246b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102474:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102480:	39 de                	cmp    %ebx,%esi
80102482:	73 08                	jae    8010248c <kinit2+0x2c>
80102484:	eb 18                	jmp    8010249e <kinit2+0x3e>
80102486:	66 90                	xchg   %ax,%ax
80102488:	89 da                	mov    %ebx,%edx
8010248a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010248c:	89 14 24             	mov    %edx,(%esp)
8010248f:	e8 6c fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102494:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010249a:	39 c6                	cmp    %eax,%esi
8010249c:	73 ea                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
8010249e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024a5:	00 00 00 
}
801024a8:	83 c4 10             	add    $0x10,%esp
801024ab:	5b                   	pop    %ebx
801024ac:	5e                   	pop    %esi
801024ad:	5d                   	pop    %ebp
801024ae:	c3                   	ret    
801024af:	90                   	nop

801024b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	53                   	push   %ebx
801024b4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024bc:	85 c0                	test   %eax,%eax
801024be:	75 30                	jne    801024f0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024c6:	85 db                	test   %ebx,%ebx
801024c8:	74 08                	je     801024d2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ca:	8b 13                	mov    (%ebx),%edx
801024cc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024d2:	85 c0                	test   %eax,%eax
801024d4:	74 0c                	je     801024e2 <kalloc+0x32>
    release(&kmem.lock);
801024d6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024dd:	e8 5e 1d 00 00       	call   80104240 <release>
  return (char*)r;
}
801024e2:	83 c4 14             	add    $0x14,%esp
801024e5:	89 d8                	mov    %ebx,%eax
801024e7:	5b                   	pop    %ebx
801024e8:	5d                   	pop    %ebp
801024e9:	c3                   	ret    
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024f0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024f7:	e8 54 1c 00 00       	call   80104150 <acquire>
801024fc:	a1 74 26 11 80       	mov    0x80112674,%eax
80102501:	eb bd                	jmp    801024c0 <kalloc+0x10>
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102510:	ba 64 00 00 00       	mov    $0x64,%edx
80102515:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102516:	a8 01                	test   $0x1,%al
80102518:	0f 84 ba 00 00 00    	je     801025d8 <kbdgetc+0xc8>
8010251e:	b2 60                	mov    $0x60,%dl
80102520:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102521:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102524:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010252a:	0f 84 88 00 00 00    	je     801025b8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102530:	84 c0                	test   %al,%al
80102532:	79 2c                	jns    80102560 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102534:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010253a:	f6 c2 40             	test   $0x40,%dl
8010253d:	75 05                	jne    80102544 <kbdgetc+0x34>
8010253f:	89 c1                	mov    %eax,%ecx
80102541:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102544:	0f b6 81 00 72 10 80 	movzbl -0x7fef8e00(%ecx),%eax
8010254b:	83 c8 40             	or     $0x40,%eax
8010254e:	0f b6 c0             	movzbl %al,%eax
80102551:	f7 d0                	not    %eax
80102553:	21 d0                	and    %edx,%eax
80102555:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010255a:	31 c0                	xor    %eax,%eax
8010255c:	c3                   	ret    
8010255d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	53                   	push   %ebx
80102564:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010256a:	f6 c3 40             	test   $0x40,%bl
8010256d:	74 09                	je     80102578 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102572:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102575:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102578:	0f b6 91 00 72 10 80 	movzbl -0x7fef8e00(%ecx),%edx
  shift ^= togglecode[data];
8010257f:	0f b6 81 00 71 10 80 	movzbl -0x7fef8f00(%ecx),%eax
  shift |= shiftcode[data];
80102586:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102588:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010258a:	89 d0                	mov    %edx,%eax
8010258c:	83 e0 03             	and    $0x3,%eax
8010258f:	8b 04 85 e0 70 10 80 	mov    -0x7fef8f20(,%eax,4),%eax
  shift ^= togglecode[data];
80102596:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
8010259c:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010259f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025a3:	74 0b                	je     801025b0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025a5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a8:	83 fa 19             	cmp    $0x19,%edx
801025ab:	77 1b                	ja     801025c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025ad:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b0:	5b                   	pop    %ebx
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret    
801025b3:	90                   	nop
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025b8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025bf:	31 c0                	xor    %eax,%eax
801025c1:	c3                   	ret    
801025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025cb:	8d 50 20             	lea    0x20(%eax),%edx
801025ce:	83 f9 19             	cmp    $0x19,%ecx
801025d1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025d4:	eb da                	jmp    801025b0 <kbdgetc+0xa0>
801025d6:	66 90                	xchg   %ax,%ax
    return -1;
801025d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax

801025e0 <kbdintr>:

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025e6:	c7 04 24 10 25 10 80 	movl   $0x80102510,(%esp)
801025ed:	e8 be e1 ff ff       	call   801007b0 <consoleintr>
}
801025f2:	c9                   	leave  
801025f3:	c3                   	ret    
801025f4:	66 90                	xchg   %ax,%ax
801025f6:	66 90                	xchg   %ax,%ax
801025f8:	66 90                	xchg   %ax,%ax
801025fa:	66 90                	xchg   %ax,%ax
801025fc:	66 90                	xchg   %ax,%ax
801025fe:	66 90                	xchg   %ax,%ax

80102600 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102600:	55                   	push   %ebp
80102601:	89 c1                	mov    %eax,%ecx
80102603:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102605:	ba 70 00 00 00       	mov    $0x70,%edx
8010260a:	53                   	push   %ebx
8010260b:	31 c0                	xor    %eax,%eax
8010260d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010260e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102616:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 01                	mov    %eax,(%ecx)
8010261d:	b8 02 00 00 00       	mov    $0x2,%eax
80102622:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102623:	89 da                	mov    %ebx,%edx
80102625:	ec                   	in     (%dx),%al
80102626:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102629:	b2 70                	mov    $0x70,%dl
8010262b:	89 41 04             	mov    %eax,0x4(%ecx)
8010262e:	b8 04 00 00 00       	mov    $0x4,%eax
80102633:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102634:	89 da                	mov    %ebx,%edx
80102636:	ec                   	in     (%dx),%al
80102637:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263a:	b2 70                	mov    $0x70,%dl
8010263c:	89 41 08             	mov    %eax,0x8(%ecx)
8010263f:	b8 07 00 00 00       	mov    $0x7,%eax
80102644:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102645:	89 da                	mov    %ebx,%edx
80102647:	ec                   	in     (%dx),%al
80102648:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264b:	b2 70                	mov    $0x70,%dl
8010264d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102650:	b8 08 00 00 00       	mov    $0x8,%eax
80102655:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102656:	89 da                	mov    %ebx,%edx
80102658:	ec                   	in     (%dx),%al
80102659:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265c:	b2 70                	mov    $0x70,%dl
8010265e:	89 41 10             	mov    %eax,0x10(%ecx)
80102661:	b8 09 00 00 00       	mov    $0x9,%eax
80102666:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102667:	89 da                	mov    %ebx,%edx
80102669:	ec                   	in     (%dx),%al
8010266a:	0f b6 d8             	movzbl %al,%ebx
8010266d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102670:	5b                   	pop    %ebx
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <lapicinit>:
  if(!lapic)
80102680:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102688:	85 c0                	test   %eax,%eax
8010268a:	0f 84 c0 00 00 00    	je     80102750 <lapicinit+0xd0>
  lapic[index] = value;
80102690:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102697:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010269d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026aa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026b1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026be:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026cb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026db:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026de:	8b 50 30             	mov    0x30(%eax),%edx
801026e1:	c1 ea 10             	shr    $0x10,%edx
801026e4:	80 fa 03             	cmp    $0x3,%dl
801026e7:	77 6f                	ja     80102758 <lapicinit+0xd8>
  lapic[index] = value;
801026e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102700:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102703:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102710:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102717:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010271d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102724:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102727:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010272a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102731:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102734:	8b 50 20             	mov    0x20(%eax),%edx
80102737:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102738:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010273e:	80 e6 10             	and    $0x10,%dh
80102741:	75 f5                	jne    80102738 <lapicinit+0xb8>
  lapic[index] = value;
80102743:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010274a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102750:	5d                   	pop    %ebp
80102751:	c3                   	ret    
80102752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102758:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010275f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102762:	8b 50 20             	mov    0x20(%eax),%edx
80102765:	eb 82                	jmp    801026e9 <lapicinit+0x69>
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:
  if (!lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0c                	je     80102788 <lapicid+0x18>
  return lapic[ID] >> 24;
8010277c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010277f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102780:	c1 e8 18             	shr    $0x18,%eax
}
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102788:	31 c0                	xor    %eax,%eax
}
8010278a:	5d                   	pop    %ebp
8010278b:	c3                   	ret    
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <lapiceoi>:
  if(lapic)
80102790:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>
  lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:
{
801027c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	ba 70 00 00 00       	mov    $0x70,%edx
801027c6:	89 e5                	mov    %esp,%ebp
801027c8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027da:	b2 71                	mov    $0x71,%dl
801027dc:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027dd:	31 c0                	xor    %eax,%eax
801027df:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027e5:	89 d8                	mov    %ebx,%eax
801027e7:	c1 e8 04             	shr    $0x4,%eax
801027ea:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027f0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
801027f5:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f8:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
801027fb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102801:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102804:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010280b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102811:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102818:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102827:	89 da                	mov    %ebx,%edx
80102829:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010282c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102832:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102835:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010283e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 40 20             	mov    0x20(%eax),%eax
}
80102847:	5b                   	pop    %ebx
80102848:	5d                   	pop    %ebp
80102849:	c3                   	ret    
8010284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102850 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	ba 70 00 00 00       	mov    $0x70,%edx
80102856:	89 e5                	mov    %esp,%ebp
80102858:	b8 0b 00 00 00       	mov    $0xb,%eax
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	b2 71                	mov    $0x71,%dl
80102866:	ec                   	in     (%dx),%al
80102867:	88 45 b7             	mov    %al,-0x49(%ebp)
8010286a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010286d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102871:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102878:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010287d:	89 d8                	mov    %ebx,%eax
8010287f:	e8 7c fd ff ff       	call   80102600 <fill_rtcdate>
80102884:	b8 0a 00 00 00       	mov    $0xa,%eax
80102889:	89 f2                	mov    %esi,%edx
8010288b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	ba 71 00 00 00       	mov    $0x71,%edx
80102891:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102892:	84 c0                	test   %al,%al
80102894:	78 e7                	js     8010287d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102896:	89 f8                	mov    %edi,%eax
80102898:	e8 63 fd ff ff       	call   80102600 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010289d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028a4:	00 
801028a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028a9:	89 1c 24             	mov    %ebx,(%esp)
801028ac:	e8 2f 1a 00 00       	call   801042e0 <memcmp>
801028b1:	85 c0                	test   %eax,%eax
801028b3:	75 c3                	jne    80102878 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028b5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028b9:	75 78                	jne    80102933 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028be:	89 c2                	mov    %eax,%edx
801028c0:	83 e0 0f             	and    $0xf,%eax
801028c3:	c1 ea 04             	shr    $0x4,%edx
801028c6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028c9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028cc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028d2:	89 c2                	mov    %eax,%edx
801028d4:	83 e0 0f             	and    $0xf,%eax
801028d7:	c1 ea 04             	shr    $0x4,%edx
801028da:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028dd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028e6:	89 c2                	mov    %eax,%edx
801028e8:	83 e0 0f             	and    $0xf,%eax
801028eb:	c1 ea 04             	shr    $0x4,%edx
801028ee:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028fa:	89 c2                	mov    %eax,%edx
801028fc:	83 e0 0f             	and    $0xf,%eax
801028ff:	c1 ea 04             	shr    $0x4,%edx
80102902:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102905:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102908:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010290b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010290e:	89 c2                	mov    %eax,%edx
80102910:	83 e0 0f             	and    $0xf,%eax
80102913:	c1 ea 04             	shr    $0x4,%edx
80102916:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102919:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010291f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102922:	89 c2                	mov    %eax,%edx
80102924:	83 e0 0f             	and    $0xf,%eax
80102927:	c1 ea 04             	shr    $0x4,%edx
8010292a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010292d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102930:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102933:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102936:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102939:	89 01                	mov    %eax,(%ecx)
8010293b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010293e:	89 41 04             	mov    %eax,0x4(%ecx)
80102941:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102944:	89 41 08             	mov    %eax,0x8(%ecx)
80102947:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010294a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010294d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102950:	89 41 10             	mov    %eax,0x10(%ecx)
80102953:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102956:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102959:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102960:	83 c4 4c             	add    $0x4c,%esp
80102963:	5b                   	pop    %ebx
80102964:	5e                   	pop    %esi
80102965:	5f                   	pop    %edi
80102966:	5d                   	pop    %ebp
80102967:	c3                   	ret    
80102968:	66 90                	xchg   %ax,%ax
8010296a:	66 90                	xchg   %ax,%ax
8010296c:	66 90                	xchg   %ax,%ax
8010296e:	66 90                	xchg   %ax,%ax

80102970 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	57                   	push   %edi
80102974:	56                   	push   %esi
80102975:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102976:	31 db                	xor    %ebx,%ebx
{
80102978:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010297b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102980:	85 c0                	test   %eax,%eax
80102982:	7e 78                	jle    801029fc <install_trans+0x8c>
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102988:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010298d:	01 d8                	add    %ebx,%eax
8010298f:	83 c0 01             	add    $0x1,%eax
80102992:	89 44 24 04          	mov    %eax,0x4(%esp)
80102996:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010299b:	89 04 24             	mov    %eax,(%esp)
8010299e:	e8 2d d7 ff ff       	call   801000d0 <bread>
801029a3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029a5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
801029ac:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029af:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029b8:	89 04 24             	mov    %eax,(%esp)
801029bb:	e8 10 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029c0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029c7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029c8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ca:	8d 47 5c             	lea    0x5c(%edi),%eax
801029cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029d4:	89 04 24             	mov    %eax,(%esp)
801029d7:	e8 54 19 00 00       	call   80104330 <memmove>
    bwrite(dbuf);  // write dst to disk
801029dc:	89 34 24             	mov    %esi,(%esp)
801029df:	e8 bc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029e4:	89 3c 24             	mov    %edi,(%esp)
801029e7:	e8 f4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029ec:	89 34 24             	mov    %esi,(%esp)
801029ef:	e8 ec d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801029f4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029fa:	7f 8c                	jg     80102988 <install_trans+0x18>
  }
}
801029fc:	83 c4 1c             	add    $0x1c,%esp
801029ff:	5b                   	pop    %ebx
80102a00:	5e                   	pop    %esi
80102a01:	5f                   	pop    %edi
80102a02:	5d                   	pop    %ebp
80102a03:	c3                   	ret    
80102a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	57                   	push   %edi
80102a14:	56                   	push   %esi
80102a15:	53                   	push   %ebx
80102a16:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a19:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a22:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a27:	89 04 24             	mov    %eax,(%esp)
80102a2a:	e8 a1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a2f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a35:	31 d2                	xor    %edx,%edx
80102a37:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a39:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a3b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a3e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a41:	7e 17                	jle    80102a5a <write_head+0x4a>
80102a43:	90                   	nop
80102a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a48:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a4f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a53:	83 c2 01             	add    $0x1,%edx
80102a56:	39 da                	cmp    %ebx,%edx
80102a58:	75 ee                	jne    80102a48 <write_head+0x38>
  }
  bwrite(buf);
80102a5a:	89 3c 24             	mov    %edi,(%esp)
80102a5d:	e8 3e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a62:	89 3c 24             	mov    %edi,(%esp)
80102a65:	e8 76 d7 ff ff       	call   801001e0 <brelse>
}
80102a6a:	83 c4 1c             	add    $0x1c,%esp
80102a6d:	5b                   	pop    %ebx
80102a6e:	5e                   	pop    %esi
80102a6f:	5f                   	pop    %edi
80102a70:	5d                   	pop    %ebp
80102a71:	c3                   	ret    
80102a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a80 <initlog>:
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	56                   	push   %esi
80102a84:	53                   	push   %ebx
80102a85:	83 ec 30             	sub    $0x30,%esp
80102a88:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a8b:	c7 44 24 04 00 73 10 	movl   $0x80107300,0x4(%esp)
80102a92:	80 
80102a93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a9a:	e8 c1 15 00 00       	call   80104060 <initlock>
  readsb(dev, &sb);
80102a9f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa6:	89 1c 24             	mov    %ebx,(%esp)
80102aa9:	e8 f2 e8 ff ff       	call   801013a0 <readsb>
  log.start = sb.logstart;
80102aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ab1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102ab4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102ab7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102ac1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ac7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102acc:	e8 ff d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ad1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102ad3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ad6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ad9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102adb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ae1:	7e 17                	jle    80102afa <initlog+0x7a>
80102ae3:	90                   	nop
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ae8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102aec:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102af3:	83 c2 01             	add    $0x1,%edx
80102af6:	39 da                	cmp    %ebx,%edx
80102af8:	75 ee                	jne    80102ae8 <initlog+0x68>
  brelse(buf);
80102afa:	89 04 24             	mov    %eax,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b02:	e8 69 fe ff ff       	call   80102970 <install_trans>
  log.lh.n = 0;
80102b07:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b0e:	00 00 00 
  write_head(); // clear the log
80102b11:	e8 fa fe ff ff       	call   80102a10 <write_head>
}
80102b16:	83 c4 30             	add    $0x30,%esp
80102b19:	5b                   	pop    %ebx
80102b1a:	5e                   	pop    %esi
80102b1b:	5d                   	pop    %ebp
80102b1c:	c3                   	ret    
80102b1d:	8d 76 00             	lea    0x0(%esi),%esi

80102b20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b26:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b2d:	e8 1e 16 00 00       	call   80104150 <acquire>
80102b32:	eb 18                	jmp    80102b4c <begin_op+0x2c>
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b38:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b3f:	80 
80102b40:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b47:	e8 c4 10 00 00       	call   80103c10 <sleep>
    if(log.committing){
80102b4c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b51:	85 c0                	test   %eax,%eax
80102b53:	75 e3                	jne    80102b38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b55:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b5a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b60:	83 c0 01             	add    $0x1,%eax
80102b63:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b66:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b69:	83 fa 1e             	cmp    $0x1e,%edx
80102b6c:	7f ca                	jg     80102b38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b6e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b75:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b7a:	e8 c1 16 00 00       	call   80104240 <release>
      break;
    }
  }
}
80102b7f:	c9                   	leave  
80102b80:	c3                   	ret    
80102b81:	eb 0d                	jmp    80102b90 <end_op>
80102b83:	90                   	nop
80102b84:	90                   	nop
80102b85:	90                   	nop
80102b86:	90                   	nop
80102b87:	90                   	nop
80102b88:	90                   	nop
80102b89:	90                   	nop
80102b8a:	90                   	nop
80102b8b:	90                   	nop
80102b8c:	90                   	nop
80102b8d:	90                   	nop
80102b8e:	90                   	nop
80102b8f:	90                   	nop

80102b90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	57                   	push   %edi
80102b94:	56                   	push   %esi
80102b95:	53                   	push   %ebx
80102b96:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b99:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ba0:	e8 ab 15 00 00       	call   80104150 <acquire>
  log.outstanding -= 1;
80102ba5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102baa:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102bb0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bb3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102bb5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bba:	0f 85 f3 00 00 00    	jne    80102cb3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bc0:	85 c0                	test   %eax,%eax
80102bc2:	0f 85 cb 00 00 00    	jne    80102c93 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bc8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bcf:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102bd1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bd8:	00 00 00 
  release(&log.lock);
80102bdb:	e8 60 16 00 00       	call   80104240 <release>
  if (log.lh.n > 0) {
80102be0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102be5:	85 c0                	test   %eax,%eax
80102be7:	0f 8e 90 00 00 00    	jle    80102c7d <end_op+0xed>
80102bed:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bf0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bf5:	01 d8                	add    %ebx,%eax
80102bf7:	83 c0 01             	add    $0x1,%eax
80102bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bfe:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c03:	89 04 24             	mov    %eax,(%esp)
80102c06:	e8 c5 d4 ff ff       	call   801000d0 <bread>
80102c0b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c0d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c14:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c1b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c20:	89 04 24             	mov    %eax,(%esp)
80102c23:	e8 a8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c28:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c2f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c30:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c32:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c35:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c39:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3c:	89 04 24             	mov    %eax,(%esp)
80102c3f:	e8 ec 16 00 00       	call   80104330 <memmove>
    bwrite(to);  // write the log
80102c44:	89 34 24             	mov    %esi,(%esp)
80102c47:	e8 54 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c4c:	89 3c 24             	mov    %edi,(%esp)
80102c4f:	e8 8c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c54:	89 34 24             	mov    %esi,(%esp)
80102c57:	e8 84 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c5c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c62:	7c 8c                	jl     80102bf0 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c64:	e8 a7 fd ff ff       	call   80102a10 <write_head>
    install_trans(); // Now install writes to home locations
80102c69:	e8 02 fd ff ff       	call   80102970 <install_trans>
    log.lh.n = 0;
80102c6e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c75:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c78:	e8 93 fd ff ff       	call   80102a10 <write_head>
    acquire(&log.lock);
80102c7d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c84:	e8 c7 14 00 00       	call   80104150 <acquire>
    log.committing = 0;
80102c89:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c90:	00 00 00 
    wakeup(&log);
80102c93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c9a:	e8 01 11 00 00       	call   80103da0 <wakeup>
    release(&log.lock);
80102c9f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ca6:	e8 95 15 00 00       	call   80104240 <release>
}
80102cab:	83 c4 1c             	add    $0x1c,%esp
80102cae:	5b                   	pop    %ebx
80102caf:	5e                   	pop    %esi
80102cb0:	5f                   	pop    %edi
80102cb1:	5d                   	pop    %ebp
80102cb2:	c3                   	ret    
    panic("log.committing");
80102cb3:	c7 04 24 04 73 10 80 	movl   $0x80107304,(%esp)
80102cba:	e8 a1 d6 ff ff       	call   80100360 <panic>
80102cbf:	90                   	nop

80102cc0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cc7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102ccc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ccf:	83 f8 1d             	cmp    $0x1d,%eax
80102cd2:	0f 8f 98 00 00 00    	jg     80102d70 <log_write+0xb0>
80102cd8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cde:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102ce1:	39 d0                	cmp    %edx,%eax
80102ce3:	0f 8d 87 00 00 00    	jge    80102d70 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ce9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cee:	85 c0                	test   %eax,%eax
80102cf0:	0f 8e 86 00 00 00    	jle    80102d7c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cf6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cfd:	e8 4e 14 00 00       	call   80104150 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d02:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d08:	83 fa 00             	cmp    $0x0,%edx
80102d0b:	7e 54                	jle    80102d61 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d0d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d10:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d12:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d18:	75 0f                	jne    80102d29 <log_write+0x69>
80102d1a:	eb 3c                	jmp    80102d58 <log_write+0x98>
80102d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d20:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d27:	74 2f                	je     80102d58 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d29:	83 c0 01             	add    $0x1,%eax
80102d2c:	39 d0                	cmp    %edx,%eax
80102d2e:	75 f0                	jne    80102d20 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d30:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d37:	83 c2 01             	add    $0x1,%edx
80102d3a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d40:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d43:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d4a:	83 c4 14             	add    $0x14,%esp
80102d4d:	5b                   	pop    %ebx
80102d4e:	5d                   	pop    %ebp
  release(&log.lock);
80102d4f:	e9 ec 14 00 00       	jmp    80104240 <release>
80102d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d58:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d5f:	eb df                	jmp    80102d40 <log_write+0x80>
80102d61:	8b 43 08             	mov    0x8(%ebx),%eax
80102d64:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d69:	75 d5                	jne    80102d40 <log_write+0x80>
80102d6b:	eb ca                	jmp    80102d37 <log_write+0x77>
80102d6d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d70:	c7 04 24 13 73 10 80 	movl   $0x80107313,(%esp)
80102d77:	e8 e4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d7c:	c7 04 24 29 73 10 80 	movl   $0x80107329,(%esp)
80102d83:	e8 d8 d5 ff ff       	call   80100360 <panic>
80102d88:	66 90                	xchg   %ax,%ax
80102d8a:	66 90                	xchg   %ax,%ax
80102d8c:	66 90                	xchg   %ax,%ax
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d97:	e8 f4 08 00 00       	call   80103690 <cpuid>
80102d9c:	89 c3                	mov    %eax,%ebx
80102d9e:	e8 ed 08 00 00       	call   80103690 <cpuid>
80102da3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102da7:	c7 04 24 44 73 10 80 	movl   $0x80107344,(%esp)
80102dae:	89 44 24 04          	mov    %eax,0x4(%esp)
80102db2:	e8 99 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102db7:	e8 f4 26 00 00       	call   801054b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dbc:	e8 4f 08 00 00       	call   80103610 <mycpu>
80102dc1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102dc3:	b8 01 00 00 00       	mov    $0x1,%eax
80102dc8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dcf:	e8 9c 0b 00 00       	call   80103970 <scheduler>
80102dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102de0 <mpenter>:
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102de6:	e8 35 38 00 00       	call   80106620 <switchkvm>
  seginit();
80102deb:	e8 f0 36 00 00       	call   801064e0 <seginit>
  lapicinit();
80102df0:	e8 8b f8 ff ff       	call   80102680 <lapicinit>
  mpmain();
80102df5:	e8 96 ff ff ff       	call   80102d90 <mpmain>
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <main>:
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e04:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102e09:	83 e4 f0             	and    $0xfffffff0,%esp
80102e0c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e0f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e16:	80 
80102e17:	c7 04 24 f4 58 11 80 	movl   $0x801158f4,(%esp)
80102e1e:	e8 cd f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102e23:	e8 a8 3c 00 00       	call   80106ad0 <kvmalloc>
  mpinit();        // detect other processors
80102e28:	e8 73 01 00 00       	call   80102fa0 <mpinit>
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e30:	e8 4b f8 ff ff       	call   80102680 <lapicinit>
  seginit();       // segment descriptors
80102e35:	e8 a6 36 00 00       	call   801064e0 <seginit>
  picinit();       // disable pic
80102e3a:	e8 21 03 00 00       	call   80103160 <picinit>
80102e3f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e40:	e8 cb f3 ff ff       	call   80102210 <ioapicinit>
  consoleinit();   // console hardware
80102e45:	e8 06 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e4a:	e8 31 2a 00 00       	call   80105880 <uartinit>
80102e4f:	90                   	nop
  pinit();         // process table
80102e50:	e8 9b 07 00 00       	call   801035f0 <pinit>
  shminit();       // shared memory
80102e55:	e8 46 3f 00 00       	call   80106da0 <shminit>
  tvinit();        // trap vectors
80102e5a:	e8 b1 25 00 00       	call   80105410 <tvinit>
80102e5f:	90                   	nop
  binit();         // buffer cache
80102e60:	e8 db d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e65:	e8 e6 de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102e6a:	e8 a1 f1 ff ff       	call   80102010 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e6f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e76:	00 
80102e77:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e7e:	80 
80102e7f:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e86:	e8 a5 14 00 00       	call   80104330 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102e8b:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e92:	00 00 00 
80102e95:	05 80 27 11 80       	add    $0x80112780,%eax
80102e9a:	39 d8                	cmp    %ebx,%eax
80102e9c:	76 65                	jbe    80102f03 <main+0x103>
80102e9e:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102ea0:	e8 6b 07 00 00       	call   80103610 <mycpu>
80102ea5:	39 d8                	cmp    %ebx,%eax
80102ea7:	74 41                	je     80102eea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ea9:	e8 02 f6 ff ff       	call   801024b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102eae:	c7 05 f8 6f 00 80 e0 	movl   $0x80102de0,0x80006ff8
80102eb5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102eb8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ebf:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ec2:	05 00 10 00 00       	add    $0x1000,%eax
80102ec7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102ecc:	0f b6 03             	movzbl (%ebx),%eax
80102ecf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ed6:	00 
80102ed7:	89 04 24             	mov    %eax,(%esp)
80102eda:	e8 e1 f8 ff ff       	call   801027c0 <lapicstartap>
80102edf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ee0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ee6:	85 c0                	test   %eax,%eax
80102ee8:	74 f6                	je     80102ee0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102eea:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ef1:	00 00 00 
80102ef4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102efa:	05 80 27 11 80       	add    $0x80112780,%eax
80102eff:	39 c3                	cmp    %eax,%ebx
80102f01:	72 9d                	jb     80102ea0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f03:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f0a:	8e 
80102f0b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f12:	e8 49 f5 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102f17:	e8 c4 07 00 00       	call   801036e0 <userinit>
  mpmain();        // finish this processor's setup
80102f1c:	e8 6f fe ff ff       	call   80102d90 <mpmain>
80102f21:	66 90                	xchg   %ax,%ax
80102f23:	66 90                	xchg   %ax,%ax
80102f25:	66 90                	xchg   %ax,%ax
80102f27:	66 90                	xchg   %ax,%ax
80102f29:	66 90                	xchg   %ax,%ax
80102f2b:	66 90                	xchg   %ax,%ax
80102f2d:	66 90                	xchg   %ax,%ax
80102f2f:	90                   	nop

80102f30 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f34:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f3a:	53                   	push   %ebx
  e = addr+len;
80102f3b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f3e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f41:	39 de                	cmp    %ebx,%esi
80102f43:	73 3c                	jae    80102f81 <mpsearch1+0x51>
80102f45:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f48:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f4f:	00 
80102f50:	c7 44 24 04 58 73 10 	movl   $0x80107358,0x4(%esp)
80102f57:	80 
80102f58:	89 34 24             	mov    %esi,(%esp)
80102f5b:	e8 80 13 00 00       	call   801042e0 <memcmp>
80102f60:	85 c0                	test   %eax,%eax
80102f62:	75 16                	jne    80102f7a <mpsearch1+0x4a>
80102f64:	31 c9                	xor    %ecx,%ecx
80102f66:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f68:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f6c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f6f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f71:	83 fa 10             	cmp    $0x10,%edx
80102f74:	75 f2                	jne    80102f68 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f76:	84 c9                	test   %cl,%cl
80102f78:	74 10                	je     80102f8a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f7a:	83 c6 10             	add    $0x10,%esi
80102f7d:	39 f3                	cmp    %esi,%ebx
80102f7f:	77 c7                	ja     80102f48 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102f81:	83 c4 10             	add    $0x10,%esp
  return 0;
80102f84:	31 c0                	xor    %eax,%eax
}
80102f86:	5b                   	pop    %ebx
80102f87:	5e                   	pop    %esi
80102f88:	5d                   	pop    %ebp
80102f89:	c3                   	ret    
80102f8a:	83 c4 10             	add    $0x10,%esp
80102f8d:	89 f0                	mov    %esi,%eax
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5d                   	pop    %ebp
80102f92:	c3                   	ret    
80102f93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
80102fa5:	53                   	push   %ebx
80102fa6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fa9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fb0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fb7:	c1 e0 08             	shl    $0x8,%eax
80102fba:	09 d0                	or     %edx,%eax
80102fbc:	c1 e0 04             	shl    $0x4,%eax
80102fbf:	85 c0                	test   %eax,%eax
80102fc1:	75 1b                	jne    80102fde <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fc3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fd1:	c1 e0 08             	shl    $0x8,%eax
80102fd4:	09 d0                	or     %edx,%eax
80102fd6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fd9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102fde:	ba 00 04 00 00       	mov    $0x400,%edx
80102fe3:	e8 48 ff ff ff       	call   80102f30 <mpsearch1>
80102fe8:	85 c0                	test   %eax,%eax
80102fea:	89 c7                	mov    %eax,%edi
80102fec:	0f 84 22 01 00 00    	je     80103114 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102ff2:	8b 77 04             	mov    0x4(%edi),%esi
80102ff5:	85 f6                	test   %esi,%esi
80102ff7:	0f 84 30 01 00 00    	je     8010312d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102ffd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103003:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010300a:	00 
8010300b:	c7 44 24 04 5d 73 10 	movl   $0x8010735d,0x4(%esp)
80103012:	80 
80103013:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103019:	e8 c2 12 00 00       	call   801042e0 <memcmp>
8010301e:	85 c0                	test   %eax,%eax
80103020:	0f 85 07 01 00 00    	jne    8010312d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103026:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010302d:	3c 04                	cmp    $0x4,%al
8010302f:	0f 85 0b 01 00 00    	jne    80103140 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103035:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010303c:	85 c0                	test   %eax,%eax
8010303e:	74 21                	je     80103061 <mpinit+0xc1>
  sum = 0;
80103040:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103042:	31 d2                	xor    %edx,%edx
80103044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103048:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010304f:	80 
  for(i=0; i<len; i++)
80103050:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103053:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103055:	39 d0                	cmp    %edx,%eax
80103057:	7f ef                	jg     80103048 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103059:	84 c9                	test   %cl,%cl
8010305b:	0f 85 cc 00 00 00    	jne    8010312d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103064:	85 c0                	test   %eax,%eax
80103066:	0f 84 c1 00 00 00    	je     8010312d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010306c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103072:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103077:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010307c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103083:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103089:	03 55 e4             	add    -0x1c(%ebp),%edx
8010308c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103090:	39 c2                	cmp    %eax,%edx
80103092:	76 1b                	jbe    801030af <mpinit+0x10f>
80103094:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103097:	80 f9 04             	cmp    $0x4,%cl
8010309a:	77 74                	ja     80103110 <mpinit+0x170>
8010309c:	ff 24 8d 9c 73 10 80 	jmp    *-0x7fef8c64(,%ecx,4)
801030a3:	90                   	nop
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030a8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030ab:	39 c2                	cmp    %eax,%edx
801030ad:	77 e5                	ja     80103094 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030af:	85 db                	test   %ebx,%ebx
801030b1:	0f 84 93 00 00 00    	je     8010314a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030b7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030bb:	74 12                	je     801030cf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030bd:	ba 22 00 00 00       	mov    $0x22,%edx
801030c2:	b8 70 00 00 00       	mov    $0x70,%eax
801030c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c8:	b2 23                	mov    $0x23,%dl
801030ca:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030cb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ce:	ee                   	out    %al,(%dx)
  }
}
801030cf:	83 c4 1c             	add    $0x1c,%esp
801030d2:	5b                   	pop    %ebx
801030d3:	5e                   	pop    %esi
801030d4:	5f                   	pop    %edi
801030d5:	5d                   	pop    %ebp
801030d6:	c3                   	ret    
801030d7:	90                   	nop
      if(ncpu < NCPU) {
801030d8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030de:	83 fe 07             	cmp    $0x7,%esi
801030e1:	7f 17                	jg     801030fa <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030e3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030e7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030ed:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030f4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
801030fa:	83 c0 14             	add    $0x14,%eax
      continue;
801030fd:	eb 91                	jmp    80103090 <mpinit+0xf0>
801030ff:	90                   	nop
      ioapicid = ioapic->apicno;
80103100:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103104:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103107:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
8010310d:	eb 81                	jmp    80103090 <mpinit+0xf0>
8010310f:	90                   	nop
      ismp = 0;
80103110:	31 db                	xor    %ebx,%ebx
80103112:	eb 83                	jmp    80103097 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103114:	ba 00 00 01 00       	mov    $0x10000,%edx
80103119:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010311e:	e8 0d fe ff ff       	call   80102f30 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103123:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103125:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103127:	0f 85 c5 fe ff ff    	jne    80102ff2 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010312d:	c7 04 24 62 73 10 80 	movl   $0x80107362,(%esp)
80103134:	e8 27 d2 ff ff       	call   80100360 <panic>
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103140:	3c 01                	cmp    $0x1,%al
80103142:	0f 84 ed fe ff ff    	je     80103035 <mpinit+0x95>
80103148:	eb e3                	jmp    8010312d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010314a:	c7 04 24 7c 73 10 80 	movl   $0x8010737c,(%esp)
80103151:	e8 0a d2 ff ff       	call   80100360 <panic>
80103156:	66 90                	xchg   %ax,%ax
80103158:	66 90                	xchg   %ax,%ax
8010315a:	66 90                	xchg   %ax,%ax
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103160:	55                   	push   %ebp
80103161:	ba 21 00 00 00       	mov    $0x21,%edx
80103166:	89 e5                	mov    %esp,%ebp
80103168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010316d:	ee                   	out    %al,(%dx)
8010316e:	b2 a1                	mov    $0xa1,%dl
80103170:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103171:	5d                   	pop    %ebp
80103172:	c3                   	ret    
80103173:	66 90                	xchg   %ax,%ax
80103175:	66 90                	xchg   %ax,%ax
80103177:	66 90                	xchg   %ax,%ax
80103179:	66 90                	xchg   %ax,%ax
8010317b:	66 90                	xchg   %ax,%ax
8010317d:	66 90                	xchg   %ax,%ax
8010317f:	90                   	nop

80103180 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
80103185:	53                   	push   %ebx
80103186:	83 ec 1c             	sub    $0x1c,%esp
80103189:	8b 75 08             	mov    0x8(%ebp),%esi
8010318c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010318f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103195:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010319b:	e8 d0 db ff ff       	call   80100d70 <filealloc>
801031a0:	85 c0                	test   %eax,%eax
801031a2:	89 06                	mov    %eax,(%esi)
801031a4:	0f 84 a4 00 00 00    	je     8010324e <pipealloc+0xce>
801031aa:	e8 c1 db ff ff       	call   80100d70 <filealloc>
801031af:	85 c0                	test   %eax,%eax
801031b1:	89 03                	mov    %eax,(%ebx)
801031b3:	0f 84 87 00 00 00    	je     80103240 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031b9:	e8 f2 f2 ff ff       	call   801024b0 <kalloc>
801031be:	85 c0                	test   %eax,%eax
801031c0:	89 c7                	mov    %eax,%edi
801031c2:	74 7c                	je     80103240 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031c4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031cb:	00 00 00 
  p->writeopen = 1;
801031ce:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031d5:	00 00 00 
  p->nwrite = 0;
801031d8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031df:	00 00 00 
  p->nread = 0;
801031e2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031e9:	00 00 00 
  initlock(&p->lock, "pipe");
801031ec:	89 04 24             	mov    %eax,(%esp)
801031ef:	c7 44 24 04 b0 73 10 	movl   $0x801073b0,0x4(%esp)
801031f6:	80 
801031f7:	e8 64 0e 00 00       	call   80104060 <initlock>
  (*f0)->type = FD_PIPE;
801031fc:	8b 06                	mov    (%esi),%eax
801031fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103204:	8b 06                	mov    (%esi),%eax
80103206:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010320a:	8b 06                	mov    (%esi),%eax
8010320c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103210:	8b 06                	mov    (%esi),%eax
80103212:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103215:	8b 03                	mov    (%ebx),%eax
80103217:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010321d:	8b 03                	mov    (%ebx),%eax
8010321f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103223:	8b 03                	mov    (%ebx),%eax
80103225:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103229:	8b 03                	mov    (%ebx),%eax
  return 0;
8010322b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010322d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103230:	83 c4 1c             	add    $0x1c,%esp
80103233:	89 d8                	mov    %ebx,%eax
80103235:	5b                   	pop    %ebx
80103236:	5e                   	pop    %esi
80103237:	5f                   	pop    %edi
80103238:	5d                   	pop    %ebp
80103239:	c3                   	ret    
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103240:	8b 06                	mov    (%esi),%eax
80103242:	85 c0                	test   %eax,%eax
80103244:	74 08                	je     8010324e <pipealloc+0xce>
    fileclose(*f0);
80103246:	89 04 24             	mov    %eax,(%esp)
80103249:	e8 e2 db ff ff       	call   80100e30 <fileclose>
  if(*f1)
8010324e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103250:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103255:	85 c0                	test   %eax,%eax
80103257:	74 d7                	je     80103230 <pipealloc+0xb0>
    fileclose(*f1);
80103259:	89 04 24             	mov    %eax,(%esp)
8010325c:	e8 cf db ff ff       	call   80100e30 <fileclose>
}
80103261:	83 c4 1c             	add    $0x1c,%esp
80103264:	89 d8                	mov    %ebx,%eax
80103266:	5b                   	pop    %ebx
80103267:	5e                   	pop    %esi
80103268:	5f                   	pop    %edi
80103269:	5d                   	pop    %ebp
8010326a:	c3                   	ret    
8010326b:	90                   	nop
8010326c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103270 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	56                   	push   %esi
80103274:	53                   	push   %ebx
80103275:	83 ec 10             	sub    $0x10,%esp
80103278:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010327b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010327e:	89 1c 24             	mov    %ebx,(%esp)
80103281:	e8 ca 0e 00 00       	call   80104150 <acquire>
  if(writable){
80103286:	85 f6                	test   %esi,%esi
80103288:	74 3e                	je     801032c8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010328a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103290:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103297:	00 00 00 
    wakeup(&p->nread);
8010329a:	89 04 24             	mov    %eax,(%esp)
8010329d:	e8 fe 0a 00 00       	call   80103da0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032a2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032a8:	85 d2                	test   %edx,%edx
801032aa:	75 0a                	jne    801032b6 <pipeclose+0x46>
801032ac:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 32                	je     801032e8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	5b                   	pop    %ebx
801032bd:	5e                   	pop    %esi
801032be:	5d                   	pop    %ebp
    release(&p->lock);
801032bf:	e9 7c 0f 00 00       	jmp    80104240 <release>
801032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032c8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032ce:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032d5:	00 00 00 
    wakeup(&p->nwrite);
801032d8:	89 04 24             	mov    %eax,(%esp)
801032db:	e8 c0 0a 00 00       	call   80103da0 <wakeup>
801032e0:	eb c0                	jmp    801032a2 <pipeclose+0x32>
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032e8:	89 1c 24             	mov    %ebx,(%esp)
801032eb:	e8 50 0f 00 00       	call   80104240 <release>
    kfree((char*)p);
801032f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032f3:	83 c4 10             	add    $0x10,%esp
801032f6:	5b                   	pop    %ebx
801032f7:	5e                   	pop    %esi
801032f8:	5d                   	pop    %ebp
    kfree((char*)p);
801032f9:	e9 02 f0 ff ff       	jmp    80102300 <kfree>
801032fe:	66 90                	xchg   %ax,%ax

80103300 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	53                   	push   %ebx
80103306:	83 ec 1c             	sub    $0x1c,%esp
80103309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010330c:	89 1c 24             	mov    %ebx,(%esp)
8010330f:	e8 3c 0e 00 00       	call   80104150 <acquire>
  for(i = 0; i < n; i++){
80103314:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103317:	85 c9                	test   %ecx,%ecx
80103319:	0f 8e b2 00 00 00    	jle    801033d1 <pipewrite+0xd1>
8010331f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103322:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103328:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010332e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103334:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103337:	03 4d 10             	add    0x10(%ebp),%ecx
8010333a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010333d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103343:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103349:	39 c8                	cmp    %ecx,%eax
8010334b:	74 38                	je     80103385 <pipewrite+0x85>
8010334d:	eb 55                	jmp    801033a4 <pipewrite+0xa4>
8010334f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103350:	e8 5b 03 00 00       	call   801036b0 <myproc>
80103355:	8b 40 24             	mov    0x24(%eax),%eax
80103358:	85 c0                	test   %eax,%eax
8010335a:	75 33                	jne    8010338f <pipewrite+0x8f>
      wakeup(&p->nread);
8010335c:	89 3c 24             	mov    %edi,(%esp)
8010335f:	e8 3c 0a 00 00       	call   80103da0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103364:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103368:	89 34 24             	mov    %esi,(%esp)
8010336b:	e8 a0 08 00 00       	call   80103c10 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103370:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103376:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010337c:	05 00 02 00 00       	add    $0x200,%eax
80103381:	39 c2                	cmp    %eax,%edx
80103383:	75 23                	jne    801033a8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103385:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338b:	85 d2                	test   %edx,%edx
8010338d:	75 c1                	jne    80103350 <pipewrite+0x50>
        release(&p->lock);
8010338f:	89 1c 24             	mov    %ebx,(%esp)
80103392:	e8 a9 0e 00 00       	call   80104240 <release>
        return -1;
80103397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010339c:	83 c4 1c             	add    $0x1c,%esp
8010339f:	5b                   	pop    %ebx
801033a0:	5e                   	pop    %esi
801033a1:	5f                   	pop    %edi
801033a2:	5d                   	pop    %ebp
801033a3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033a4:	89 c2                	mov    %eax,%edx
801033a6:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033ab:	8d 42 01             	lea    0x1(%edx),%eax
801033ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033b4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033ba:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033be:	0f b6 09             	movzbl (%ecx),%ecx
801033c1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033c5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033c8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033cb:	0f 85 6c ff ff ff    	jne    8010333d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033d1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033d7:	89 04 24             	mov    %eax,(%esp)
801033da:	e8 c1 09 00 00       	call   80103da0 <wakeup>
  release(&p->lock);
801033df:	89 1c 24             	mov    %ebx,(%esp)
801033e2:	e8 59 0e 00 00       	call   80104240 <release>
  return n;
801033e7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ea:	eb b0                	jmp    8010339c <pipewrite+0x9c>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 1c             	sub    $0x1c,%esp
801033f9:	8b 75 08             	mov    0x8(%ebp),%esi
801033fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033ff:	89 34 24             	mov    %esi,(%esp)
80103402:	e8 49 0d 00 00       	call   80104150 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103407:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010340d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103413:	75 5b                	jne    80103470 <piperead+0x80>
80103415:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010341b:	85 db                	test   %ebx,%ebx
8010341d:	74 51                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010341f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103425:	eb 25                	jmp    8010344c <piperead+0x5c>
80103427:	90                   	nop
80103428:	89 74 24 04          	mov    %esi,0x4(%esp)
8010342c:	89 1c 24             	mov    %ebx,(%esp)
8010342f:	e8 dc 07 00 00       	call   80103c10 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103434:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010343a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103440:	75 2e                	jne    80103470 <piperead+0x80>
80103442:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103448:	85 d2                	test   %edx,%edx
8010344a:	74 24                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
8010344c:	e8 5f 02 00 00       	call   801036b0 <myproc>
80103451:	8b 48 24             	mov    0x24(%eax),%ecx
80103454:	85 c9                	test   %ecx,%ecx
80103456:	74 d0                	je     80103428 <piperead+0x38>
      release(&p->lock);
80103458:	89 34 24             	mov    %esi,(%esp)
8010345b:	e8 e0 0d 00 00       	call   80104240 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103460:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103468:	5b                   	pop    %ebx
80103469:	5e                   	pop    %esi
8010346a:	5f                   	pop    %edi
8010346b:	5d                   	pop    %ebp
8010346c:	c3                   	ret    
8010346d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103470:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103473:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103475:	85 d2                	test   %edx,%edx
80103477:	7f 2b                	jg     801034a4 <piperead+0xb4>
80103479:	eb 31                	jmp    801034ac <piperead+0xbc>
8010347b:	90                   	nop
8010347c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103480:	8d 48 01             	lea    0x1(%eax),%ecx
80103483:	25 ff 01 00 00       	and    $0x1ff,%eax
80103488:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010348e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103493:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103496:	83 c3 01             	add    $0x1,%ebx
80103499:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010349c:	74 0e                	je     801034ac <piperead+0xbc>
    if(p->nread == p->nwrite)
8010349e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034aa:	75 d4                	jne    80103480 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034ac:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034b2:	89 04 24             	mov    %eax,(%esp)
801034b5:	e8 e6 08 00 00       	call   80103da0 <wakeup>
  release(&p->lock);
801034ba:	89 34 24             	mov    %esi,(%esp)
801034bd:	e8 7e 0d 00 00       	call   80104240 <release>
}
801034c2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034c5:	89 d8                	mov    %ebx,%eax
}
801034c7:	5b                   	pop    %ebx
801034c8:	5e                   	pop    %esi
801034c9:	5f                   	pop    %edi
801034ca:	5d                   	pop    %ebp
801034cb:	c3                   	ret    
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034d9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034dc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034e3:	e8 68 0c 00 00       	call   80104150 <acquire>
801034e8:	eb 11                	jmp    801034fb <allocproc+0x2b>
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034f0:	83 eb 80             	sub    $0xffffff80,%ebx
801034f3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801034f9:	74 7d                	je     80103578 <allocproc+0xa8>
    if(p->state == UNUSED)
801034fb:	8b 43 0c             	mov    0xc(%ebx),%eax
801034fe:	85 c0                	test   %eax,%eax
80103500:	75 ee                	jne    801034f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103502:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103507:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
8010350e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103515:	8d 50 01             	lea    0x1(%eax),%edx
80103518:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010351e:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103521:	e8 1a 0d 00 00       	call   80104240 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103526:	e8 85 ef ff ff       	call   801024b0 <kalloc>
8010352b:	85 c0                	test   %eax,%eax
8010352d:	89 43 08             	mov    %eax,0x8(%ebx)
80103530:	74 5a                	je     8010358c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103532:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103538:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010353d:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103540:	c7 40 14 05 54 10 80 	movl   $0x80105405,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103547:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010354e:	00 
8010354f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103556:	00 
80103557:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010355a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010355d:	e8 2e 0d 00 00       	call   80104290 <memset>
  p->context->eip = (uint)forkret;
80103562:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103565:	c7 40 10 a0 35 10 80 	movl   $0x801035a0,0x10(%eax)

  return p;
8010356c:	89 d8                	mov    %ebx,%eax
}
8010356e:	83 c4 14             	add    $0x14,%esp
80103571:	5b                   	pop    %ebx
80103572:	5d                   	pop    %ebp
80103573:	c3                   	ret    
80103574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103578:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010357f:	e8 bc 0c 00 00       	call   80104240 <release>
}
80103584:	83 c4 14             	add    $0x14,%esp
  return 0;
80103587:	31 c0                	xor    %eax,%eax
}
80103589:	5b                   	pop    %ebx
8010358a:	5d                   	pop    %ebp
8010358b:	c3                   	ret    
    p->state = UNUSED;
8010358c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103593:	eb d9                	jmp    8010356e <allocproc+0x9e>
80103595:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035a6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035ad:	e8 8e 0c 00 00       	call   80104240 <release>

  if (first) {
801035b2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035b7:	85 c0                	test   %eax,%eax
801035b9:	75 05                	jne    801035c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035bb:	c9                   	leave  
801035bc:	c3                   	ret    
801035bd:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035c7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035ce:	00 00 00 
    iinit(ROOTDEV);
801035d1:	e8 aa de ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801035d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035dd:	e8 9e f4 ff ff       	call   80102a80 <initlog>
}
801035e2:	c9                   	leave  
801035e3:	c3                   	ret    
801035e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035f0 <pinit>:
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801035f6:	c7 44 24 04 b5 73 10 	movl   $0x801073b5,0x4(%esp)
801035fd:	80 
801035fe:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103605:	e8 56 0a 00 00       	call   80104060 <initlock>
}
8010360a:	c9                   	leave  
8010360b:	c3                   	ret    
8010360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103610 <mycpu>:
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	56                   	push   %esi
80103614:	53                   	push   %ebx
80103615:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103618:	9c                   	pushf  
80103619:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010361a:	f6 c4 02             	test   $0x2,%ah
8010361d:	75 57                	jne    80103676 <mycpu+0x66>
  apicid = lapicid();
8010361f:	e8 4c f1 ff ff       	call   80102770 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103624:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010362a:	85 f6                	test   %esi,%esi
8010362c:	7e 3c                	jle    8010366a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010362e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103635:	39 c2                	cmp    %eax,%edx
80103637:	74 2d                	je     80103666 <mycpu+0x56>
80103639:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010363e:	31 d2                	xor    %edx,%edx
80103640:	83 c2 01             	add    $0x1,%edx
80103643:	39 f2                	cmp    %esi,%edx
80103645:	74 23                	je     8010366a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103647:	0f b6 19             	movzbl (%ecx),%ebx
8010364a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103650:	39 c3                	cmp    %eax,%ebx
80103652:	75 ec                	jne    80103640 <mycpu+0x30>
      return &cpus[i];
80103654:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010365a:	83 c4 10             	add    $0x10,%esp
8010365d:	5b                   	pop    %ebx
8010365e:	5e                   	pop    %esi
8010365f:	5d                   	pop    %ebp
      return &cpus[i];
80103660:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103665:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103666:	31 d2                	xor    %edx,%edx
80103668:	eb ea                	jmp    80103654 <mycpu+0x44>
  panic("unknown apicid\n");
8010366a:	c7 04 24 bc 73 10 80 	movl   $0x801073bc,(%esp)
80103671:	e8 ea cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103676:	c7 04 24 98 74 10 80 	movl   $0x80107498,(%esp)
8010367d:	e8 de cc ff ff       	call   80100360 <panic>
80103682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103690 <cpuid>:
cpuid() {
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103696:	e8 75 ff ff ff       	call   80103610 <mycpu>
}
8010369b:	c9                   	leave  
  return mycpu()-cpus;
8010369c:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036a1:	c1 f8 04             	sar    $0x4,%eax
801036a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036aa:	c3                   	ret    
801036ab:	90                   	nop
801036ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036b0 <myproc>:
myproc(void) {
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	53                   	push   %ebx
801036b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036b7:	e8 54 0a 00 00       	call   80104110 <pushcli>
  c = mycpu();
801036bc:	e8 4f ff ff ff       	call   80103610 <mycpu>
  p = c->proc;
801036c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036c7:	e8 04 0b 00 00       	call   801041d0 <popcli>
}
801036cc:	83 c4 04             	add    $0x4,%esp
801036cf:	89 d8                	mov    %ebx,%eax
801036d1:	5b                   	pop    %ebx
801036d2:	5d                   	pop    %ebp
801036d3:	c3                   	ret    
801036d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036e0 <userinit>:
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	53                   	push   %ebx
801036e4:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
801036e7:	e8 e4 fd ff ff       	call   801034d0 <allocproc>
801036ec:	89 c3                	mov    %eax,%ebx
  initproc = p;
801036ee:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801036f3:	e8 48 33 00 00       	call   80106a40 <setupkvm>
801036f8:	85 c0                	test   %eax,%eax
801036fa:	89 43 04             	mov    %eax,0x4(%ebx)
801036fd:	0f 84 d4 00 00 00    	je     801037d7 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103703:	89 04 24             	mov    %eax,(%esp)
80103706:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010370d:	00 
8010370e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103715:	80 
80103716:	e8 35 30 00 00       	call   80106750 <inituvm>
  p->sz = PGSIZE;
8010371b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103721:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103728:	00 
80103729:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103730:	00 
80103731:	8b 43 18             	mov    0x18(%ebx),%eax
80103734:	89 04 24             	mov    %eax,(%esp)
80103737:	e8 54 0b 00 00       	call   80104290 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010373c:	8b 43 18             	mov    0x18(%ebx),%eax
8010373f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103744:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103749:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010374d:	8b 43 18             	mov    0x18(%ebx),%eax
80103750:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103754:	8b 43 18             	mov    0x18(%ebx),%eax
80103757:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010375b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010375f:	8b 43 18             	mov    0x18(%ebx),%eax
80103762:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103766:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010376a:	8b 43 18             	mov    0x18(%ebx),%eax
8010376d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103774:	8b 43 18             	mov    0x18(%ebx),%eax
80103777:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010377e:	8b 43 18             	mov    0x18(%ebx),%eax
80103781:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103788:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010378b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103792:	00 
80103793:	c7 44 24 04 e5 73 10 	movl   $0x801073e5,0x4(%esp)
8010379a:	80 
8010379b:	89 04 24             	mov    %eax,(%esp)
8010379e:	e8 cd 0c 00 00       	call   80104470 <safestrcpy>
  p->cwd = namei("/");
801037a3:	c7 04 24 ee 73 10 80 	movl   $0x801073ee,(%esp)
801037aa:	e8 61 e7 ff ff       	call   80101f10 <namei>
801037af:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037b2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037b9:	e8 92 09 00 00       	call   80104150 <acquire>
  p->state = RUNNABLE;
801037be:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801037c5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037cc:	e8 6f 0a 00 00       	call   80104240 <release>
}
801037d1:	83 c4 14             	add    $0x14,%esp
801037d4:	5b                   	pop    %ebx
801037d5:	5d                   	pop    %ebp
801037d6:	c3                   	ret    
    panic("userinit: out of memory?");
801037d7:	c7 04 24 cc 73 10 80 	movl   $0x801073cc,(%esp)
801037de:	e8 7d cb ff ff       	call   80100360 <panic>
801037e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037f0 <growproc>:
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx
801037f5:	83 ec 10             	sub    $0x10,%esp
801037f8:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801037fb:	e8 b0 fe ff ff       	call   801036b0 <myproc>
  if(n > 0){
80103800:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103803:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103805:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103807:	7e 2f                	jle    80103838 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103809:	01 c6                	add    %eax,%esi
8010380b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010380f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103813:	8b 43 04             	mov    0x4(%ebx),%eax
80103816:	89 04 24             	mov    %eax,(%esp)
80103819:	e8 82 30 00 00       	call   801068a0 <allocuvm>
8010381e:	85 c0                	test   %eax,%eax
80103820:	74 36                	je     80103858 <growproc+0x68>
  curproc->sz = sz;
80103822:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103824:	89 1c 24             	mov    %ebx,(%esp)
80103827:	e8 14 2e 00 00       	call   80106640 <switchuvm>
  return 0;
8010382c:	31 c0                	xor    %eax,%eax
}
8010382e:	83 c4 10             	add    $0x10,%esp
80103831:	5b                   	pop    %ebx
80103832:	5e                   	pop    %esi
80103833:	5d                   	pop    %ebp
80103834:	c3                   	ret    
80103835:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103838:	74 e8                	je     80103822 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010383a:	01 c6                	add    %eax,%esi
8010383c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103840:	89 44 24 04          	mov    %eax,0x4(%esp)
80103844:	8b 43 04             	mov    0x4(%ebx),%eax
80103847:	89 04 24             	mov    %eax,(%esp)
8010384a:	e8 51 31 00 00       	call   801069a0 <deallocuvm>
8010384f:	85 c0                	test   %eax,%eax
80103851:	75 cf                	jne    80103822 <growproc+0x32>
80103853:	90                   	nop
80103854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103858:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010385d:	eb cf                	jmp    8010382e <growproc+0x3e>
8010385f:	90                   	nop

80103860 <fork>:
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	57                   	push   %edi
80103864:	56                   	push   %esi
80103865:	53                   	push   %ebx
80103866:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103869:	e8 42 fe ff ff       	call   801036b0 <myproc>
8010386e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103870:	e8 5b fc ff ff       	call   801034d0 <allocproc>
80103875:	85 c0                	test   %eax,%eax
80103877:	89 c7                	mov    %eax,%edi
80103879:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010387c:	0f 84 c4 00 00 00    	je     80103946 <fork+0xe6>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->stackSize)) == 0){
80103882:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103885:	89 44 24 08          	mov    %eax,0x8(%esp)
80103889:	8b 03                	mov    (%ebx),%eax
8010388b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010388f:	8b 43 04             	mov    0x4(%ebx),%eax
80103892:	89 04 24             	mov    %eax,(%esp)
80103895:	e8 86 32 00 00       	call   80106b20 <copyuvm>
8010389a:	85 c0                	test   %eax,%eax
8010389c:	89 47 04             	mov    %eax,0x4(%edi)
8010389f:	0f 84 a8 00 00 00    	je     8010394d <fork+0xed>
  np->sz = curproc->sz;
801038a5:	8b 03                	mov    (%ebx),%eax
801038a7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038aa:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801038ac:	8b 79 18             	mov    0x18(%ecx),%edi
801038af:	89 c8                	mov    %ecx,%eax
  np->parent = curproc;
801038b1:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801038b4:	8b 73 18             	mov    0x18(%ebx),%esi
801038b7:	b9 13 00 00 00       	mov    $0x13,%ecx
801038bc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038be:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801038c0:	8b 40 18             	mov    0x18(%eax),%eax
801038c3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
801038d0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038d4:	85 c0                	test   %eax,%eax
801038d6:	74 0f                	je     801038e7 <fork+0x87>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038d8:	89 04 24             	mov    %eax,(%esp)
801038db:	e8 00 d5 ff ff       	call   80100de0 <filedup>
801038e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038e3:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801038e7:	83 c6 01             	add    $0x1,%esi
801038ea:	83 fe 10             	cmp    $0x10,%esi
801038ed:	75 e1                	jne    801038d0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801038ef:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038f2:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801038f5:	89 04 24             	mov    %eax,(%esp)
801038f8:	e8 93 dd ff ff       	call   80101690 <idup>
801038fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103900:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103903:	8d 47 6c             	lea    0x6c(%edi),%eax
80103906:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010390a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103911:	00 
80103912:	89 04 24             	mov    %eax,(%esp)
80103915:	e8 56 0b 00 00       	call   80104470 <safestrcpy>
  pid = np->pid;
8010391a:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
8010391d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103924:	e8 27 08 00 00       	call   80104150 <acquire>
  np->state = RUNNABLE;
80103929:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103930:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103937:	e8 04 09 00 00       	call   80104240 <release>
  return pid;
8010393c:	89 d8                	mov    %ebx,%eax
}
8010393e:	83 c4 1c             	add    $0x1c,%esp
80103941:	5b                   	pop    %ebx
80103942:	5e                   	pop    %esi
80103943:	5f                   	pop    %edi
80103944:	5d                   	pop    %ebp
80103945:	c3                   	ret    
    return -1;
80103946:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010394b:	eb f1                	jmp    8010393e <fork+0xde>
    kfree(np->kstack);
8010394d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103950:	8b 47 08             	mov    0x8(%edi),%eax
80103953:	89 04 24             	mov    %eax,(%esp)
80103956:	e8 a5 e9 ff ff       	call   80102300 <kfree>
    return -1;
8010395b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103960:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103967:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
8010396e:	eb ce                	jmp    8010393e <fork+0xde>

80103970 <scheduler>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	57                   	push   %edi
80103974:	56                   	push   %esi
80103975:	53                   	push   %ebx
80103976:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103979:	e8 92 fc ff ff       	call   80103610 <mycpu>
8010397e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103980:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103987:	00 00 00 
8010398a:	8d 78 04             	lea    0x4(%eax),%edi
8010398d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103990:	fb                   	sti    
    acquire(&ptable.lock);
80103991:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103998:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
8010399d:	e8 ae 07 00 00       	call   80104150 <acquire>
801039a2:	eb 0f                	jmp    801039b3 <scheduler+0x43>
801039a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a8:	83 eb 80             	sub    $0xffffff80,%ebx
801039ab:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801039b1:	74 45                	je     801039f8 <scheduler+0x88>
      if(p->state != RUNNABLE)
801039b3:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039b7:	75 ef                	jne    801039a8 <scheduler+0x38>
      c->proc = p;
801039b9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039bf:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039c2:	83 eb 80             	sub    $0xffffff80,%ebx
      switchuvm(p);
801039c5:	e8 76 2c 00 00       	call   80106640 <switchuvm>
      swtch(&(c->scheduler), p->context);
801039ca:	8b 43 9c             	mov    -0x64(%ebx),%eax
      p->state = RUNNING;
801039cd:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)
      swtch(&(c->scheduler), p->context);
801039d4:	89 3c 24             	mov    %edi,(%esp)
801039d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801039db:	e8 eb 0a 00 00       	call   801044cb <swtch>
      switchkvm();
801039e0:	e8 3b 2c 00 00       	call   80106620 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039e5:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      c->proc = 0;
801039eb:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801039f2:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039f5:	75 bc                	jne    801039b3 <scheduler+0x43>
801039f7:	90                   	nop
    release(&ptable.lock);
801039f8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039ff:	e8 3c 08 00 00       	call   80104240 <release>
  }
80103a04:	eb 8a                	jmp    80103990 <scheduler+0x20>
80103a06:	8d 76 00             	lea    0x0(%esi),%esi
80103a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a10 <sched>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	56                   	push   %esi
80103a14:	53                   	push   %ebx
80103a15:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103a18:	e8 93 fc ff ff       	call   801036b0 <myproc>
  if(!holding(&ptable.lock))
80103a1d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103a24:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103a26:	e8 b5 06 00 00       	call   801040e0 <holding>
80103a2b:	85 c0                	test   %eax,%eax
80103a2d:	74 4f                	je     80103a7e <sched+0x6e>
  if(mycpu()->ncli != 1)
80103a2f:	e8 dc fb ff ff       	call   80103610 <mycpu>
80103a34:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a3b:	75 65                	jne    80103aa2 <sched+0x92>
  if(p->state == RUNNING)
80103a3d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a41:	74 53                	je     80103a96 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a43:	9c                   	pushf  
80103a44:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a45:	f6 c4 02             	test   $0x2,%ah
80103a48:	75 40                	jne    80103a8a <sched+0x7a>
  intena = mycpu()->intena;
80103a4a:	e8 c1 fb ff ff       	call   80103610 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a4f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103a52:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a58:	e8 b3 fb ff ff       	call   80103610 <mycpu>
80103a5d:	8b 40 04             	mov    0x4(%eax),%eax
80103a60:	89 1c 24             	mov    %ebx,(%esp)
80103a63:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a67:	e8 5f 0a 00 00       	call   801044cb <swtch>
  mycpu()->intena = intena;
80103a6c:	e8 9f fb ff ff       	call   80103610 <mycpu>
80103a71:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a77:	83 c4 10             	add    $0x10,%esp
80103a7a:	5b                   	pop    %ebx
80103a7b:	5e                   	pop    %esi
80103a7c:	5d                   	pop    %ebp
80103a7d:	c3                   	ret    
    panic("sched ptable.lock");
80103a7e:	c7 04 24 f0 73 10 80 	movl   $0x801073f0,(%esp)
80103a85:	e8 d6 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103a8a:	c7 04 24 1c 74 10 80 	movl   $0x8010741c,(%esp)
80103a91:	e8 ca c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103a96:	c7 04 24 0e 74 10 80 	movl   $0x8010740e,(%esp)
80103a9d:	e8 be c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103aa2:	c7 04 24 02 74 10 80 	movl   $0x80107402,(%esp)
80103aa9:	e8 b2 c8 ff ff       	call   80100360 <panic>
80103aae:	66 90                	xchg   %ax,%ax

80103ab0 <exit>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
  if(curproc == initproc)
80103ab4:	31 f6                	xor    %esi,%esi
{
80103ab6:	53                   	push   %ebx
80103ab7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103aba:	e8 f1 fb ff ff       	call   801036b0 <myproc>
  if(curproc == initproc)
80103abf:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103ac5:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103ac7:	0f 84 ea 00 00 00    	je     80103bb7 <exit+0x107>
80103acd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ad0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ad4:	85 c0                	test   %eax,%eax
80103ad6:	74 10                	je     80103ae8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103ad8:	89 04 24             	mov    %eax,(%esp)
80103adb:	e8 50 d3 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103ae0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103ae7:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103ae8:	83 c6 01             	add    $0x1,%esi
80103aeb:	83 fe 10             	cmp    $0x10,%esi
80103aee:	75 e0                	jne    80103ad0 <exit+0x20>
  begin_op();
80103af0:	e8 2b f0 ff ff       	call   80102b20 <begin_op>
  iput(curproc->cwd);
80103af5:	8b 43 68             	mov    0x68(%ebx),%eax
80103af8:	89 04 24             	mov    %eax,(%esp)
80103afb:	e8 e0 dc ff ff       	call   801017e0 <iput>
  end_op();
80103b00:	e8 8b f0 ff ff       	call   80102b90 <end_op>
  curproc->cwd = 0;
80103b05:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103b0c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b13:	e8 38 06 00 00       	call   80104150 <acquire>
  wakeup1(curproc->parent);
80103b18:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b1b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b20:	eb 11                	jmp    80103b33 <exit+0x83>
80103b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b28:	83 ea 80             	sub    $0xffffff80,%edx
80103b2b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b31:	74 1d                	je     80103b50 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103b33:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b37:	75 ef                	jne    80103b28 <exit+0x78>
80103b39:	3b 42 20             	cmp    0x20(%edx),%eax
80103b3c:	75 ea                	jne    80103b28 <exit+0x78>
      p->state = RUNNABLE;
80103b3e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b45:	83 ea 80             	sub    $0xffffff80,%edx
80103b48:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b4e:	75 e3                	jne    80103b33 <exit+0x83>
      p->parent = initproc;
80103b50:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b55:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b5a:	eb 0f                	jmp    80103b6b <exit+0xbb>
80103b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b60:	83 e9 80             	sub    $0xffffff80,%ecx
80103b63:	81 f9 54 4d 11 80    	cmp    $0x80114d54,%ecx
80103b69:	74 34                	je     80103b9f <exit+0xef>
    if(p->parent == curproc){
80103b6b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b6e:	75 f0                	jne    80103b60 <exit+0xb0>
      if(p->state == ZOMBIE)
80103b70:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103b74:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103b77:	75 e7                	jne    80103b60 <exit+0xb0>
80103b79:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b7e:	eb 0b                	jmp    80103b8b <exit+0xdb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b80:	83 ea 80             	sub    $0xffffff80,%edx
80103b83:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b89:	74 d5                	je     80103b60 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103b8b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b8f:	75 ef                	jne    80103b80 <exit+0xd0>
80103b91:	3b 42 20             	cmp    0x20(%edx),%eax
80103b94:	75 ea                	jne    80103b80 <exit+0xd0>
      p->state = RUNNABLE;
80103b96:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103b9d:	eb e1                	jmp    80103b80 <exit+0xd0>
  curproc->state = ZOMBIE;
80103b9f:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ba6:	e8 65 fe ff ff       	call   80103a10 <sched>
  panic("zombie exit");
80103bab:	c7 04 24 3d 74 10 80 	movl   $0x8010743d,(%esp)
80103bb2:	e8 a9 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103bb7:	c7 04 24 30 74 10 80 	movl   $0x80107430,(%esp)
80103bbe:	e8 9d c7 ff ff       	call   80100360 <panic>
80103bc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bd0 <yield>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103bd6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bdd:	e8 6e 05 00 00       	call   80104150 <acquire>
  myproc()->state = RUNNABLE;
80103be2:	e8 c9 fa ff ff       	call   801036b0 <myproc>
80103be7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103bee:	e8 1d fe ff ff       	call   80103a10 <sched>
  release(&ptable.lock);
80103bf3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bfa:	e8 41 06 00 00       	call   80104240 <release>
}
80103bff:	c9                   	leave  
80103c00:	c3                   	ret    
80103c01:	eb 0d                	jmp    80103c10 <sleep>
80103c03:	90                   	nop
80103c04:	90                   	nop
80103c05:	90                   	nop
80103c06:	90                   	nop
80103c07:	90                   	nop
80103c08:	90                   	nop
80103c09:	90                   	nop
80103c0a:	90                   	nop
80103c0b:	90                   	nop
80103c0c:	90                   	nop
80103c0d:	90                   	nop
80103c0e:	90                   	nop
80103c0f:	90                   	nop

80103c10 <sleep>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	57                   	push   %edi
80103c14:	56                   	push   %esi
80103c15:	53                   	push   %ebx
80103c16:	83 ec 1c             	sub    $0x1c,%esp
80103c19:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c1f:	e8 8c fa ff ff       	call   801036b0 <myproc>
  if(p == 0)
80103c24:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103c26:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103c28:	0f 84 7c 00 00 00    	je     80103caa <sleep+0x9a>
  if(lk == 0)
80103c2e:	85 f6                	test   %esi,%esi
80103c30:	74 6c                	je     80103c9e <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c32:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c38:	74 46                	je     80103c80 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c3a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c41:	e8 0a 05 00 00       	call   80104150 <acquire>
    release(lk);
80103c46:	89 34 24             	mov    %esi,(%esp)
80103c49:	e8 f2 05 00 00       	call   80104240 <release>
  p->chan = chan;
80103c4e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c51:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103c58:	e8 b3 fd ff ff       	call   80103a10 <sched>
  p->chan = 0;
80103c5d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103c64:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c6b:	e8 d0 05 00 00       	call   80104240 <release>
    acquire(lk);
80103c70:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103c73:	83 c4 1c             	add    $0x1c,%esp
80103c76:	5b                   	pop    %ebx
80103c77:	5e                   	pop    %esi
80103c78:	5f                   	pop    %edi
80103c79:	5d                   	pop    %ebp
    acquire(lk);
80103c7a:	e9 d1 04 00 00       	jmp    80104150 <acquire>
80103c7f:	90                   	nop
  p->chan = chan;
80103c80:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103c83:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103c8a:	e8 81 fd ff ff       	call   80103a10 <sched>
  p->chan = 0;
80103c8f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103c96:	83 c4 1c             	add    $0x1c,%esp
80103c99:	5b                   	pop    %ebx
80103c9a:	5e                   	pop    %esi
80103c9b:	5f                   	pop    %edi
80103c9c:	5d                   	pop    %ebp
80103c9d:	c3                   	ret    
    panic("sleep without lk");
80103c9e:	c7 04 24 4f 74 10 80 	movl   $0x8010744f,(%esp)
80103ca5:	e8 b6 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103caa:	c7 04 24 49 74 10 80 	movl   $0x80107449,(%esp)
80103cb1:	e8 aa c6 ff ff       	call   80100360 <panic>
80103cb6:	8d 76 00             	lea    0x0(%esi),%esi
80103cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cc0 <wait>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
80103cc5:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103cc8:	e8 e3 f9 ff ff       	call   801036b0 <myproc>
  acquire(&ptable.lock);
80103ccd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103cd4:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103cd6:	e8 75 04 00 00       	call   80104150 <acquire>
    havekids = 0;
80103cdb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cdd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ce2:	eb 0f                	jmp    80103cf3 <wait+0x33>
80103ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ce8:	83 eb 80             	sub    $0xffffff80,%ebx
80103ceb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103cf1:	74 1d                	je     80103d10 <wait+0x50>
      if(p->parent != curproc)
80103cf3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103cf6:	75 f0                	jne    80103ce8 <wait+0x28>
      if(p->state == ZOMBIE){
80103cf8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103cfc:	74 2f                	je     80103d2d <wait+0x6d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cfe:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103d01:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d06:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103d0c:	75 e5                	jne    80103cf3 <wait+0x33>
80103d0e:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103d10:	85 c0                	test   %eax,%eax
80103d12:	74 6e                	je     80103d82 <wait+0xc2>
80103d14:	8b 46 24             	mov    0x24(%esi),%eax
80103d17:	85 c0                	test   %eax,%eax
80103d19:	75 67                	jne    80103d82 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d1b:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d22:	80 
80103d23:	89 34 24             	mov    %esi,(%esp)
80103d26:	e8 e5 fe ff ff       	call   80103c10 <sleep>
  }
80103d2b:	eb ae                	jmp    80103cdb <wait+0x1b>
        kfree(p->kstack);
80103d2d:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103d30:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d33:	89 04 24             	mov    %eax,(%esp)
80103d36:	e8 c5 e5 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
80103d3b:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103d3e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d45:	89 04 24             	mov    %eax,(%esp)
80103d48:	e8 73 2c 00 00       	call   801069c0 <freevm>
        release(&ptable.lock);
80103d4d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103d54:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d5b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103d62:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103d66:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103d6d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103d74:	e8 c7 04 00 00       	call   80104240 <release>
}
80103d79:	83 c4 10             	add    $0x10,%esp
        return pid;
80103d7c:	89 f0                	mov    %esi,%eax
}
80103d7e:	5b                   	pop    %ebx
80103d7f:	5e                   	pop    %esi
80103d80:	5d                   	pop    %ebp
80103d81:	c3                   	ret    
      release(&ptable.lock);
80103d82:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d89:	e8 b2 04 00 00       	call   80104240 <release>
}
80103d8e:	83 c4 10             	add    $0x10,%esp
      return -1;
80103d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d96:	5b                   	pop    %ebx
80103d97:	5e                   	pop    %esi
80103d98:	5d                   	pop    %ebp
80103d99:	c3                   	ret    
80103d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103da0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	53                   	push   %ebx
80103da4:	83 ec 14             	sub    $0x14,%esp
80103da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103daa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103db1:	e8 9a 03 00 00       	call   80104150 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103db6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dbb:	eb 0d                	jmp    80103dca <wakeup+0x2a>
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi
80103dc0:	83 e8 80             	sub    $0xffffff80,%eax
80103dc3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103dc8:	74 1e                	je     80103de8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103dca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dce:	75 f0                	jne    80103dc0 <wakeup+0x20>
80103dd0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103dd3:	75 eb                	jne    80103dc0 <wakeup+0x20>
      p->state = RUNNABLE;
80103dd5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ddc:	83 e8 80             	sub    $0xffffff80,%eax
80103ddf:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103de4:	75 e4                	jne    80103dca <wakeup+0x2a>
80103de6:	66 90                	xchg   %ax,%ax
  wakeup1(chan);
  release(&ptable.lock);
80103de8:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103def:	83 c4 14             	add    $0x14,%esp
80103df2:	5b                   	pop    %ebx
80103df3:	5d                   	pop    %ebp
  release(&ptable.lock);
80103df4:	e9 47 04 00 00       	jmp    80104240 <release>
80103df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e00 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	53                   	push   %ebx
80103e04:	83 ec 14             	sub    $0x14,%esp
80103e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e0a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e11:	e8 3a 03 00 00       	call   80104150 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e16:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e1b:	eb 0d                	jmp    80103e2a <kill+0x2a>
80103e1d:	8d 76 00             	lea    0x0(%esi),%esi
80103e20:	83 e8 80             	sub    $0xffffff80,%eax
80103e23:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e28:	74 36                	je     80103e60 <kill+0x60>
    if(p->pid == pid){
80103e2a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e2d:	75 f1                	jne    80103e20 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e2f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103e33:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103e3a:	74 14                	je     80103e50 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e3c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e43:	e8 f8 03 00 00       	call   80104240 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e48:	83 c4 14             	add    $0x14,%esp
      return 0;
80103e4b:	31 c0                	xor    %eax,%eax
}
80103e4d:	5b                   	pop    %ebx
80103e4e:	5d                   	pop    %ebp
80103e4f:	c3                   	ret    
        p->state = RUNNABLE;
80103e50:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e57:	eb e3                	jmp    80103e3c <kill+0x3c>
80103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103e60:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e67:	e8 d4 03 00 00       	call   80104240 <release>
}
80103e6c:	83 c4 14             	add    $0x14,%esp
  return -1;
80103e6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e74:	5b                   	pop    %ebx
80103e75:	5d                   	pop    %ebp
80103e76:	c3                   	ret    
80103e77:	89 f6                	mov    %esi,%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e80 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103e8b:	83 ec 4c             	sub    $0x4c,%esp
80103e8e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103e91:	eb 20                	jmp    80103eb3 <procdump+0x33>
80103e93:	90                   	nop
80103e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103e98:	c7 04 24 8b 78 10 80 	movl   $0x8010788b,(%esp)
80103e9f:	e8 ac c7 ff ff       	call   80100650 <cprintf>
80103ea4:	83 eb 80             	sub    $0xffffff80,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea7:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80103ead:	0f 84 8d 00 00 00    	je     80103f40 <procdump+0xc0>
    if(p->state == UNUSED)
80103eb3:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103eb6:	85 c0                	test   %eax,%eax
80103eb8:	74 ea                	je     80103ea4 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103eba:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103ebd:	ba 60 74 10 80       	mov    $0x80107460,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ec2:	77 11                	ja     80103ed5 <procdump+0x55>
80103ec4:	8b 14 85 c0 74 10 80 	mov    -0x7fef8b40(,%eax,4),%edx
      state = "???";
80103ecb:	b8 60 74 10 80       	mov    $0x80107460,%eax
80103ed0:	85 d2                	test   %edx,%edx
80103ed2:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103ed5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103ed8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103edc:	89 54 24 08          	mov    %edx,0x8(%esp)
80103ee0:	c7 04 24 64 74 10 80 	movl   $0x80107464,(%esp)
80103ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103eeb:	e8 60 c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103ef0:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103ef4:	75 a2                	jne    80103e98 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103ef6:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103efd:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f00:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f03:	8b 40 0c             	mov    0xc(%eax),%eax
80103f06:	83 c0 08             	add    $0x8,%eax
80103f09:	89 04 24             	mov    %eax,(%esp)
80103f0c:	e8 6f 01 00 00       	call   80104080 <getcallerpcs>
80103f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f18:	8b 17                	mov    (%edi),%edx
80103f1a:	85 d2                	test   %edx,%edx
80103f1c:	0f 84 76 ff ff ff    	je     80103e98 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f22:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f26:	83 c7 04             	add    $0x4,%edi
80103f29:	c7 04 24 61 6e 10 80 	movl   $0x80106e61,(%esp)
80103f30:	e8 1b c7 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f35:	39 f7                	cmp    %esi,%edi
80103f37:	75 df                	jne    80103f18 <procdump+0x98>
80103f39:	e9 5a ff ff ff       	jmp    80103e98 <procdump+0x18>
80103f3e:	66 90                	xchg   %ax,%ax
  }
}
80103f40:	83 c4 4c             	add    $0x4c,%esp
80103f43:	5b                   	pop    %ebx
80103f44:	5e                   	pop    %esi
80103f45:	5f                   	pop    %edi
80103f46:	5d                   	pop    %ebp
80103f47:	c3                   	ret    
80103f48:	66 90                	xchg   %ax,%ax
80103f4a:	66 90                	xchg   %ax,%ax
80103f4c:	66 90                	xchg   %ax,%ax
80103f4e:	66 90                	xchg   %ax,%ax

80103f50 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	53                   	push   %ebx
80103f54:	83 ec 14             	sub    $0x14,%esp
80103f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f5a:	c7 44 24 04 d8 74 10 	movl   $0x801074d8,0x4(%esp)
80103f61:	80 
80103f62:	8d 43 04             	lea    0x4(%ebx),%eax
80103f65:	89 04 24             	mov    %eax,(%esp)
80103f68:	e8 f3 00 00 00       	call   80104060 <initlock>
  lk->name = name;
80103f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103f70:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f76:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80103f7d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103f80:	83 c4 14             	add    $0x14,%esp
80103f83:	5b                   	pop    %ebx
80103f84:	5d                   	pop    %ebp
80103f85:	c3                   	ret    
80103f86:	8d 76 00             	lea    0x0(%esi),%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f90 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	56                   	push   %esi
80103f94:	53                   	push   %ebx
80103f95:	83 ec 10             	sub    $0x10,%esp
80103f98:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103f9b:	8d 73 04             	lea    0x4(%ebx),%esi
80103f9e:	89 34 24             	mov    %esi,(%esp)
80103fa1:	e8 aa 01 00 00       	call   80104150 <acquire>
  while (lk->locked) {
80103fa6:	8b 13                	mov    (%ebx),%edx
80103fa8:	85 d2                	test   %edx,%edx
80103faa:	74 16                	je     80103fc2 <acquiresleep+0x32>
80103fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103fb0:	89 74 24 04          	mov    %esi,0x4(%esp)
80103fb4:	89 1c 24             	mov    %ebx,(%esp)
80103fb7:	e8 54 fc ff ff       	call   80103c10 <sleep>
  while (lk->locked) {
80103fbc:	8b 03                	mov    (%ebx),%eax
80103fbe:	85 c0                	test   %eax,%eax
80103fc0:	75 ee                	jne    80103fb0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80103fc2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103fc8:	e8 e3 f6 ff ff       	call   801036b0 <myproc>
80103fcd:	8b 40 10             	mov    0x10(%eax),%eax
80103fd0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103fd3:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103fd6:	83 c4 10             	add    $0x10,%esp
80103fd9:	5b                   	pop    %ebx
80103fda:	5e                   	pop    %esi
80103fdb:	5d                   	pop    %ebp
  release(&lk->lk);
80103fdc:	e9 5f 02 00 00       	jmp    80104240 <release>
80103fe1:	eb 0d                	jmp    80103ff0 <releasesleep>
80103fe3:	90                   	nop
80103fe4:	90                   	nop
80103fe5:	90                   	nop
80103fe6:	90                   	nop
80103fe7:	90                   	nop
80103fe8:	90                   	nop
80103fe9:	90                   	nop
80103fea:	90                   	nop
80103feb:	90                   	nop
80103fec:	90                   	nop
80103fed:	90                   	nop
80103fee:	90                   	nop
80103fef:	90                   	nop

80103ff0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	56                   	push   %esi
80103ff4:	53                   	push   %ebx
80103ff5:	83 ec 10             	sub    $0x10,%esp
80103ff8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103ffb:	8d 73 04             	lea    0x4(%ebx),%esi
80103ffe:	89 34 24             	mov    %esi,(%esp)
80104001:	e8 4a 01 00 00       	call   80104150 <acquire>
  lk->locked = 0;
80104006:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010400c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104013:	89 1c 24             	mov    %ebx,(%esp)
80104016:	e8 85 fd ff ff       	call   80103da0 <wakeup>
  release(&lk->lk);
8010401b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010401e:	83 c4 10             	add    $0x10,%esp
80104021:	5b                   	pop    %ebx
80104022:	5e                   	pop    %esi
80104023:	5d                   	pop    %ebp
  release(&lk->lk);
80104024:	e9 17 02 00 00       	jmp    80104240 <release>
80104029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104030 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	56                   	push   %esi
80104034:	53                   	push   %ebx
80104035:	83 ec 10             	sub    $0x10,%esp
80104038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010403b:	8d 73 04             	lea    0x4(%ebx),%esi
8010403e:	89 34 24             	mov    %esi,(%esp)
80104041:	e8 0a 01 00 00       	call   80104150 <acquire>
  r = lk->locked;
80104046:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104048:	89 34 24             	mov    %esi,(%esp)
8010404b:	e8 f0 01 00 00       	call   80104240 <release>
  return r;
}
80104050:	83 c4 10             	add    $0x10,%esp
80104053:	89 d8                	mov    %ebx,%eax
80104055:	5b                   	pop    %ebx
80104056:	5e                   	pop    %esi
80104057:	5d                   	pop    %ebp
80104058:	c3                   	ret    
80104059:	66 90                	xchg   %ax,%ax
8010405b:	66 90                	xchg   %ax,%ax
8010405d:	66 90                	xchg   %ax,%ax
8010405f:	90                   	nop

80104060 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104066:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010406f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104072:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104079:	5d                   	pop    %ebp
8010407a:	c3                   	ret    
8010407b:	90                   	nop
8010407c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104080 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104083:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104086:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104089:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010408a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010408d:	31 c0                	xor    %eax,%eax
8010408f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104090:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104096:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010409c:	77 1a                	ja     801040b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010409e:	8b 5a 04             	mov    0x4(%edx),%ebx
801040a1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801040a4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801040a7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801040a9:	83 f8 0a             	cmp    $0xa,%eax
801040ac:	75 e2                	jne    80104090 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040ae:	5b                   	pop    %ebx
801040af:	5d                   	pop    %ebp
801040b0:	c3                   	ret    
801040b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801040b8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801040bf:	83 c0 01             	add    $0x1,%eax
801040c2:	83 f8 0a             	cmp    $0xa,%eax
801040c5:	74 e7                	je     801040ae <getcallerpcs+0x2e>
    pcs[i] = 0;
801040c7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801040ce:	83 c0 01             	add    $0x1,%eax
801040d1:	83 f8 0a             	cmp    $0xa,%eax
801040d4:	75 e2                	jne    801040b8 <getcallerpcs+0x38>
801040d6:	eb d6                	jmp    801040ae <getcallerpcs+0x2e>
801040d8:	90                   	nop
801040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040e0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801040e0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801040e1:	31 c0                	xor    %eax,%eax
{
801040e3:	89 e5                	mov    %esp,%ebp
801040e5:	53                   	push   %ebx
801040e6:	83 ec 04             	sub    $0x4,%esp
801040e9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801040ec:	8b 0a                	mov    (%edx),%ecx
801040ee:	85 c9                	test   %ecx,%ecx
801040f0:	74 10                	je     80104102 <holding+0x22>
801040f2:	8b 5a 08             	mov    0x8(%edx),%ebx
801040f5:	e8 16 f5 ff ff       	call   80103610 <mycpu>
801040fa:	39 c3                	cmp    %eax,%ebx
801040fc:	0f 94 c0             	sete   %al
801040ff:	0f b6 c0             	movzbl %al,%eax
}
80104102:	83 c4 04             	add    $0x4,%esp
80104105:	5b                   	pop    %ebx
80104106:	5d                   	pop    %ebp
80104107:	c3                   	ret    
80104108:	90                   	nop
80104109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104110 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 04             	sub    $0x4,%esp
80104117:	9c                   	pushf  
80104118:	5b                   	pop    %ebx
  asm volatile("cli");
80104119:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010411a:	e8 f1 f4 ff ff       	call   80103610 <mycpu>
8010411f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104125:	85 c0                	test   %eax,%eax
80104127:	75 11                	jne    8010413a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104129:	e8 e2 f4 ff ff       	call   80103610 <mycpu>
8010412e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104134:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010413a:	e8 d1 f4 ff ff       	call   80103610 <mycpu>
8010413f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104146:	83 c4 04             	add    $0x4,%esp
80104149:	5b                   	pop    %ebx
8010414a:	5d                   	pop    %ebp
8010414b:	c3                   	ret    
8010414c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104150 <acquire>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104157:	e8 b4 ff ff ff       	call   80104110 <pushcli>
  if(holding(lk))
8010415c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010415f:	8b 02                	mov    (%edx),%eax
80104161:	85 c0                	test   %eax,%eax
80104163:	75 43                	jne    801041a8 <acquire+0x58>
  asm volatile("lock; xchgl %0, %1" :
80104165:	b9 01 00 00 00       	mov    $0x1,%ecx
8010416a:	eb 07                	jmp    80104173 <acquire+0x23>
8010416c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104170:	8b 55 08             	mov    0x8(%ebp),%edx
80104173:	89 c8                	mov    %ecx,%eax
80104175:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
80104178:	85 c0                	test   %eax,%eax
8010417a:	75 f4                	jne    80104170 <acquire+0x20>
  __sync_synchronize();
8010417c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010417f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104182:	e8 89 f4 ff ff       	call   80103610 <mycpu>
80104187:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010418a:	8b 45 08             	mov    0x8(%ebp),%eax
8010418d:	83 c0 0c             	add    $0xc,%eax
80104190:	89 44 24 04          	mov    %eax,0x4(%esp)
80104194:	8d 45 08             	lea    0x8(%ebp),%eax
80104197:	89 04 24             	mov    %eax,(%esp)
8010419a:	e8 e1 fe ff ff       	call   80104080 <getcallerpcs>
}
8010419f:	83 c4 14             	add    $0x14,%esp
801041a2:	5b                   	pop    %ebx
801041a3:	5d                   	pop    %ebp
801041a4:	c3                   	ret    
801041a5:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
801041a8:	8b 5a 08             	mov    0x8(%edx),%ebx
801041ab:	e8 60 f4 ff ff       	call   80103610 <mycpu>
  if(holding(lk))
801041b0:	39 c3                	cmp    %eax,%ebx
801041b2:	74 05                	je     801041b9 <acquire+0x69>
801041b4:	8b 55 08             	mov    0x8(%ebp),%edx
801041b7:	eb ac                	jmp    80104165 <acquire+0x15>
    panic("acquire");
801041b9:	c7 04 24 e3 74 10 80 	movl   $0x801074e3,(%esp)
801041c0:	e8 9b c1 ff ff       	call   80100360 <panic>
801041c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041d0 <popcli>:

void
popcli(void)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041d6:	9c                   	pushf  
801041d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041d8:	f6 c4 02             	test   $0x2,%ah
801041db:	75 49                	jne    80104226 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801041dd:	e8 2e f4 ff ff       	call   80103610 <mycpu>
801041e2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801041e8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801041eb:	85 d2                	test   %edx,%edx
801041ed:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801041f3:	78 25                	js     8010421a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041f5:	e8 16 f4 ff ff       	call   80103610 <mycpu>
801041fa:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104200:	85 d2                	test   %edx,%edx
80104202:	74 04                	je     80104208 <popcli+0x38>
    sti();
}
80104204:	c9                   	leave  
80104205:	c3                   	ret    
80104206:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104208:	e8 03 f4 ff ff       	call   80103610 <mycpu>
8010420d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104213:	85 c0                	test   %eax,%eax
80104215:	74 ed                	je     80104204 <popcli+0x34>
  asm volatile("sti");
80104217:	fb                   	sti    
}
80104218:	c9                   	leave  
80104219:	c3                   	ret    
    panic("popcli");
8010421a:	c7 04 24 02 75 10 80 	movl   $0x80107502,(%esp)
80104221:	e8 3a c1 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104226:	c7 04 24 eb 74 10 80 	movl   $0x801074eb,(%esp)
8010422d:	e8 2e c1 ff ff       	call   80100360 <panic>
80104232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104240 <release>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
80104245:	83 ec 10             	sub    $0x10,%esp
80104248:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010424b:	8b 03                	mov    (%ebx),%eax
8010424d:	85 c0                	test   %eax,%eax
8010424f:	75 0f                	jne    80104260 <release+0x20>
    panic("release");
80104251:	c7 04 24 09 75 10 80 	movl   $0x80107509,(%esp)
80104258:	e8 03 c1 ff ff       	call   80100360 <panic>
8010425d:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104260:	8b 73 08             	mov    0x8(%ebx),%esi
80104263:	e8 a8 f3 ff ff       	call   80103610 <mycpu>
  if(!holding(lk))
80104268:	39 c6                	cmp    %eax,%esi
8010426a:	75 e5                	jne    80104251 <release+0x11>
  lk->pcs[0] = 0;
8010426c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104273:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010427a:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010427d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104283:	83 c4 10             	add    $0x10,%esp
80104286:	5b                   	pop    %ebx
80104287:	5e                   	pop    %esi
80104288:	5d                   	pop    %ebp
  popcli();
80104289:	e9 42 ff ff ff       	jmp    801041d0 <popcli>
8010428e:	66 90                	xchg   %ax,%ax

80104290 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	8b 55 08             	mov    0x8(%ebp),%edx
80104296:	57                   	push   %edi
80104297:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010429a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010429b:	f6 c2 03             	test   $0x3,%dl
8010429e:	75 05                	jne    801042a5 <memset+0x15>
801042a0:	f6 c1 03             	test   $0x3,%cl
801042a3:	74 13                	je     801042b8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801042a5:	89 d7                	mov    %edx,%edi
801042a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801042aa:	fc                   	cld    
801042ab:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801042ad:	5b                   	pop    %ebx
801042ae:	89 d0                	mov    %edx,%eax
801042b0:	5f                   	pop    %edi
801042b1:	5d                   	pop    %ebp
801042b2:	c3                   	ret    
801042b3:	90                   	nop
801042b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801042b8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801042bc:	c1 e9 02             	shr    $0x2,%ecx
801042bf:	89 f8                	mov    %edi,%eax
801042c1:	89 fb                	mov    %edi,%ebx
801042c3:	c1 e0 18             	shl    $0x18,%eax
801042c6:	c1 e3 10             	shl    $0x10,%ebx
801042c9:	09 d8                	or     %ebx,%eax
801042cb:	09 f8                	or     %edi,%eax
801042cd:	c1 e7 08             	shl    $0x8,%edi
801042d0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801042d2:	89 d7                	mov    %edx,%edi
801042d4:	fc                   	cld    
801042d5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801042d7:	5b                   	pop    %ebx
801042d8:	89 d0                	mov    %edx,%eax
801042da:	5f                   	pop    %edi
801042db:	5d                   	pop    %ebp
801042dc:	c3                   	ret    
801042dd:	8d 76 00             	lea    0x0(%esi),%esi

801042e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	8b 45 10             	mov    0x10(%ebp),%eax
801042e6:	57                   	push   %edi
801042e7:	56                   	push   %esi
801042e8:	8b 75 0c             	mov    0xc(%ebp),%esi
801042eb:	53                   	push   %ebx
801042ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801042ef:	85 c0                	test   %eax,%eax
801042f1:	8d 78 ff             	lea    -0x1(%eax),%edi
801042f4:	74 26                	je     8010431c <memcmp+0x3c>
    if(*s1 != *s2)
801042f6:	0f b6 03             	movzbl (%ebx),%eax
801042f9:	31 d2                	xor    %edx,%edx
801042fb:	0f b6 0e             	movzbl (%esi),%ecx
801042fe:	38 c8                	cmp    %cl,%al
80104300:	74 16                	je     80104318 <memcmp+0x38>
80104302:	eb 24                	jmp    80104328 <memcmp+0x48>
80104304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104308:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010430d:	83 c2 01             	add    $0x1,%edx
80104310:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104314:	38 c8                	cmp    %cl,%al
80104316:	75 10                	jne    80104328 <memcmp+0x48>
  while(n-- > 0){
80104318:	39 fa                	cmp    %edi,%edx
8010431a:	75 ec                	jne    80104308 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010431c:	5b                   	pop    %ebx
  return 0;
8010431d:	31 c0                	xor    %eax,%eax
}
8010431f:	5e                   	pop    %esi
80104320:	5f                   	pop    %edi
80104321:	5d                   	pop    %ebp
80104322:	c3                   	ret    
80104323:	90                   	nop
80104324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104328:	5b                   	pop    %ebx
      return *s1 - *s2;
80104329:	29 c8                	sub    %ecx,%eax
}
8010432b:	5e                   	pop    %esi
8010432c:	5f                   	pop    %edi
8010432d:	5d                   	pop    %ebp
8010432e:	c3                   	ret    
8010432f:	90                   	nop

80104330 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	8b 45 08             	mov    0x8(%ebp),%eax
80104337:	56                   	push   %esi
80104338:	8b 75 0c             	mov    0xc(%ebp),%esi
8010433b:	53                   	push   %ebx
8010433c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010433f:	39 c6                	cmp    %eax,%esi
80104341:	73 35                	jae    80104378 <memmove+0x48>
80104343:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104346:	39 c8                	cmp    %ecx,%eax
80104348:	73 2e                	jae    80104378 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010434a:	85 db                	test   %ebx,%ebx
    d += n;
8010434c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010434f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104352:	74 1b                	je     8010436f <memmove+0x3f>
80104354:	f7 db                	neg    %ebx
80104356:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104359:	01 fb                	add    %edi,%ebx
8010435b:	90                   	nop
8010435c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104360:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104364:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104367:	83 ea 01             	sub    $0x1,%edx
8010436a:	83 fa ff             	cmp    $0xffffffff,%edx
8010436d:	75 f1                	jne    80104360 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010436f:	5b                   	pop    %ebx
80104370:	5e                   	pop    %esi
80104371:	5f                   	pop    %edi
80104372:	5d                   	pop    %ebp
80104373:	c3                   	ret    
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104378:	31 d2                	xor    %edx,%edx
8010437a:	85 db                	test   %ebx,%ebx
8010437c:	74 f1                	je     8010436f <memmove+0x3f>
8010437e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104380:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104384:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104387:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010438a:	39 da                	cmp    %ebx,%edx
8010438c:	75 f2                	jne    80104380 <memmove+0x50>
}
8010438e:	5b                   	pop    %ebx
8010438f:	5e                   	pop    %esi
80104390:	5f                   	pop    %edi
80104391:	5d                   	pop    %ebp
80104392:	c3                   	ret    
80104393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801043a3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801043a4:	eb 8a                	jmp    80104330 <memmove>
801043a6:	8d 76 00             	lea    0x0(%esi),%esi
801043a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043b0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	56                   	push   %esi
801043b4:	8b 75 10             	mov    0x10(%ebp),%esi
801043b7:	53                   	push   %ebx
801043b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801043be:	85 f6                	test   %esi,%esi
801043c0:	74 30                	je     801043f2 <strncmp+0x42>
801043c2:	0f b6 01             	movzbl (%ecx),%eax
801043c5:	84 c0                	test   %al,%al
801043c7:	74 2f                	je     801043f8 <strncmp+0x48>
801043c9:	0f b6 13             	movzbl (%ebx),%edx
801043cc:	38 d0                	cmp    %dl,%al
801043ce:	75 46                	jne    80104416 <strncmp+0x66>
801043d0:	8d 51 01             	lea    0x1(%ecx),%edx
801043d3:	01 ce                	add    %ecx,%esi
801043d5:	eb 14                	jmp    801043eb <strncmp+0x3b>
801043d7:	90                   	nop
801043d8:	0f b6 02             	movzbl (%edx),%eax
801043db:	84 c0                	test   %al,%al
801043dd:	74 31                	je     80104410 <strncmp+0x60>
801043df:	0f b6 19             	movzbl (%ecx),%ebx
801043e2:	83 c2 01             	add    $0x1,%edx
801043e5:	38 d8                	cmp    %bl,%al
801043e7:	75 17                	jne    80104400 <strncmp+0x50>
    n--, p++, q++;
801043e9:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
801043eb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801043ed:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
801043f0:	75 e6                	jne    801043d8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801043f2:	5b                   	pop    %ebx
    return 0;
801043f3:	31 c0                	xor    %eax,%eax
}
801043f5:	5e                   	pop    %esi
801043f6:	5d                   	pop    %ebp
801043f7:	c3                   	ret    
801043f8:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
801043fb:	31 c0                	xor    %eax,%eax
801043fd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104400:	0f b6 d3             	movzbl %bl,%edx
80104403:	29 d0                	sub    %edx,%eax
}
80104405:	5b                   	pop    %ebx
80104406:	5e                   	pop    %esi
80104407:	5d                   	pop    %ebp
80104408:	c3                   	ret    
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104410:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104414:	eb ea                	jmp    80104400 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
80104416:	89 d3                	mov    %edx,%ebx
80104418:	eb e6                	jmp    80104400 <strncmp+0x50>
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104420 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	8b 45 08             	mov    0x8(%ebp),%eax
80104426:	56                   	push   %esi
80104427:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010442a:	53                   	push   %ebx
8010442b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010442e:	89 c2                	mov    %eax,%edx
80104430:	eb 19                	jmp    8010444b <strncpy+0x2b>
80104432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104438:	83 c3 01             	add    $0x1,%ebx
8010443b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010443f:	83 c2 01             	add    $0x1,%edx
80104442:	84 c9                	test   %cl,%cl
80104444:	88 4a ff             	mov    %cl,-0x1(%edx)
80104447:	74 09                	je     80104452 <strncpy+0x32>
80104449:	89 f1                	mov    %esi,%ecx
8010444b:	85 c9                	test   %ecx,%ecx
8010444d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104450:	7f e6                	jg     80104438 <strncpy+0x18>
    ;
  while(n-- > 0)
80104452:	31 c9                	xor    %ecx,%ecx
80104454:	85 f6                	test   %esi,%esi
80104456:	7e 0f                	jle    80104467 <strncpy+0x47>
    *s++ = 0;
80104458:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010445c:	89 f3                	mov    %esi,%ebx
8010445e:	83 c1 01             	add    $0x1,%ecx
80104461:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104463:	85 db                	test   %ebx,%ebx
80104465:	7f f1                	jg     80104458 <strncpy+0x38>
  return os;
}
80104467:	5b                   	pop    %ebx
80104468:	5e                   	pop    %esi
80104469:	5d                   	pop    %ebp
8010446a:	c3                   	ret    
8010446b:	90                   	nop
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104470 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104476:	56                   	push   %esi
80104477:	8b 45 08             	mov    0x8(%ebp),%eax
8010447a:	53                   	push   %ebx
8010447b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010447e:	85 c9                	test   %ecx,%ecx
80104480:	7e 26                	jle    801044a8 <safestrcpy+0x38>
80104482:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104486:	89 c1                	mov    %eax,%ecx
80104488:	eb 17                	jmp    801044a1 <safestrcpy+0x31>
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104490:	83 c2 01             	add    $0x1,%edx
80104493:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104497:	83 c1 01             	add    $0x1,%ecx
8010449a:	84 db                	test   %bl,%bl
8010449c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010449f:	74 04                	je     801044a5 <safestrcpy+0x35>
801044a1:	39 f2                	cmp    %esi,%edx
801044a3:	75 eb                	jne    80104490 <safestrcpy+0x20>
    ;
  *s = 0;
801044a5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801044a8:	5b                   	pop    %ebx
801044a9:	5e                   	pop    %esi
801044aa:	5d                   	pop    %ebp
801044ab:	c3                   	ret    
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044b0 <strlen>:

int
strlen(const char *s)
{
801044b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801044b1:	31 c0                	xor    %eax,%eax
{
801044b3:	89 e5                	mov    %esp,%ebp
801044b5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801044b8:	80 3a 00             	cmpb   $0x0,(%edx)
801044bb:	74 0c                	je     801044c9 <strlen+0x19>
801044bd:	8d 76 00             	lea    0x0(%esi),%esi
801044c0:	83 c0 01             	add    $0x1,%eax
801044c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044c7:	75 f7                	jne    801044c0 <strlen+0x10>
    ;
  return n;
}
801044c9:	5d                   	pop    %ebp
801044ca:	c3                   	ret    

801044cb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801044d3:	55                   	push   %ebp
  pushl %ebx
801044d4:	53                   	push   %ebx
  pushl %esi
801044d5:	56                   	push   %esi
  pushl %edi
801044d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044d9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801044db:	5f                   	pop    %edi
  popl %esi
801044dc:	5e                   	pop    %esi
  popl %ebx
801044dd:	5b                   	pop    %ebx
  popl %ebp
801044de:	5d                   	pop    %ebp
  ret
801044df:	c3                   	ret    

801044e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
  *ip = *(int*)(addr);
801044e3:	8b 45 08             	mov    0x8(%ebp),%eax
801044e6:	8b 10                	mov    (%eax),%edx
801044e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801044eb:	89 10                	mov    %edx,(%eax)
  return 0;
}
801044ed:	31 c0                	xor    %eax,%eax
801044ef:	5d                   	pop    %ebp
801044f0:	c3                   	ret    
801044f1:	eb 0d                	jmp    80104500 <fetchstr>
801044f3:	90                   	nop
801044f4:	90                   	nop
801044f5:	90                   	nop
801044f6:	90                   	nop
801044f7:	90                   	nop
801044f8:	90                   	nop
801044f9:	90                   	nop
801044fa:	90                   	nop
801044fb:	90                   	nop
801044fc:	90                   	nop
801044fd:	90                   	nop
801044fe:	90                   	nop
801044ff:	90                   	nop

80104500 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	8b 55 08             	mov    0x8(%ebp),%edx
  char *s, *ep;
  *pp = (char*)addr;
80104506:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ep = (char*)KERNBASE;
  for(s = *pp; s < ep; s++){
80104509:	81 fa ff ff ff 7f    	cmp    $0x7fffffff,%edx
  *pp = (char*)addr;
8010450f:	89 11                	mov    %edx,(%ecx)
  for(s = *pp; s < ep; s++){
80104511:	77 1c                	ja     8010452f <fetchstr+0x2f>
    if(*s == 0)
80104513:	80 3a 00             	cmpb   $0x0,(%edx)
80104516:	89 d0                	mov    %edx,%eax
80104518:	75 0b                	jne    80104525 <fetchstr+0x25>
8010451a:	eb 1c                	jmp    80104538 <fetchstr+0x38>
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104520:	80 38 00             	cmpb   $0x0,(%eax)
80104523:	74 13                	je     80104538 <fetchstr+0x38>
  for(s = *pp; s < ep; s++){
80104525:	83 c0 01             	add    $0x1,%eax
80104528:	3d 00 00 00 80       	cmp    $0x80000000,%eax
8010452d:	75 f1                	jne    80104520 <fetchstr+0x20>
      return s - *pp;
  }
  return -1;
8010452f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104534:	5d                   	pop    %ebp
80104535:	c3                   	ret    
80104536:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104538:	29 d0                	sub    %edx,%eax
}
8010453a:	5d                   	pop    %ebp
8010453b:	c3                   	ret    
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104540 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104546:	e8 65 f1 ff ff       	call   801036b0 <myproc>
  *ip = *(int*)(addr);
8010454b:	8b 55 08             	mov    0x8(%ebp),%edx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010454e:	8b 40 18             	mov    0x18(%eax),%eax
  *ip = *(int*)(addr);
80104551:	8b 40 44             	mov    0x44(%eax),%eax
80104554:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
80104558:	8b 45 0c             	mov    0xc(%ebp),%eax
8010455b:	89 10                	mov    %edx,(%eax)
}
8010455d:	31 c0                	xor    %eax,%eax
8010455f:	c9                   	leave  
80104560:	c3                   	ret    
80104561:	eb 0d                	jmp    80104570 <argptr>
80104563:	90                   	nop
80104564:	90                   	nop
80104565:	90                   	nop
80104566:	90                   	nop
80104567:	90                   	nop
80104568:	90                   	nop
80104569:	90                   	nop
8010456a:	90                   	nop
8010456b:	90                   	nop
8010456c:	90                   	nop
8010456d:	90                   	nop
8010456e:	90                   	nop
8010456f:	90                   	nop

80104570 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104576:	e8 35 f1 ff ff       	call   801036b0 <myproc>
  int i;
 
  if(argint(n, &i) < 0)
    return -1;
  *pp = (char*)i;
8010457b:	8b 55 08             	mov    0x8(%ebp),%edx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010457e:	8b 40 18             	mov    0x18(%eax),%eax
  *ip = *(int*)(addr);
80104581:	8b 40 44             	mov    0x44(%eax),%eax
  *pp = (char*)i;
80104584:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
80104588:	8b 45 0c             	mov    0xc(%ebp),%eax
8010458b:	89 10                	mov    %edx,(%eax)
  return 0;
}
8010458d:	31 c0                	xor    %eax,%eax
8010458f:	c9                   	leave  
80104590:	c3                   	ret    
80104591:	eb 0d                	jmp    801045a0 <argstr>
80104593:	90                   	nop
80104594:	90                   	nop
80104595:	90                   	nop
80104596:	90                   	nop
80104597:	90                   	nop
80104598:	90                   	nop
80104599:	90                   	nop
8010459a:	90                   	nop
8010459b:	90                   	nop
8010459c:	90                   	nop
8010459d:	90                   	nop
8010459e:	90                   	nop
8010459f:	90                   	nop

801045a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045a6:	e8 05 f1 ff ff       	call   801036b0 <myproc>
  *ip = *(int*)(addr);
801045ab:	8b 55 08             	mov    0x8(%ebp),%edx
  *pp = (char*)addr;
801045ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045b1:	8b 40 18             	mov    0x18(%eax),%eax
  *ip = *(int*)(addr);
801045b4:	8b 40 44             	mov    0x44(%eax),%eax
801045b7:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
  for(s = *pp; s < ep; s++){
801045bb:	81 fa ff ff ff 7f    	cmp    $0x7fffffff,%edx
  *pp = (char*)addr;
801045c1:	89 11                	mov    %edx,(%ecx)
  for(s = *pp; s < ep; s++){
801045c3:	77 15                	ja     801045da <argstr+0x3a>
    if(*s == 0)
801045c5:	80 3a 00             	cmpb   $0x0,(%edx)
801045c8:	89 d0                	mov    %edx,%eax
801045ca:	75 09                	jne    801045d5 <argstr+0x35>
801045cc:	eb 1a                	jmp    801045e8 <argstr+0x48>
801045ce:	66 90                	xchg   %ax,%ax
801045d0:	80 38 00             	cmpb   $0x0,(%eax)
801045d3:	74 13                	je     801045e8 <argstr+0x48>
  for(s = *pp; s < ep; s++){
801045d5:	83 c0 01             	add    $0x1,%eax
801045d8:	79 f6                	jns    801045d0 <argstr+0x30>
  return -1;
801045da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801045df:	c9                   	leave  
801045e0:	c3                   	ret    
801045e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return s - *pp;
801045e8:	29 d0                	sub    %edx,%eax
}
801045ea:	c9                   	leave  
801045eb:	c3                   	ret    
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045f0 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
801045f8:	e8 b3 f0 ff ff       	call   801036b0 <myproc>

  num = curproc->tf->eax;
801045fd:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104600:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104602:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104605:	8d 50 ff             	lea    -0x1(%eax),%edx
80104608:	83 fa 16             	cmp    $0x16,%edx
8010460b:	77 1b                	ja     80104628 <syscall+0x38>
8010460d:	8b 14 85 40 75 10 80 	mov    -0x7fef8ac0(,%eax,4),%edx
80104614:	85 d2                	test   %edx,%edx
80104616:	74 10                	je     80104628 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104618:	ff d2                	call   *%edx
8010461a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010461d:	83 c4 10             	add    $0x10,%esp
80104620:	5b                   	pop    %ebx
80104621:	5e                   	pop    %esi
80104622:	5d                   	pop    %ebp
80104623:	c3                   	ret    
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104628:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010462c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010462f:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104633:	8b 43 10             	mov    0x10(%ebx),%eax
80104636:	c7 04 24 11 75 10 80 	movl   $0x80107511,(%esp)
8010463d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104641:	e8 0a c0 ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80104646:	8b 43 18             	mov    0x18(%ebx),%eax
80104649:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104650:	83 c4 10             	add    $0x10,%esp
80104653:	5b                   	pop    %ebx
80104654:	5e                   	pop    %esi
80104655:	5d                   	pop    %ebp
80104656:	c3                   	ret    
80104657:	66 90                	xchg   %ax,%ax
80104659:	66 90                	xchg   %ax,%ax
8010465b:	66 90                	xchg   %ax,%ax
8010465d:	66 90                	xchg   %ax,%ax
8010465f:	90                   	nop

80104660 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	89 c3                	mov    %eax,%ebx
80104666:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104669:	e8 42 f0 ff ff       	call   801036b0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010466e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104670:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104674:	85 c9                	test   %ecx,%ecx
80104676:	74 18                	je     80104690 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104678:	83 c2 01             	add    $0x1,%edx
8010467b:	83 fa 10             	cmp    $0x10,%edx
8010467e:	75 f0                	jne    80104670 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104680:	83 c4 04             	add    $0x4,%esp
  return -1;
80104683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104688:	5b                   	pop    %ebx
80104689:	5d                   	pop    %ebp
8010468a:	c3                   	ret    
8010468b:	90                   	nop
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104690:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
80104694:	83 c4 04             	add    $0x4,%esp
      return fd;
80104697:	89 d0                	mov    %edx,%eax
}
80104699:	5b                   	pop    %ebx
8010469a:	5d                   	pop    %ebp
8010469b:	c3                   	ret    
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046a0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	57                   	push   %edi
801046a4:	56                   	push   %esi
801046a5:	53                   	push   %ebx
801046a6:	83 ec 4c             	sub    $0x4c,%esp
801046a9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801046ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801046af:	8d 5d da             	lea    -0x26(%ebp),%ebx
801046b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801046b6:	89 04 24             	mov    %eax,(%esp)
{
801046b9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801046bc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801046bf:	e8 6c d8 ff ff       	call   80101f30 <nameiparent>
801046c4:	85 c0                	test   %eax,%eax
801046c6:	89 c7                	mov    %eax,%edi
801046c8:	0f 84 da 00 00 00    	je     801047a8 <create+0x108>
    return 0;
  ilock(dp);
801046ce:	89 04 24             	mov    %eax,(%esp)
801046d1:	e8 ea cf ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801046d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801046d9:	89 44 24 08          	mov    %eax,0x8(%esp)
801046dd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801046e1:	89 3c 24             	mov    %edi,(%esp)
801046e4:	e8 e7 d4 ff ff       	call   80101bd0 <dirlookup>
801046e9:	85 c0                	test   %eax,%eax
801046eb:	89 c6                	mov    %eax,%esi
801046ed:	74 41                	je     80104730 <create+0x90>
    iunlockput(dp);
801046ef:	89 3c 24             	mov    %edi,(%esp)
801046f2:	e8 29 d2 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
801046f7:	89 34 24             	mov    %esi,(%esp)
801046fa:	e8 c1 cf ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801046ff:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104704:	75 12                	jne    80104718 <create+0x78>
80104706:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010470b:	89 f0                	mov    %esi,%eax
8010470d:	75 09                	jne    80104718 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010470f:	83 c4 4c             	add    $0x4c,%esp
80104712:	5b                   	pop    %ebx
80104713:	5e                   	pop    %esi
80104714:	5f                   	pop    %edi
80104715:	5d                   	pop    %ebp
80104716:	c3                   	ret    
80104717:	90                   	nop
    iunlockput(ip);
80104718:	89 34 24             	mov    %esi,(%esp)
8010471b:	e8 00 d2 ff ff       	call   80101920 <iunlockput>
}
80104720:	83 c4 4c             	add    $0x4c,%esp
    return 0;
80104723:	31 c0                	xor    %eax,%eax
}
80104725:	5b                   	pop    %ebx
80104726:	5e                   	pop    %esi
80104727:	5f                   	pop    %edi
80104728:	5d                   	pop    %ebp
80104729:	c3                   	ret    
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104730:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104734:	89 44 24 04          	mov    %eax,0x4(%esp)
80104738:	8b 07                	mov    (%edi),%eax
8010473a:	89 04 24             	mov    %eax,(%esp)
8010473d:	e8 ee cd ff ff       	call   80101530 <ialloc>
80104742:	85 c0                	test   %eax,%eax
80104744:	89 c6                	mov    %eax,%esi
80104746:	0f 84 bf 00 00 00    	je     8010480b <create+0x16b>
  ilock(ip);
8010474c:	89 04 24             	mov    %eax,(%esp)
8010474f:	e8 6c cf ff ff       	call   801016c0 <ilock>
  ip->major = major;
80104754:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104758:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010475c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104760:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104764:	b8 01 00 00 00       	mov    $0x1,%eax
80104769:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010476d:	89 34 24             	mov    %esi,(%esp)
80104770:	e8 8b ce ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104775:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010477a:	74 34                	je     801047b0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
8010477c:	8b 46 04             	mov    0x4(%esi),%eax
8010477f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104783:	89 3c 24             	mov    %edi,(%esp)
80104786:	89 44 24 08          	mov    %eax,0x8(%esp)
8010478a:	e8 a1 d6 ff ff       	call   80101e30 <dirlink>
8010478f:	85 c0                	test   %eax,%eax
80104791:	78 6c                	js     801047ff <create+0x15f>
  iunlockput(dp);
80104793:	89 3c 24             	mov    %edi,(%esp)
80104796:	e8 85 d1 ff ff       	call   80101920 <iunlockput>
}
8010479b:	83 c4 4c             	add    $0x4c,%esp
  return ip;
8010479e:	89 f0                	mov    %esi,%eax
}
801047a0:	5b                   	pop    %ebx
801047a1:	5e                   	pop    %esi
801047a2:	5f                   	pop    %edi
801047a3:	5d                   	pop    %ebp
801047a4:	c3                   	ret    
801047a5:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801047a8:	31 c0                	xor    %eax,%eax
801047aa:	e9 60 ff ff ff       	jmp    8010470f <create+0x6f>
801047af:	90                   	nop
    dp->nlink++;  // for ".."
801047b0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801047b5:	89 3c 24             	mov    %edi,(%esp)
801047b8:	e8 43 ce ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801047bd:	8b 46 04             	mov    0x4(%esi),%eax
801047c0:	c7 44 24 04 bc 75 10 	movl   $0x801075bc,0x4(%esp)
801047c7:	80 
801047c8:	89 34 24             	mov    %esi,(%esp)
801047cb:	89 44 24 08          	mov    %eax,0x8(%esp)
801047cf:	e8 5c d6 ff ff       	call   80101e30 <dirlink>
801047d4:	85 c0                	test   %eax,%eax
801047d6:	78 1b                	js     801047f3 <create+0x153>
801047d8:	8b 47 04             	mov    0x4(%edi),%eax
801047db:	c7 44 24 04 bb 75 10 	movl   $0x801075bb,0x4(%esp)
801047e2:	80 
801047e3:	89 34 24             	mov    %esi,(%esp)
801047e6:	89 44 24 08          	mov    %eax,0x8(%esp)
801047ea:	e8 41 d6 ff ff       	call   80101e30 <dirlink>
801047ef:	85 c0                	test   %eax,%eax
801047f1:	79 89                	jns    8010477c <create+0xdc>
      panic("create dots");
801047f3:	c7 04 24 af 75 10 80 	movl   $0x801075af,(%esp)
801047fa:	e8 61 bb ff ff       	call   80100360 <panic>
    panic("create: dirlink");
801047ff:	c7 04 24 be 75 10 80 	movl   $0x801075be,(%esp)
80104806:	e8 55 bb ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010480b:	c7 04 24 a0 75 10 80 	movl   $0x801075a0,(%esp)
80104812:	e8 49 bb ff ff       	call   80100360 <panic>
80104817:	89 f6                	mov    %esi,%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	89 c6                	mov    %eax,%esi
80104826:	53                   	push   %ebx
80104827:	89 d3                	mov    %edx,%ebx
80104829:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
8010482c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010482f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104833:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010483a:	e8 01 fd ff ff       	call   80104540 <argint>
8010483f:	85 c0                	test   %eax,%eax
80104841:	78 2d                	js     80104870 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104843:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104847:	77 27                	ja     80104870 <argfd.constprop.0+0x50>
80104849:	e8 62 ee ff ff       	call   801036b0 <myproc>
8010484e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104851:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104855:	85 c0                	test   %eax,%eax
80104857:	74 17                	je     80104870 <argfd.constprop.0+0x50>
  if(pfd)
80104859:	85 f6                	test   %esi,%esi
8010485b:	74 02                	je     8010485f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010485d:	89 16                	mov    %edx,(%esi)
  if(pf)
8010485f:	85 db                	test   %ebx,%ebx
80104861:	74 1d                	je     80104880 <argfd.constprop.0+0x60>
    *pf = f;
80104863:	89 03                	mov    %eax,(%ebx)
  return 0;
80104865:	31 c0                	xor    %eax,%eax
}
80104867:	83 c4 20             	add    $0x20,%esp
8010486a:	5b                   	pop    %ebx
8010486b:	5e                   	pop    %esi
8010486c:	5d                   	pop    %ebp
8010486d:	c3                   	ret    
8010486e:	66 90                	xchg   %ax,%ax
80104870:	83 c4 20             	add    $0x20,%esp
    return -1;
80104873:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104878:	5b                   	pop    %ebx
80104879:	5e                   	pop    %esi
8010487a:	5d                   	pop    %ebp
8010487b:	c3                   	ret    
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104880:	31 c0                	xor    %eax,%eax
80104882:	eb e3                	jmp    80104867 <argfd.constprop.0+0x47>
80104884:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010488a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104890 <sys_dup>:
{
80104890:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104891:	31 c0                	xor    %eax,%eax
{
80104893:	89 e5                	mov    %esp,%ebp
80104895:	53                   	push   %ebx
80104896:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104899:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010489c:	e8 7f ff ff ff       	call   80104820 <argfd.constprop.0>
801048a1:	85 c0                	test   %eax,%eax
801048a3:	78 23                	js     801048c8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801048a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a8:	e8 b3 fd ff ff       	call   80104660 <fdalloc>
801048ad:	85 c0                	test   %eax,%eax
801048af:	89 c3                	mov    %eax,%ebx
801048b1:	78 15                	js     801048c8 <sys_dup+0x38>
  filedup(f);
801048b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b6:	89 04 24             	mov    %eax,(%esp)
801048b9:	e8 22 c5 ff ff       	call   80100de0 <filedup>
  return fd;
801048be:	89 d8                	mov    %ebx,%eax
}
801048c0:	83 c4 24             	add    $0x24,%esp
801048c3:	5b                   	pop    %ebx
801048c4:	5d                   	pop    %ebp
801048c5:	c3                   	ret    
801048c6:	66 90                	xchg   %ax,%ax
    return -1;
801048c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048cd:	eb f1                	jmp    801048c0 <sys_dup+0x30>
801048cf:	90                   	nop

801048d0 <sys_read>:
{
801048d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048d1:	31 c0                	xor    %eax,%eax
{
801048d3:	89 e5                	mov    %esp,%ebp
801048d5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801048db:	e8 40 ff ff ff       	call   80104820 <argfd.constprop.0>
801048e0:	85 c0                	test   %eax,%eax
801048e2:	78 54                	js     80104938 <sys_read+0x68>
801048e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801048e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801048eb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801048f2:	e8 49 fc ff ff       	call   80104540 <argint>
801048f7:	85 c0                	test   %eax,%eax
801048f9:	78 3d                	js     80104938 <sys_read+0x68>
801048fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104905:	89 44 24 08          	mov    %eax,0x8(%esp)
80104909:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010490c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104910:	e8 5b fc ff ff       	call   80104570 <argptr>
80104915:	85 c0                	test   %eax,%eax
80104917:	78 1f                	js     80104938 <sys_read+0x68>
  return fileread(f, p, n);
80104919:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010491c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104920:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104923:	89 44 24 04          	mov    %eax,0x4(%esp)
80104927:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010492a:	89 04 24             	mov    %eax,(%esp)
8010492d:	e8 0e c6 ff ff       	call   80100f40 <fileread>
}
80104932:	c9                   	leave  
80104933:	c3                   	ret    
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104938:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010493d:	c9                   	leave  
8010493e:	c3                   	ret    
8010493f:	90                   	nop

80104940 <sys_write>:
{
80104940:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104941:	31 c0                	xor    %eax,%eax
{
80104943:	89 e5                	mov    %esp,%ebp
80104945:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104948:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010494b:	e8 d0 fe ff ff       	call   80104820 <argfd.constprop.0>
80104950:	85 c0                	test   %eax,%eax
80104952:	78 54                	js     801049a8 <sys_write+0x68>
80104954:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104957:	89 44 24 04          	mov    %eax,0x4(%esp)
8010495b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104962:	e8 d9 fb ff ff       	call   80104540 <argint>
80104967:	85 c0                	test   %eax,%eax
80104969:	78 3d                	js     801049a8 <sys_write+0x68>
8010496b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010496e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104975:	89 44 24 08          	mov    %eax,0x8(%esp)
80104979:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010497c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104980:	e8 eb fb ff ff       	call   80104570 <argptr>
80104985:	85 c0                	test   %eax,%eax
80104987:	78 1f                	js     801049a8 <sys_write+0x68>
  return filewrite(f, p, n);
80104989:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010498c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104990:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104993:	89 44 24 04          	mov    %eax,0x4(%esp)
80104997:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010499a:	89 04 24             	mov    %eax,(%esp)
8010499d:	e8 3e c6 ff ff       	call   80100fe0 <filewrite>
}
801049a2:	c9                   	leave  
801049a3:	c3                   	ret    
801049a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049ad:	c9                   	leave  
801049ae:	c3                   	ret    
801049af:	90                   	nop

801049b0 <sys_close>:
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
801049b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801049b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049bc:	e8 5f fe ff ff       	call   80104820 <argfd.constprop.0>
801049c1:	85 c0                	test   %eax,%eax
801049c3:	78 23                	js     801049e8 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
801049c5:	e8 e6 ec ff ff       	call   801036b0 <myproc>
801049ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049cd:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801049d4:	00 
  fileclose(f);
801049d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d8:	89 04 24             	mov    %eax,(%esp)
801049db:	e8 50 c4 ff ff       	call   80100e30 <fileclose>
  return 0;
801049e0:	31 c0                	xor    %eax,%eax
}
801049e2:	c9                   	leave  
801049e3:	c3                   	ret    
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049ed:	c9                   	leave  
801049ee:	c3                   	ret    
801049ef:	90                   	nop

801049f0 <sys_fstat>:
{
801049f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801049f1:	31 c0                	xor    %eax,%eax
{
801049f3:	89 e5                	mov    %esp,%ebp
801049f5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801049f8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801049fb:	e8 20 fe ff ff       	call   80104820 <argfd.constprop.0>
80104a00:	85 c0                	test   %eax,%eax
80104a02:	78 34                	js     80104a38 <sys_fstat+0x48>
80104a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a07:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a0e:	00 
80104a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a1a:	e8 51 fb ff ff       	call   80104570 <argptr>
80104a1f:	85 c0                	test   %eax,%eax
80104a21:	78 15                	js     80104a38 <sys_fstat+0x48>
  return filestat(f, st);
80104a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a26:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a2d:	89 04 24             	mov    %eax,(%esp)
80104a30:	e8 bb c4 ff ff       	call   80100ef0 <filestat>
}
80104a35:	c9                   	leave  
80104a36:	c3                   	ret    
80104a37:	90                   	nop
    return -1;
80104a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a3d:	c9                   	leave  
80104a3e:	c3                   	ret    
80104a3f:	90                   	nop

80104a40 <sys_link>:
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	53                   	push   %ebx
80104a46:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104a49:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104a57:	e8 44 fb ff ff       	call   801045a0 <argstr>
80104a5c:	85 c0                	test   %eax,%eax
80104a5e:	0f 88 e6 00 00 00    	js     80104b4a <sys_link+0x10a>
80104a64:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104a67:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a72:	e8 29 fb ff ff       	call   801045a0 <argstr>
80104a77:	85 c0                	test   %eax,%eax
80104a79:	0f 88 cb 00 00 00    	js     80104b4a <sys_link+0x10a>
  begin_op();
80104a7f:	e8 9c e0 ff ff       	call   80102b20 <begin_op>
  if((ip = namei(old)) == 0){
80104a84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104a87:	89 04 24             	mov    %eax,(%esp)
80104a8a:	e8 81 d4 ff ff       	call   80101f10 <namei>
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	89 c3                	mov    %eax,%ebx
80104a93:	0f 84 ac 00 00 00    	je     80104b45 <sys_link+0x105>
  ilock(ip);
80104a99:	89 04 24             	mov    %eax,(%esp)
80104a9c:	e8 1f cc ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
80104aa1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104aa6:	0f 84 91 00 00 00    	je     80104b3d <sys_link+0xfd>
  ip->nlink++;
80104aac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104ab1:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ab4:	89 1c 24             	mov    %ebx,(%esp)
80104ab7:	e8 44 cb ff ff       	call   80101600 <iupdate>
  iunlock(ip);
80104abc:	89 1c 24             	mov    %ebx,(%esp)
80104abf:	e8 dc cc ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104ac4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104ac7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104acb:	89 04 24             	mov    %eax,(%esp)
80104ace:	e8 5d d4 ff ff       	call   80101f30 <nameiparent>
80104ad3:	85 c0                	test   %eax,%eax
80104ad5:	89 c6                	mov    %eax,%esi
80104ad7:	74 4f                	je     80104b28 <sys_link+0xe8>
  ilock(dp);
80104ad9:	89 04 24             	mov    %eax,(%esp)
80104adc:	e8 df cb ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ae1:	8b 03                	mov    (%ebx),%eax
80104ae3:	39 06                	cmp    %eax,(%esi)
80104ae5:	75 39                	jne    80104b20 <sys_link+0xe0>
80104ae7:	8b 43 04             	mov    0x4(%ebx),%eax
80104aea:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104aee:	89 34 24             	mov    %esi,(%esp)
80104af1:	89 44 24 08          	mov    %eax,0x8(%esp)
80104af5:	e8 36 d3 ff ff       	call   80101e30 <dirlink>
80104afa:	85 c0                	test   %eax,%eax
80104afc:	78 22                	js     80104b20 <sys_link+0xe0>
  iunlockput(dp);
80104afe:	89 34 24             	mov    %esi,(%esp)
80104b01:	e8 1a ce ff ff       	call   80101920 <iunlockput>
  iput(ip);
80104b06:	89 1c 24             	mov    %ebx,(%esp)
80104b09:	e8 d2 cc ff ff       	call   801017e0 <iput>
  end_op();
80104b0e:	e8 7d e0 ff ff       	call   80102b90 <end_op>
}
80104b13:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104b16:	31 c0                	xor    %eax,%eax
}
80104b18:	5b                   	pop    %ebx
80104b19:	5e                   	pop    %esi
80104b1a:	5f                   	pop    %edi
80104b1b:	5d                   	pop    %ebp
80104b1c:	c3                   	ret    
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104b20:	89 34 24             	mov    %esi,(%esp)
80104b23:	e8 f8 cd ff ff       	call   80101920 <iunlockput>
  ilock(ip);
80104b28:	89 1c 24             	mov    %ebx,(%esp)
80104b2b:	e8 90 cb ff ff       	call   801016c0 <ilock>
  ip->nlink--;
80104b30:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104b35:	89 1c 24             	mov    %ebx,(%esp)
80104b38:	e8 c3 ca ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104b3d:	89 1c 24             	mov    %ebx,(%esp)
80104b40:	e8 db cd ff ff       	call   80101920 <iunlockput>
  end_op();
80104b45:	e8 46 e0 ff ff       	call   80102b90 <end_op>
}
80104b4a:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104b4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b52:	5b                   	pop    %ebx
80104b53:	5e                   	pop    %esi
80104b54:	5f                   	pop    %edi
80104b55:	5d                   	pop    %ebp
80104b56:	c3                   	ret    
80104b57:	89 f6                	mov    %esi,%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <sys_unlink>:
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	56                   	push   %esi
80104b65:	53                   	push   %ebx
80104b66:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104b69:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b77:	e8 24 fa ff ff       	call   801045a0 <argstr>
80104b7c:	85 c0                	test   %eax,%eax
80104b7e:	0f 88 76 01 00 00    	js     80104cfa <sys_unlink+0x19a>
  begin_op();
80104b84:	e8 97 df ff ff       	call   80102b20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104b89:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104b8c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104b8f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104b93:	89 04 24             	mov    %eax,(%esp)
80104b96:	e8 95 d3 ff ff       	call   80101f30 <nameiparent>
80104b9b:	85 c0                	test   %eax,%eax
80104b9d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104ba0:	0f 84 4f 01 00 00    	je     80104cf5 <sys_unlink+0x195>
  ilock(dp);
80104ba6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104ba9:	89 34 24             	mov    %esi,(%esp)
80104bac:	e8 0f cb ff ff       	call   801016c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104bb1:	c7 44 24 04 bc 75 10 	movl   $0x801075bc,0x4(%esp)
80104bb8:	80 
80104bb9:	89 1c 24             	mov    %ebx,(%esp)
80104bbc:	e8 df cf ff ff       	call   80101ba0 <namecmp>
80104bc1:	85 c0                	test   %eax,%eax
80104bc3:	0f 84 21 01 00 00    	je     80104cea <sys_unlink+0x18a>
80104bc9:	c7 44 24 04 bb 75 10 	movl   $0x801075bb,0x4(%esp)
80104bd0:	80 
80104bd1:	89 1c 24             	mov    %ebx,(%esp)
80104bd4:	e8 c7 cf ff ff       	call   80101ba0 <namecmp>
80104bd9:	85 c0                	test   %eax,%eax
80104bdb:	0f 84 09 01 00 00    	je     80104cea <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104be1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104be4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104be8:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bec:	89 34 24             	mov    %esi,(%esp)
80104bef:	e8 dc cf ff ff       	call   80101bd0 <dirlookup>
80104bf4:	85 c0                	test   %eax,%eax
80104bf6:	89 c3                	mov    %eax,%ebx
80104bf8:	0f 84 ec 00 00 00    	je     80104cea <sys_unlink+0x18a>
  ilock(ip);
80104bfe:	89 04 24             	mov    %eax,(%esp)
80104c01:	e8 ba ca ff ff       	call   801016c0 <ilock>
  if(ip->nlink < 1)
80104c06:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c0b:	0f 8e 24 01 00 00    	jle    80104d35 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c16:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104c19:	74 7d                	je     80104c98 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104c1b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104c22:	00 
80104c23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c2a:	00 
80104c2b:	89 34 24             	mov    %esi,(%esp)
80104c2e:	e8 5d f6 ff ff       	call   80104290 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104c33:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c36:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104c3d:	00 
80104c3e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104c42:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c46:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c49:	89 04 24             	mov    %eax,(%esp)
80104c4c:	e8 1f ce ff ff       	call   80101a70 <writei>
80104c51:	83 f8 10             	cmp    $0x10,%eax
80104c54:	0f 85 cf 00 00 00    	jne    80104d29 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104c5a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c5f:	0f 84 a3 00 00 00    	je     80104d08 <sys_unlink+0x1a8>
  iunlockput(dp);
80104c65:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c68:	89 04 24             	mov    %eax,(%esp)
80104c6b:	e8 b0 cc ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80104c70:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104c75:	89 1c 24             	mov    %ebx,(%esp)
80104c78:	e8 83 c9 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104c7d:	89 1c 24             	mov    %ebx,(%esp)
80104c80:	e8 9b cc ff ff       	call   80101920 <iunlockput>
  end_op();
80104c85:	e8 06 df ff ff       	call   80102b90 <end_op>
}
80104c8a:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104c8d:	31 c0                	xor    %eax,%eax
}
80104c8f:	5b                   	pop    %ebx
80104c90:	5e                   	pop    %esi
80104c91:	5f                   	pop    %edi
80104c92:	5d                   	pop    %ebp
80104c93:	c3                   	ret    
80104c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104c98:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104c9c:	0f 86 79 ff ff ff    	jbe    80104c1b <sys_unlink+0xbb>
80104ca2:	bf 20 00 00 00       	mov    $0x20,%edi
80104ca7:	eb 15                	jmp    80104cbe <sys_unlink+0x15e>
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb0:	8d 57 10             	lea    0x10(%edi),%edx
80104cb3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104cb6:	0f 83 5f ff ff ff    	jae    80104c1b <sys_unlink+0xbb>
80104cbc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cbe:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104cc5:	00 
80104cc6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104cca:	89 74 24 04          	mov    %esi,0x4(%esp)
80104cce:	89 1c 24             	mov    %ebx,(%esp)
80104cd1:	e8 9a cc ff ff       	call   80101970 <readi>
80104cd6:	83 f8 10             	cmp    $0x10,%eax
80104cd9:	75 42                	jne    80104d1d <sys_unlink+0x1bd>
    if(de.inum != 0)
80104cdb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104ce0:	74 ce                	je     80104cb0 <sys_unlink+0x150>
    iunlockput(ip);
80104ce2:	89 1c 24             	mov    %ebx,(%esp)
80104ce5:	e8 36 cc ff ff       	call   80101920 <iunlockput>
  iunlockput(dp);
80104cea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104ced:	89 04 24             	mov    %eax,(%esp)
80104cf0:	e8 2b cc ff ff       	call   80101920 <iunlockput>
  end_op();
80104cf5:	e8 96 de ff ff       	call   80102b90 <end_op>
}
80104cfa:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104cfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d02:	5b                   	pop    %ebx
80104d03:	5e                   	pop    %esi
80104d04:	5f                   	pop    %edi
80104d05:	5d                   	pop    %ebp
80104d06:	c3                   	ret    
80104d07:	90                   	nop
    dp->nlink--;
80104d08:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d0b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104d10:	89 04 24             	mov    %eax,(%esp)
80104d13:	e8 e8 c8 ff ff       	call   80101600 <iupdate>
80104d18:	e9 48 ff ff ff       	jmp    80104c65 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104d1d:	c7 04 24 e0 75 10 80 	movl   $0x801075e0,(%esp)
80104d24:	e8 37 b6 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104d29:	c7 04 24 f2 75 10 80 	movl   $0x801075f2,(%esp)
80104d30:	e8 2b b6 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104d35:	c7 04 24 ce 75 10 80 	movl   $0x801075ce,(%esp)
80104d3c:	e8 1f b6 ff ff       	call   80100360 <panic>
80104d41:	eb 0d                	jmp    80104d50 <sys_open>
80104d43:	90                   	nop
80104d44:	90                   	nop
80104d45:	90                   	nop
80104d46:	90                   	nop
80104d47:	90                   	nop
80104d48:	90                   	nop
80104d49:	90                   	nop
80104d4a:	90                   	nop
80104d4b:	90                   	nop
80104d4c:	90                   	nop
80104d4d:	90                   	nop
80104d4e:	90                   	nop
80104d4f:	90                   	nop

80104d50 <sys_open>:

int
sys_open(void)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
80104d55:	53                   	push   %ebx
80104d56:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104d59:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d67:	e8 34 f8 ff ff       	call   801045a0 <argstr>
80104d6c:	85 c0                	test   %eax,%eax
80104d6e:	0f 88 d1 00 00 00    	js     80104e45 <sys_open+0xf5>
80104d74:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104d77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d82:	e8 b9 f7 ff ff       	call   80104540 <argint>
80104d87:	85 c0                	test   %eax,%eax
80104d89:	0f 88 b6 00 00 00    	js     80104e45 <sys_open+0xf5>
    return -1;

  begin_op();
80104d8f:	e8 8c dd ff ff       	call   80102b20 <begin_op>

  if(omode & O_CREATE){
80104d94:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104d98:	0f 85 82 00 00 00    	jne    80104e20 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104d9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104da1:	89 04 24             	mov    %eax,(%esp)
80104da4:	e8 67 d1 ff ff       	call   80101f10 <namei>
80104da9:	85 c0                	test   %eax,%eax
80104dab:	89 c6                	mov    %eax,%esi
80104dad:	0f 84 8d 00 00 00    	je     80104e40 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104db3:	89 04 24             	mov    %eax,(%esp)
80104db6:	e8 05 c9 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104dbb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104dc0:	0f 84 92 00 00 00    	je     80104e58 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104dc6:	e8 a5 bf ff ff       	call   80100d70 <filealloc>
80104dcb:	85 c0                	test   %eax,%eax
80104dcd:	89 c3                	mov    %eax,%ebx
80104dcf:	0f 84 93 00 00 00    	je     80104e68 <sys_open+0x118>
80104dd5:	e8 86 f8 ff ff       	call   80104660 <fdalloc>
80104dda:	85 c0                	test   %eax,%eax
80104ddc:	89 c7                	mov    %eax,%edi
80104dde:	0f 88 94 00 00 00    	js     80104e78 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104de4:	89 34 24             	mov    %esi,(%esp)
80104de7:	e8 b4 c9 ff ff       	call   801017a0 <iunlock>
  end_op();
80104dec:	e8 9f dd ff ff       	call   80102b90 <end_op>

  f->type = FD_INODE;
80104df1:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104dfa:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104dfd:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104e04:	89 c2                	mov    %eax,%edx
80104e06:	83 e2 01             	and    $0x1,%edx
80104e09:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e0c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104e0e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104e11:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e13:	0f 95 43 09          	setne  0x9(%ebx)
}
80104e17:	83 c4 2c             	add    $0x2c,%esp
80104e1a:	5b                   	pop    %ebx
80104e1b:	5e                   	pop    %esi
80104e1c:	5f                   	pop    %edi
80104e1d:	5d                   	pop    %ebp
80104e1e:	c3                   	ret    
80104e1f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e23:	31 c9                	xor    %ecx,%ecx
80104e25:	ba 02 00 00 00       	mov    $0x2,%edx
80104e2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e31:	e8 6a f8 ff ff       	call   801046a0 <create>
    if(ip == 0){
80104e36:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104e38:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104e3a:	75 8a                	jne    80104dc6 <sys_open+0x76>
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104e40:	e8 4b dd ff ff       	call   80102b90 <end_op>
}
80104e45:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e4d:	5b                   	pop    %ebx
80104e4e:	5e                   	pop    %esi
80104e4f:	5f                   	pop    %edi
80104e50:	5d                   	pop    %ebp
80104e51:	c3                   	ret    
80104e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e5b:	85 c0                	test   %eax,%eax
80104e5d:	0f 84 63 ff ff ff    	je     80104dc6 <sys_open+0x76>
80104e63:	90                   	nop
80104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104e68:	89 34 24             	mov    %esi,(%esp)
80104e6b:	e8 b0 ca ff ff       	call   80101920 <iunlockput>
80104e70:	eb ce                	jmp    80104e40 <sys_open+0xf0>
80104e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104e78:	89 1c 24             	mov    %ebx,(%esp)
80104e7b:	e8 b0 bf ff ff       	call   80100e30 <fileclose>
80104e80:	eb e6                	jmp    80104e68 <sys_open+0x118>
80104e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <sys_mkdir>:

int
sys_mkdir(void)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104e96:	e8 85 dc ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104e9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ea2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ea9:	e8 f2 f6 ff ff       	call   801045a0 <argstr>
80104eae:	85 c0                	test   %eax,%eax
80104eb0:	78 2e                	js     80104ee0 <sys_mkdir+0x50>
80104eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb5:	31 c9                	xor    %ecx,%ecx
80104eb7:	ba 01 00 00 00       	mov    $0x1,%edx
80104ebc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ec3:	e8 d8 f7 ff ff       	call   801046a0 <create>
80104ec8:	85 c0                	test   %eax,%eax
80104eca:	74 14                	je     80104ee0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104ecc:	89 04 24             	mov    %eax,(%esp)
80104ecf:	e8 4c ca ff ff       	call   80101920 <iunlockput>
  end_op();
80104ed4:	e8 b7 dc ff ff       	call   80102b90 <end_op>
  return 0;
80104ed9:	31 c0                	xor    %eax,%eax
}
80104edb:	c9                   	leave  
80104edc:	c3                   	ret    
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104ee0:	e8 ab dc ff ff       	call   80102b90 <end_op>
    return -1;
80104ee5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eea:	c9                   	leave  
80104eeb:	c3                   	ret    
80104eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ef0 <sys_mknod>:

int
sys_mknod(void)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104ef6:	e8 25 dc ff ff       	call   80102b20 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104efb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104efe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f09:	e8 92 f6 ff ff       	call   801045a0 <argstr>
80104f0e:	85 c0                	test   %eax,%eax
80104f10:	78 5e                	js     80104f70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104f12:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f15:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f20:	e8 1b f6 ff ff       	call   80104540 <argint>
  if((argstr(0, &path)) < 0 ||
80104f25:	85 c0                	test   %eax,%eax
80104f27:	78 47                	js     80104f70 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104f29:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f30:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104f37:	e8 04 f6 ff ff       	call   80104540 <argint>
     argint(1, &major) < 0 ||
80104f3c:	85 c0                	test   %eax,%eax
80104f3e:	78 30                	js     80104f70 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f40:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80104f44:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f49:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104f4d:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80104f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f53:	e8 48 f7 ff ff       	call   801046a0 <create>
80104f58:	85 c0                	test   %eax,%eax
80104f5a:	74 14                	je     80104f70 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f5c:	89 04 24             	mov    %eax,(%esp)
80104f5f:	e8 bc c9 ff ff       	call   80101920 <iunlockput>
  end_op();
80104f64:	e8 27 dc ff ff       	call   80102b90 <end_op>
  return 0;
80104f69:	31 c0                	xor    %eax,%eax
}
80104f6b:	c9                   	leave  
80104f6c:	c3                   	ret    
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104f70:	e8 1b dc ff ff       	call   80102b90 <end_op>
    return -1;
80104f75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f7a:	c9                   	leave  
80104f7b:	c3                   	ret    
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f80 <sys_chdir>:

int
sys_chdir(void)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
80104f85:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104f88:	e8 23 e7 ff ff       	call   801036b0 <myproc>
80104f8d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104f8f:	e8 8c db ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104f94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fa2:	e8 f9 f5 ff ff       	call   801045a0 <argstr>
80104fa7:	85 c0                	test   %eax,%eax
80104fa9:	78 4a                	js     80104ff5 <sys_chdir+0x75>
80104fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fae:	89 04 24             	mov    %eax,(%esp)
80104fb1:	e8 5a cf ff ff       	call   80101f10 <namei>
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	89 c3                	mov    %eax,%ebx
80104fba:	74 39                	je     80104ff5 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
80104fbc:	89 04 24             	mov    %eax,(%esp)
80104fbf:	e8 fc c6 ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80104fc4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80104fc9:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
80104fcc:	75 22                	jne    80104ff0 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
80104fce:	e8 cd c7 ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80104fd3:	8b 46 68             	mov    0x68(%esi),%eax
80104fd6:	89 04 24             	mov    %eax,(%esp)
80104fd9:	e8 02 c8 ff ff       	call   801017e0 <iput>
  end_op();
80104fde:	e8 ad db ff ff       	call   80102b90 <end_op>
  curproc->cwd = ip;
  return 0;
80104fe3:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80104fe5:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80104fe8:	83 c4 20             	add    $0x20,%esp
80104feb:	5b                   	pop    %ebx
80104fec:	5e                   	pop    %esi
80104fed:	5d                   	pop    %ebp
80104fee:	c3                   	ret    
80104fef:	90                   	nop
    iunlockput(ip);
80104ff0:	e8 2b c9 ff ff       	call   80101920 <iunlockput>
    end_op();
80104ff5:	e8 96 db ff ff       	call   80102b90 <end_op>
}
80104ffa:	83 c4 20             	add    $0x20,%esp
    return -1;
80104ffd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105002:	5b                   	pop    %ebx
80105003:	5e                   	pop    %esi
80105004:	5d                   	pop    %ebp
80105005:	c3                   	ret    
80105006:	8d 76 00             	lea    0x0(%esi),%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <sys_exec>:

int
sys_exec(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	57                   	push   %edi
80105014:	56                   	push   %esi
80105015:	53                   	push   %ebx
80105016:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010501c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105022:	89 44 24 04          	mov    %eax,0x4(%esp)
80105026:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010502d:	e8 6e f5 ff ff       	call   801045a0 <argstr>
80105032:	85 c0                	test   %eax,%eax
80105034:	0f 88 84 00 00 00    	js     801050be <sys_exec+0xae>
8010503a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105040:	89 44 24 04          	mov    %eax,0x4(%esp)
80105044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010504b:	e8 f0 f4 ff ff       	call   80104540 <argint>
80105050:	85 c0                	test   %eax,%eax
80105052:	78 6a                	js     801050be <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105054:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010505a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010505c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105063:	00 
80105064:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010506a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105071:	00 
80105072:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105078:	89 04 24             	mov    %eax,(%esp)
8010507b:	e8 10 f2 ff ff       	call   80104290 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105080:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105086:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010508a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010508d:	89 04 24             	mov    %eax,(%esp)
80105090:	e8 4b f4 ff ff       	call   801044e0 <fetchint>
80105095:	85 c0                	test   %eax,%eax
80105097:	78 25                	js     801050be <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105099:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010509f:	85 c0                	test   %eax,%eax
801050a1:	74 2d                	je     801050d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801050a3:	89 74 24 04          	mov    %esi,0x4(%esp)
801050a7:	89 04 24             	mov    %eax,(%esp)
801050aa:	e8 51 f4 ff ff       	call   80104500 <fetchstr>
801050af:	85 c0                	test   %eax,%eax
801050b1:	78 0b                	js     801050be <sys_exec+0xae>
  for(i=0;; i++){
801050b3:	83 c3 01             	add    $0x1,%ebx
801050b6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801050b9:	83 fb 20             	cmp    $0x20,%ebx
801050bc:	75 c2                	jne    80105080 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
801050be:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
801050c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050c9:	5b                   	pop    %ebx
801050ca:	5e                   	pop    %esi
801050cb:	5f                   	pop    %edi
801050cc:	5d                   	pop    %ebp
801050cd:	c3                   	ret    
801050ce:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
801050d0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801050d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801050da:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
801050e0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801050e7:	00 00 00 00 
  return exec(path, argv);
801050eb:	89 04 24             	mov    %eax,(%esp)
801050ee:	e8 ad b8 ff ff       	call   801009a0 <exec>
}
801050f3:	81 c4 ac 00 00 00    	add    $0xac,%esp
801050f9:	5b                   	pop    %ebx
801050fa:	5e                   	pop    %esi
801050fb:	5f                   	pop    %edi
801050fc:	5d                   	pop    %ebp
801050fd:	c3                   	ret    
801050fe:	66 90                	xchg   %ax,%ax

80105100 <sys_pipe>:

int
sys_pipe(void)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	53                   	push   %ebx
80105104:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105107:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010510a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105111:	00 
80105112:	89 44 24 04          	mov    %eax,0x4(%esp)
80105116:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010511d:	e8 4e f4 ff ff       	call   80104570 <argptr>
80105122:	85 c0                	test   %eax,%eax
80105124:	78 6d                	js     80105193 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105126:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105129:	89 44 24 04          	mov    %eax,0x4(%esp)
8010512d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105130:	89 04 24             	mov    %eax,(%esp)
80105133:	e8 48 e0 ff ff       	call   80103180 <pipealloc>
80105138:	85 c0                	test   %eax,%eax
8010513a:	78 57                	js     80105193 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010513c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010513f:	e8 1c f5 ff ff       	call   80104660 <fdalloc>
80105144:	85 c0                	test   %eax,%eax
80105146:	89 c3                	mov    %eax,%ebx
80105148:	78 33                	js     8010517d <sys_pipe+0x7d>
8010514a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010514d:	e8 0e f5 ff ff       	call   80104660 <fdalloc>
80105152:	85 c0                	test   %eax,%eax
80105154:	78 1a                	js     80105170 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105156:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105159:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010515b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010515e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105161:	83 c4 24             	add    $0x24,%esp
  return 0;
80105164:	31 c0                	xor    %eax,%eax
}
80105166:	5b                   	pop    %ebx
80105167:	5d                   	pop    %ebp
80105168:	c3                   	ret    
80105169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105170:	e8 3b e5 ff ff       	call   801036b0 <myproc>
80105175:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010517c:	00 
    fileclose(rf);
8010517d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105180:	89 04 24             	mov    %eax,(%esp)
80105183:	e8 a8 bc ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
80105188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010518b:	89 04 24             	mov    %eax,(%esp)
8010518e:	e8 9d bc ff ff       	call   80100e30 <fileclose>
}
80105193:	83 c4 24             	add    $0x24,%esp
    return -1;
80105196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010519b:	5b                   	pop    %ebx
8010519c:	5d                   	pop    %ebp
8010519d:	c3                   	ret    
8010519e:	66 90                	xchg   %ax,%ax

801051a0 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
801051a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051b4:	e8 87 f3 ff ff       	call   80104540 <argint>
801051b9:	85 c0                	test   %eax,%eax
801051bb:	78 33                	js     801051f0 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
801051bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051c0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801051c7:	00 
801051c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801051cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051d3:	e8 98 f3 ff ff       	call   80104570 <argptr>
801051d8:	85 c0                	test   %eax,%eax
801051da:	78 14                	js     801051f0 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
801051dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051df:	89 44 24 04          	mov    %eax,0x4(%esp)
801051e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051e6:	89 04 24             	mov    %eax,(%esp)
801051e9:	e8 12 1c 00 00       	call   80106e00 <shm_open>
}
801051ee:	c9                   	leave  
801051ef:	c3                   	ret    
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f5:	c9                   	leave  
801051f6:	c3                   	ret    
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_shm_close>:

int sys_shm_close(void) {
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105206:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105209:	89 44 24 04          	mov    %eax,0x4(%esp)
8010520d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105214:	e8 27 f3 ff ff       	call   80104540 <argint>
80105219:	85 c0                	test   %eax,%eax
8010521b:	78 13                	js     80105230 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
8010521d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105220:	89 04 24             	mov    %eax,(%esp)
80105223:	e8 e8 1b 00 00       	call   80106e10 <shm_close>
}
80105228:	c9                   	leave  
80105229:	c3                   	ret    
8010522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105240 <sys_fork>:

int
sys_fork(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105243:	5d                   	pop    %ebp
  return fork();
80105244:	e9 17 e6 ff ff       	jmp    80103860 <fork>
80105249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105250 <sys_exit>:

int
sys_exit(void)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	83 ec 08             	sub    $0x8,%esp
  exit();
80105256:	e8 55 e8 ff ff       	call   80103ab0 <exit>
  return 0;  // not reached
}
8010525b:	31 c0                	xor    %eax,%eax
8010525d:	c9                   	leave  
8010525e:	c3                   	ret    
8010525f:	90                   	nop

80105260 <sys_wait>:

int
sys_wait(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105263:	5d                   	pop    %ebp
  return wait();
80105264:	e9 57 ea ff ff       	jmp    80103cc0 <wait>
80105269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105270 <sys_kill>:

int
sys_kill(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105276:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105279:	89 44 24 04          	mov    %eax,0x4(%esp)
8010527d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105284:	e8 b7 f2 ff ff       	call   80104540 <argint>
80105289:	85 c0                	test   %eax,%eax
8010528b:	78 13                	js     801052a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010528d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105290:	89 04 24             	mov    %eax,(%esp)
80105293:	e8 68 eb ff ff       	call   80103e00 <kill>
}
80105298:	c9                   	leave  
80105299:	c3                   	ret    
8010529a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_getpid>:

int
sys_getpid(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801052b6:	e8 f5 e3 ff ff       	call   801036b0 <myproc>
801052bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801052be:	c9                   	leave  
801052bf:	c3                   	ret    

801052c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	53                   	push   %ebx
801052c4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801052c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052d5:	e8 66 f2 ff ff       	call   80104540 <argint>
801052da:	85 c0                	test   %eax,%eax
801052dc:	78 22                	js     80105300 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801052de:	e8 cd e3 ff ff       	call   801036b0 <myproc>
  if(growproc(n) < 0)
801052e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
801052e6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801052e8:	89 14 24             	mov    %edx,(%esp)
801052eb:	e8 00 e5 ff ff       	call   801037f0 <growproc>
801052f0:	85 c0                	test   %eax,%eax
801052f2:	78 0c                	js     80105300 <sys_sbrk+0x40>
    return -1;
  return addr;
801052f4:	89 d8                	mov    %ebx,%eax
}
801052f6:	83 c4 24             	add    $0x24,%esp
801052f9:	5b                   	pop    %ebx
801052fa:	5d                   	pop    %ebp
801052fb:	c3                   	ret    
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105305:	eb ef                	jmp    801052f6 <sys_sbrk+0x36>
80105307:	89 f6                	mov    %esi,%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105310 <sys_sleep>:

int
sys_sleep(void)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	53                   	push   %ebx
80105314:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105317:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010531a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105325:	e8 16 f2 ff ff       	call   80104540 <argint>
8010532a:	85 c0                	test   %eax,%eax
8010532c:	78 7e                	js     801053ac <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010532e:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105335:	e8 16 ee ff ff       	call   80104150 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010533a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010533d:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105343:	85 d2                	test   %edx,%edx
80105345:	75 29                	jne    80105370 <sys_sleep+0x60>
80105347:	eb 4f                	jmp    80105398 <sys_sleep+0x88>
80105349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105350:	c7 44 24 04 60 4d 11 	movl   $0x80114d60,0x4(%esp)
80105357:	80 
80105358:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
8010535f:	e8 ac e8 ff ff       	call   80103c10 <sleep>
  while(ticks - ticks0 < n){
80105364:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105369:	29 d8                	sub    %ebx,%eax
8010536b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010536e:	73 28                	jae    80105398 <sys_sleep+0x88>
    if(myproc()->killed){
80105370:	e8 3b e3 ff ff       	call   801036b0 <myproc>
80105375:	8b 40 24             	mov    0x24(%eax),%eax
80105378:	85 c0                	test   %eax,%eax
8010537a:	74 d4                	je     80105350 <sys_sleep+0x40>
      release(&tickslock);
8010537c:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105383:	e8 b8 ee ff ff       	call   80104240 <release>
      return -1;
80105388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010538d:	83 c4 24             	add    $0x24,%esp
80105390:	5b                   	pop    %ebx
80105391:	5d                   	pop    %ebp
80105392:	c3                   	ret    
80105393:	90                   	nop
80105394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105398:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010539f:	e8 9c ee ff ff       	call   80104240 <release>
}
801053a4:	83 c4 24             	add    $0x24,%esp
  return 0;
801053a7:	31 c0                	xor    %eax,%eax
}
801053a9:	5b                   	pop    %ebx
801053aa:	5d                   	pop    %ebp
801053ab:	c3                   	ret    
    return -1;
801053ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b1:	eb da                	jmp    8010538d <sys_sleep+0x7d>
801053b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	53                   	push   %ebx
801053c4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801053c7:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053ce:	e8 7d ed ff ff       	call   80104150 <acquire>
  xticks = ticks;
801053d3:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801053d9:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053e0:	e8 5b ee ff ff       	call   80104240 <release>
  return xticks;
}
801053e5:	83 c4 14             	add    $0x14,%esp
801053e8:	89 d8                	mov    %ebx,%eax
801053ea:	5b                   	pop    %ebx
801053eb:	5d                   	pop    %ebp
801053ec:	c3                   	ret    

801053ed <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801053ed:	1e                   	push   %ds
  pushl %es
801053ee:	06                   	push   %es
  pushl %fs
801053ef:	0f a0                	push   %fs
  pushl %gs
801053f1:	0f a8                	push   %gs
  pushal
801053f3:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801053f4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801053f8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801053fa:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801053fc:	54                   	push   %esp
  call trap
801053fd:	e8 de 00 00 00       	call   801054e0 <trap>
  addl $4, %esp
80105402:	83 c4 04             	add    $0x4,%esp

80105405 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105405:	61                   	popa   
  popl %gs
80105406:	0f a9                	pop    %gs
  popl %fs
80105408:	0f a1                	pop    %fs
  popl %es
8010540a:	07                   	pop    %es
  popl %ds
8010540b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010540c:	83 c4 08             	add    $0x8,%esp
  iret
8010540f:	cf                   	iret   

80105410 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105410:	31 c0                	xor    %eax,%eax
80105412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105418:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010541f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105424:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
8010542b:	80 
8010542c:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
80105433:	00 
80105434:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
8010543b:	8e 
8010543c:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105443:	80 
80105444:	c1 ea 10             	shr    $0x10,%edx
80105447:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
8010544e:	80 
  for(i = 0; i < 256; i++)
8010544f:	83 c0 01             	add    $0x1,%eax
80105452:	3d 00 01 00 00       	cmp    $0x100,%eax
80105457:	75 bf                	jne    80105418 <tvinit+0x8>
{
80105459:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010545a:	ba 08 00 00 00       	mov    $0x8,%edx
{
8010545f:	89 e5                	mov    %esp,%ebp
80105461:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105464:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105469:	c7 44 24 04 01 76 10 	movl   $0x80107601,0x4(%esp)
80105470:	80 
80105471:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105478:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
8010547f:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105485:	c1 e8 10             	shr    $0x10,%eax
80105488:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
8010548f:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
80105496:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
8010549c:	e8 bf eb ff ff       	call   80104060 <initlock>
}
801054a1:	c9                   	leave  
801054a2:	c3                   	ret    
801054a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054b0 <idtinit>:

void
idtinit(void)
{
801054b0:	55                   	push   %ebp
  pd[0] = size-1;
801054b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801054b6:	89 e5                	mov    %esp,%ebp
801054b8:	83 ec 10             	sub    $0x10,%esp
801054bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801054bf:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
801054c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801054c8:	c1 e8 10             	shr    $0x10,%eax
801054cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801054cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801054d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801054d5:	c9                   	leave  
801054d6:	c3                   	ret    
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
801054e5:	53                   	push   %ebx
801054e6:	83 ec 3c             	sub    $0x3c,%esp
801054e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801054ec:	8b 43 30             	mov    0x30(%ebx),%eax
801054ef:	83 f8 40             	cmp    $0x40,%eax
801054f2:	0f 84 20 02 00 00    	je     80105718 <trap+0x238>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801054f8:	83 e8 0e             	sub    $0xe,%eax
801054fb:	83 f8 31             	cmp    $0x31,%eax
801054fe:	77 08                	ja     80105508 <trap+0x28>
80105500:	ff 24 85 0c 77 10 80 	jmp    *-0x7fef88f4(,%eax,4)
80105507:	90                   	nop
      exit();
    }
    break;
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105508:	e8 a3 e1 ff ff       	call   801036b0 <myproc>
8010550d:	85 c0                	test   %eax,%eax
8010550f:	90                   	nop
80105510:	0f 84 a6 02 00 00    	je     801057bc <trap+0x2dc>
80105516:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010551a:	0f 84 9c 02 00 00    	je     801057bc <trap+0x2dc>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105520:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105523:	8b 53 38             	mov    0x38(%ebx),%edx
80105526:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105529:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010552c:	e8 5f e1 ff ff       	call   80103690 <cpuid>
80105531:	8b 73 30             	mov    0x30(%ebx),%esi
80105534:	89 c7                	mov    %eax,%edi
80105536:	8b 43 34             	mov    0x34(%ebx),%eax
80105539:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010553c:	e8 6f e1 ff ff       	call   801036b0 <myproc>
80105541:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105544:	e8 67 e1 ff ff       	call   801036b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105549:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010554c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105550:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105553:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105556:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010555a:	89 54 24 18          	mov    %edx,0x18(%esp)
8010555e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80105561:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105564:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105568:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010556c:	89 54 24 10          	mov    %edx,0x10(%esp)
80105570:	8b 40 10             	mov    0x10(%eax),%eax
80105573:	c7 04 24 c8 76 10 80 	movl   $0x801076c8,(%esp)
8010557a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010557e:	e8 cd b0 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105583:	e8 28 e1 ff ff       	call   801036b0 <myproc>
80105588:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010558f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105590:	e8 1b e1 ff ff       	call   801036b0 <myproc>
80105595:	85 c0                	test   %eax,%eax
80105597:	74 0c                	je     801055a5 <trap+0xc5>
80105599:	e8 12 e1 ff ff       	call   801036b0 <myproc>
8010559e:	8b 50 24             	mov    0x24(%eax),%edx
801055a1:	85 d2                	test   %edx,%edx
801055a3:	75 4b                	jne    801055f0 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801055a5:	e8 06 e1 ff ff       	call   801036b0 <myproc>
801055aa:	85 c0                	test   %eax,%eax
801055ac:	74 0d                	je     801055bb <trap+0xdb>
801055ae:	66 90                	xchg   %ax,%ax
801055b0:	e8 fb e0 ff ff       	call   801036b0 <myproc>
801055b5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801055b9:	74 4d                	je     80105608 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055bb:	e8 f0 e0 ff ff       	call   801036b0 <myproc>
801055c0:	85 c0                	test   %eax,%eax
801055c2:	74 1d                	je     801055e1 <trap+0x101>
801055c4:	e8 e7 e0 ff ff       	call   801036b0 <myproc>
801055c9:	8b 40 24             	mov    0x24(%eax),%eax
801055cc:	85 c0                	test   %eax,%eax
801055ce:	74 11                	je     801055e1 <trap+0x101>
801055d0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801055d4:	83 e0 03             	and    $0x3,%eax
801055d7:	66 83 f8 03          	cmp    $0x3,%ax
801055db:	0f 84 68 01 00 00    	je     80105749 <trap+0x269>
    exit();
}
801055e1:	83 c4 3c             	add    $0x3c,%esp
801055e4:	5b                   	pop    %ebx
801055e5:	5e                   	pop    %esi
801055e6:	5f                   	pop    %edi
801055e7:	5d                   	pop    %ebp
801055e8:	c3                   	ret    
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055f0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801055f4:	83 e0 03             	and    $0x3,%eax
801055f7:	66 83 f8 03          	cmp    $0x3,%ax
801055fb:	75 a8                	jne    801055a5 <trap+0xc5>
    exit();
801055fd:	e8 ae e4 ff ff       	call   80103ab0 <exit>
80105602:	eb a1                	jmp    801055a5 <trap+0xc5>
80105604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105608:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105610:	75 a9                	jne    801055bb <trap+0xdb>
    yield();
80105612:	e8 b9 e5 ff ff       	call   80103bd0 <yield>
80105617:	eb a2                	jmp    801055bb <trap+0xdb>
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105620:	0f 20 d0             	mov    %cr2,%eax
    if (KERNBASE > rcr2()) {
80105623:	85 c0                	test   %eax,%eax
80105625:	0f 88 65 01 00 00    	js     80105790 <trap+0x2b0>
8010562b:	0f 20 d0             	mov    %cr2,%eax
      if (tf->esp >= rcr2()) {
8010562e:	39 43 44             	cmp    %eax,0x44(%ebx)
80105631:	0f 82 59 ff ff ff    	jb     80105590 <trap+0xb0>
        uint topOfStack = KERNBASE - myproc()->stackSize * PGSIZE;
80105637:	e8 74 e0 ff ff       	call   801036b0 <myproc>
8010563c:	8b 40 7c             	mov    0x7c(%eax),%eax
8010563f:	f7 d8                	neg    %eax
80105641:	c1 e0 0c             	shl    $0xc,%eax
        if (allocuvm(myproc()->pgdir, PGROUNDDOWN(topOfStack - 1), topOfStack - 1) == 0) {
80105644:	8d b0 ff ff ff 7f    	lea    0x7fffffff(%eax),%esi
8010564a:	e8 61 e0 ff ff       	call   801036b0 <myproc>
8010564f:	89 74 24 08          	mov    %esi,0x8(%esp)
80105653:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105659:	89 74 24 04          	mov    %esi,0x4(%esp)
8010565d:	8b 40 04             	mov    0x4(%eax),%eax
80105660:	89 04 24             	mov    %eax,(%esp)
80105663:	e8 38 12 00 00       	call   801068a0 <allocuvm>
80105668:	85 c0                	test   %eax,%eax
8010566a:	0f 84 36 01 00 00    	je     801057a6 <trap+0x2c6>
        myproc()->stackSize++;
80105670:	e8 3b e0 ff ff       	call   801036b0 <myproc>
80105675:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
        cprintf("%d pages are currently allocated.\n", myproc()->stackSize);
80105679:	e8 32 e0 ff ff       	call   801036b0 <myproc>
8010567e:	8b 40 7c             	mov    0x7c(%eax),%eax
80105681:	c7 04 24 70 76 10 80 	movl   $0x80107670,(%esp)
80105688:	89 44 24 04          	mov    %eax,0x4(%esp)
8010568c:	e8 bf af ff ff       	call   80100650 <cprintf>
80105691:	e9 fa fe ff ff       	jmp    80105590 <trap+0xb0>
80105696:	66 90                	xchg   %ax,%ax
    if(cpuid() == 0){
80105698:	e8 f3 df ff ff       	call   80103690 <cpuid>
8010569d:	85 c0                	test   %eax,%eax
8010569f:	90                   	nop
801056a0:	0f 84 ba 00 00 00    	je     80105760 <trap+0x280>
    lapiceoi();
801056a6:	e8 e5 d0 ff ff       	call   80102790 <lapiceoi>
801056ab:	90                   	nop
801056ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    break;
801056b0:	e9 db fe ff ff       	jmp    80105590 <trap+0xb0>
801056b5:	8d 76 00             	lea    0x0(%esi),%esi
801056b8:	90                   	nop
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801056c0:	e8 1b cf ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
801056c5:	e8 c6 d0 ff ff       	call   80102790 <lapiceoi>
    break;
801056ca:	e9 c1 fe ff ff       	jmp    80105590 <trap+0xb0>
801056cf:	90                   	nop
    uartintr();
801056d0:	e8 4b 02 00 00       	call   80105920 <uartintr>
    lapiceoi();
801056d5:	e8 b6 d0 ff ff       	call   80102790 <lapiceoi>
    break;
801056da:	e9 b1 fe ff ff       	jmp    80105590 <trap+0xb0>
801056df:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801056e0:	8b 7b 38             	mov    0x38(%ebx),%edi
801056e3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801056e7:	e8 a4 df ff ff       	call   80103690 <cpuid>
801056ec:	c7 04 24 28 76 10 80 	movl   $0x80107628,(%esp)
801056f3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801056f7:	89 74 24 08          	mov    %esi,0x8(%esp)
801056fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801056ff:	e8 4c af ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105704:	e8 87 d0 ff ff       	call   80102790 <lapiceoi>
    break;
80105709:	e9 82 fe ff ff       	jmp    80105590 <trap+0xb0>
8010570e:	66 90                	xchg   %ax,%ax
    ideintr();
80105710:	e8 7b c9 ff ff       	call   80102090 <ideintr>
80105715:	eb 8f                	jmp    801056a6 <trap+0x1c6>
80105717:	90                   	nop
80105718:	90                   	nop
80105719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105720:	e8 8b df ff ff       	call   801036b0 <myproc>
80105725:	8b 70 24             	mov    0x24(%eax),%esi
80105728:	85 f6                	test   %esi,%esi
8010572a:	75 2c                	jne    80105758 <trap+0x278>
    myproc()->tf = tf;
8010572c:	e8 7f df ff ff       	call   801036b0 <myproc>
80105731:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105734:	e8 b7 ee ff ff       	call   801045f0 <syscall>
    if(myproc()->killed)
80105739:	e8 72 df ff ff       	call   801036b0 <myproc>
8010573e:	8b 48 24             	mov    0x24(%eax),%ecx
80105741:	85 c9                	test   %ecx,%ecx
80105743:	0f 84 98 fe ff ff    	je     801055e1 <trap+0x101>
}
80105749:	83 c4 3c             	add    $0x3c,%esp
8010574c:	5b                   	pop    %ebx
8010574d:	5e                   	pop    %esi
8010574e:	5f                   	pop    %edi
8010574f:	5d                   	pop    %ebp
      exit();
80105750:	e9 5b e3 ff ff       	jmp    80103ab0 <exit>
80105755:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105758:	e8 53 e3 ff ff       	call   80103ab0 <exit>
8010575d:	eb cd                	jmp    8010572c <trap+0x24c>
8010575f:	90                   	nop
      acquire(&tickslock);
80105760:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105767:	e8 e4 e9 ff ff       	call   80104150 <acquire>
      wakeup(&ticks);
8010576c:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105773:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
8010577a:	e8 21 e6 ff ff       	call   80103da0 <wakeup>
      release(&tickslock);
8010577f:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105786:	e8 b5 ea ff ff       	call   80104240 <release>
8010578b:	e9 16 ff ff ff       	jmp    801056a6 <trap+0x1c6>
      cprintf("Address is out of bounds.\n");
80105790:	c7 04 24 06 76 10 80 	movl   $0x80107606,(%esp)
80105797:	e8 b4 ae ff ff       	call   80100650 <cprintf>
      exit();
8010579c:	e8 0f e3 ff ff       	call   80103ab0 <exit>
801057a1:	e9 ea fd ff ff       	jmp    80105590 <trap+0xb0>
          cprintf("A new page couldn\'t be allocated.\n");
801057a6:	c7 04 24 4c 76 10 80 	movl   $0x8010764c,(%esp)
801057ad:	e8 9e ae ff ff       	call   80100650 <cprintf>
          exit();
801057b2:	e8 f9 e2 ff ff       	call   80103ab0 <exit>
801057b7:	e9 b4 fe ff ff       	jmp    80105670 <trap+0x190>
801057bc:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801057bf:	8b 73 38             	mov    0x38(%ebx),%esi
801057c2:	e8 c9 de ff ff       	call   80103690 <cpuid>
801057c7:	89 7c 24 10          	mov    %edi,0x10(%esp)
801057cb:	89 74 24 0c          	mov    %esi,0xc(%esp)
801057cf:	89 44 24 08          	mov    %eax,0x8(%esp)
801057d3:	8b 43 30             	mov    0x30(%ebx),%eax
801057d6:	c7 04 24 94 76 10 80 	movl   $0x80107694,(%esp)
801057dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801057e1:	e8 6a ae ff ff       	call   80100650 <cprintf>
      panic("trap");
801057e6:	c7 04 24 21 76 10 80 	movl   $0x80107621,(%esp)
801057ed:	e8 6e ab ff ff       	call   80100360 <panic>
801057f2:	66 90                	xchg   %ax,%ax
801057f4:	66 90                	xchg   %ax,%ax
801057f6:	66 90                	xchg   %ax,%ax
801057f8:	66 90                	xchg   %ax,%ax
801057fa:	66 90                	xchg   %ax,%ax
801057fc:	66 90                	xchg   %ax,%ax
801057fe:	66 90                	xchg   %ax,%ax

80105800 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105800:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105805:	55                   	push   %ebp
80105806:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105808:	85 c0                	test   %eax,%eax
8010580a:	74 14                	je     80105820 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010580c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105811:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105812:	a8 01                	test   $0x1,%al
80105814:	74 0a                	je     80105820 <uartgetc+0x20>
80105816:	b2 f8                	mov    $0xf8,%dl
80105818:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105819:	0f b6 c0             	movzbl %al,%eax
}
8010581c:	5d                   	pop    %ebp
8010581d:	c3                   	ret    
8010581e:	66 90                	xchg   %ax,%ax
    return -1;
80105820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105825:	5d                   	pop    %ebp
80105826:	c3                   	ret    
80105827:	89 f6                	mov    %esi,%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105830 <uartputc>:
  if(!uart)
80105830:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105835:	85 c0                	test   %eax,%eax
80105837:	74 3f                	je     80105878 <uartputc+0x48>
{
80105839:	55                   	push   %ebp
8010583a:	89 e5                	mov    %esp,%ebp
8010583c:	56                   	push   %esi
8010583d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105842:	53                   	push   %ebx
  if(!uart)
80105843:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105848:	83 ec 10             	sub    $0x10,%esp
8010584b:	eb 14                	jmp    80105861 <uartputc+0x31>
8010584d:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105850:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105857:	e8 54 cf ff ff       	call   801027b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010585c:	83 eb 01             	sub    $0x1,%ebx
8010585f:	74 07                	je     80105868 <uartputc+0x38>
80105861:	89 f2                	mov    %esi,%edx
80105863:	ec                   	in     (%dx),%al
80105864:	a8 20                	test   $0x20,%al
80105866:	74 e8                	je     80105850 <uartputc+0x20>
  outb(COM1+0, c);
80105868:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010586c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105871:	ee                   	out    %al,(%dx)
}
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	5b                   	pop    %ebx
80105876:	5e                   	pop    %esi
80105877:	5d                   	pop    %ebp
80105878:	f3 c3                	repz ret 
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105880 <uartinit>:
{
80105880:	55                   	push   %ebp
80105881:	31 c9                	xor    %ecx,%ecx
80105883:	89 e5                	mov    %esp,%ebp
80105885:	89 c8                	mov    %ecx,%eax
80105887:	57                   	push   %edi
80105888:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010588d:	56                   	push   %esi
8010588e:	89 fa                	mov    %edi,%edx
80105890:	53                   	push   %ebx
80105891:	83 ec 1c             	sub    $0x1c,%esp
80105894:	ee                   	out    %al,(%dx)
80105895:	be fb 03 00 00       	mov    $0x3fb,%esi
8010589a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010589f:	89 f2                	mov    %esi,%edx
801058a1:	ee                   	out    %al,(%dx)
801058a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801058a7:	b2 f8                	mov    $0xf8,%dl
801058a9:	ee                   	out    %al,(%dx)
801058aa:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801058af:	89 c8                	mov    %ecx,%eax
801058b1:	89 da                	mov    %ebx,%edx
801058b3:	ee                   	out    %al,(%dx)
801058b4:	b8 03 00 00 00       	mov    $0x3,%eax
801058b9:	89 f2                	mov    %esi,%edx
801058bb:	ee                   	out    %al,(%dx)
801058bc:	b2 fc                	mov    $0xfc,%dl
801058be:	89 c8                	mov    %ecx,%eax
801058c0:	ee                   	out    %al,(%dx)
801058c1:	b8 01 00 00 00       	mov    $0x1,%eax
801058c6:	89 da                	mov    %ebx,%edx
801058c8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801058c9:	b2 fd                	mov    $0xfd,%dl
801058cb:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801058cc:	3c ff                	cmp    $0xff,%al
801058ce:	74 42                	je     80105912 <uartinit+0x92>
  uart = 1;
801058d0:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801058d7:	00 00 00 
801058da:	89 fa                	mov    %edi,%edx
801058dc:	ec                   	in     (%dx),%al
801058dd:	b2 f8                	mov    $0xf8,%dl
801058df:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801058e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058e7:	00 
  for(p="xv6...\n"; *p; p++)
801058e8:	bb d4 77 10 80       	mov    $0x801077d4,%ebx
  ioapicenable(IRQ_COM1, 0);
801058ed:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801058f4:	e8 c7 c9 ff ff       	call   801022c0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801058f9:	b8 78 00 00 00       	mov    $0x78,%eax
801058fe:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105900:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105903:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105906:	e8 25 ff ff ff       	call   80105830 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010590b:	0f be 03             	movsbl (%ebx),%eax
8010590e:	84 c0                	test   %al,%al
80105910:	75 ee                	jne    80105900 <uartinit+0x80>
}
80105912:	83 c4 1c             	add    $0x1c,%esp
80105915:	5b                   	pop    %ebx
80105916:	5e                   	pop    %esi
80105917:	5f                   	pop    %edi
80105918:	5d                   	pop    %ebp
80105919:	c3                   	ret    
8010591a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105920 <uartintr>:

void
uartintr(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105926:	c7 04 24 00 58 10 80 	movl   $0x80105800,(%esp)
8010592d:	e8 7e ae ff ff       	call   801007b0 <consoleintr>
}
80105932:	c9                   	leave  
80105933:	c3                   	ret    

80105934 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105934:	6a 00                	push   $0x0
  pushl $0
80105936:	6a 00                	push   $0x0
  jmp alltraps
80105938:	e9 b0 fa ff ff       	jmp    801053ed <alltraps>

8010593d <vector1>:
.globl vector1
vector1:
  pushl $0
8010593d:	6a 00                	push   $0x0
  pushl $1
8010593f:	6a 01                	push   $0x1
  jmp alltraps
80105941:	e9 a7 fa ff ff       	jmp    801053ed <alltraps>

80105946 <vector2>:
.globl vector2
vector2:
  pushl $0
80105946:	6a 00                	push   $0x0
  pushl $2
80105948:	6a 02                	push   $0x2
  jmp alltraps
8010594a:	e9 9e fa ff ff       	jmp    801053ed <alltraps>

8010594f <vector3>:
.globl vector3
vector3:
  pushl $0
8010594f:	6a 00                	push   $0x0
  pushl $3
80105951:	6a 03                	push   $0x3
  jmp alltraps
80105953:	e9 95 fa ff ff       	jmp    801053ed <alltraps>

80105958 <vector4>:
.globl vector4
vector4:
  pushl $0
80105958:	6a 00                	push   $0x0
  pushl $4
8010595a:	6a 04                	push   $0x4
  jmp alltraps
8010595c:	e9 8c fa ff ff       	jmp    801053ed <alltraps>

80105961 <vector5>:
.globl vector5
vector5:
  pushl $0
80105961:	6a 00                	push   $0x0
  pushl $5
80105963:	6a 05                	push   $0x5
  jmp alltraps
80105965:	e9 83 fa ff ff       	jmp    801053ed <alltraps>

8010596a <vector6>:
.globl vector6
vector6:
  pushl $0
8010596a:	6a 00                	push   $0x0
  pushl $6
8010596c:	6a 06                	push   $0x6
  jmp alltraps
8010596e:	e9 7a fa ff ff       	jmp    801053ed <alltraps>

80105973 <vector7>:
.globl vector7
vector7:
  pushl $0
80105973:	6a 00                	push   $0x0
  pushl $7
80105975:	6a 07                	push   $0x7
  jmp alltraps
80105977:	e9 71 fa ff ff       	jmp    801053ed <alltraps>

8010597c <vector8>:
.globl vector8
vector8:
  pushl $8
8010597c:	6a 08                	push   $0x8
  jmp alltraps
8010597e:	e9 6a fa ff ff       	jmp    801053ed <alltraps>

80105983 <vector9>:
.globl vector9
vector9:
  pushl $0
80105983:	6a 00                	push   $0x0
  pushl $9
80105985:	6a 09                	push   $0x9
  jmp alltraps
80105987:	e9 61 fa ff ff       	jmp    801053ed <alltraps>

8010598c <vector10>:
.globl vector10
vector10:
  pushl $10
8010598c:	6a 0a                	push   $0xa
  jmp alltraps
8010598e:	e9 5a fa ff ff       	jmp    801053ed <alltraps>

80105993 <vector11>:
.globl vector11
vector11:
  pushl $11
80105993:	6a 0b                	push   $0xb
  jmp alltraps
80105995:	e9 53 fa ff ff       	jmp    801053ed <alltraps>

8010599a <vector12>:
.globl vector12
vector12:
  pushl $12
8010599a:	6a 0c                	push   $0xc
  jmp alltraps
8010599c:	e9 4c fa ff ff       	jmp    801053ed <alltraps>

801059a1 <vector13>:
.globl vector13
vector13:
  pushl $13
801059a1:	6a 0d                	push   $0xd
  jmp alltraps
801059a3:	e9 45 fa ff ff       	jmp    801053ed <alltraps>

801059a8 <vector14>:
.globl vector14
vector14:
  pushl $14
801059a8:	6a 0e                	push   $0xe
  jmp alltraps
801059aa:	e9 3e fa ff ff       	jmp    801053ed <alltraps>

801059af <vector15>:
.globl vector15
vector15:
  pushl $0
801059af:	6a 00                	push   $0x0
  pushl $15
801059b1:	6a 0f                	push   $0xf
  jmp alltraps
801059b3:	e9 35 fa ff ff       	jmp    801053ed <alltraps>

801059b8 <vector16>:
.globl vector16
vector16:
  pushl $0
801059b8:	6a 00                	push   $0x0
  pushl $16
801059ba:	6a 10                	push   $0x10
  jmp alltraps
801059bc:	e9 2c fa ff ff       	jmp    801053ed <alltraps>

801059c1 <vector17>:
.globl vector17
vector17:
  pushl $17
801059c1:	6a 11                	push   $0x11
  jmp alltraps
801059c3:	e9 25 fa ff ff       	jmp    801053ed <alltraps>

801059c8 <vector18>:
.globl vector18
vector18:
  pushl $0
801059c8:	6a 00                	push   $0x0
  pushl $18
801059ca:	6a 12                	push   $0x12
  jmp alltraps
801059cc:	e9 1c fa ff ff       	jmp    801053ed <alltraps>

801059d1 <vector19>:
.globl vector19
vector19:
  pushl $0
801059d1:	6a 00                	push   $0x0
  pushl $19
801059d3:	6a 13                	push   $0x13
  jmp alltraps
801059d5:	e9 13 fa ff ff       	jmp    801053ed <alltraps>

801059da <vector20>:
.globl vector20
vector20:
  pushl $0
801059da:	6a 00                	push   $0x0
  pushl $20
801059dc:	6a 14                	push   $0x14
  jmp alltraps
801059de:	e9 0a fa ff ff       	jmp    801053ed <alltraps>

801059e3 <vector21>:
.globl vector21
vector21:
  pushl $0
801059e3:	6a 00                	push   $0x0
  pushl $21
801059e5:	6a 15                	push   $0x15
  jmp alltraps
801059e7:	e9 01 fa ff ff       	jmp    801053ed <alltraps>

801059ec <vector22>:
.globl vector22
vector22:
  pushl $0
801059ec:	6a 00                	push   $0x0
  pushl $22
801059ee:	6a 16                	push   $0x16
  jmp alltraps
801059f0:	e9 f8 f9 ff ff       	jmp    801053ed <alltraps>

801059f5 <vector23>:
.globl vector23
vector23:
  pushl $0
801059f5:	6a 00                	push   $0x0
  pushl $23
801059f7:	6a 17                	push   $0x17
  jmp alltraps
801059f9:	e9 ef f9 ff ff       	jmp    801053ed <alltraps>

801059fe <vector24>:
.globl vector24
vector24:
  pushl $0
801059fe:	6a 00                	push   $0x0
  pushl $24
80105a00:	6a 18                	push   $0x18
  jmp alltraps
80105a02:	e9 e6 f9 ff ff       	jmp    801053ed <alltraps>

80105a07 <vector25>:
.globl vector25
vector25:
  pushl $0
80105a07:	6a 00                	push   $0x0
  pushl $25
80105a09:	6a 19                	push   $0x19
  jmp alltraps
80105a0b:	e9 dd f9 ff ff       	jmp    801053ed <alltraps>

80105a10 <vector26>:
.globl vector26
vector26:
  pushl $0
80105a10:	6a 00                	push   $0x0
  pushl $26
80105a12:	6a 1a                	push   $0x1a
  jmp alltraps
80105a14:	e9 d4 f9 ff ff       	jmp    801053ed <alltraps>

80105a19 <vector27>:
.globl vector27
vector27:
  pushl $0
80105a19:	6a 00                	push   $0x0
  pushl $27
80105a1b:	6a 1b                	push   $0x1b
  jmp alltraps
80105a1d:	e9 cb f9 ff ff       	jmp    801053ed <alltraps>

80105a22 <vector28>:
.globl vector28
vector28:
  pushl $0
80105a22:	6a 00                	push   $0x0
  pushl $28
80105a24:	6a 1c                	push   $0x1c
  jmp alltraps
80105a26:	e9 c2 f9 ff ff       	jmp    801053ed <alltraps>

80105a2b <vector29>:
.globl vector29
vector29:
  pushl $0
80105a2b:	6a 00                	push   $0x0
  pushl $29
80105a2d:	6a 1d                	push   $0x1d
  jmp alltraps
80105a2f:	e9 b9 f9 ff ff       	jmp    801053ed <alltraps>

80105a34 <vector30>:
.globl vector30
vector30:
  pushl $0
80105a34:	6a 00                	push   $0x0
  pushl $30
80105a36:	6a 1e                	push   $0x1e
  jmp alltraps
80105a38:	e9 b0 f9 ff ff       	jmp    801053ed <alltraps>

80105a3d <vector31>:
.globl vector31
vector31:
  pushl $0
80105a3d:	6a 00                	push   $0x0
  pushl $31
80105a3f:	6a 1f                	push   $0x1f
  jmp alltraps
80105a41:	e9 a7 f9 ff ff       	jmp    801053ed <alltraps>

80105a46 <vector32>:
.globl vector32
vector32:
  pushl $0
80105a46:	6a 00                	push   $0x0
  pushl $32
80105a48:	6a 20                	push   $0x20
  jmp alltraps
80105a4a:	e9 9e f9 ff ff       	jmp    801053ed <alltraps>

80105a4f <vector33>:
.globl vector33
vector33:
  pushl $0
80105a4f:	6a 00                	push   $0x0
  pushl $33
80105a51:	6a 21                	push   $0x21
  jmp alltraps
80105a53:	e9 95 f9 ff ff       	jmp    801053ed <alltraps>

80105a58 <vector34>:
.globl vector34
vector34:
  pushl $0
80105a58:	6a 00                	push   $0x0
  pushl $34
80105a5a:	6a 22                	push   $0x22
  jmp alltraps
80105a5c:	e9 8c f9 ff ff       	jmp    801053ed <alltraps>

80105a61 <vector35>:
.globl vector35
vector35:
  pushl $0
80105a61:	6a 00                	push   $0x0
  pushl $35
80105a63:	6a 23                	push   $0x23
  jmp alltraps
80105a65:	e9 83 f9 ff ff       	jmp    801053ed <alltraps>

80105a6a <vector36>:
.globl vector36
vector36:
  pushl $0
80105a6a:	6a 00                	push   $0x0
  pushl $36
80105a6c:	6a 24                	push   $0x24
  jmp alltraps
80105a6e:	e9 7a f9 ff ff       	jmp    801053ed <alltraps>

80105a73 <vector37>:
.globl vector37
vector37:
  pushl $0
80105a73:	6a 00                	push   $0x0
  pushl $37
80105a75:	6a 25                	push   $0x25
  jmp alltraps
80105a77:	e9 71 f9 ff ff       	jmp    801053ed <alltraps>

80105a7c <vector38>:
.globl vector38
vector38:
  pushl $0
80105a7c:	6a 00                	push   $0x0
  pushl $38
80105a7e:	6a 26                	push   $0x26
  jmp alltraps
80105a80:	e9 68 f9 ff ff       	jmp    801053ed <alltraps>

80105a85 <vector39>:
.globl vector39
vector39:
  pushl $0
80105a85:	6a 00                	push   $0x0
  pushl $39
80105a87:	6a 27                	push   $0x27
  jmp alltraps
80105a89:	e9 5f f9 ff ff       	jmp    801053ed <alltraps>

80105a8e <vector40>:
.globl vector40
vector40:
  pushl $0
80105a8e:	6a 00                	push   $0x0
  pushl $40
80105a90:	6a 28                	push   $0x28
  jmp alltraps
80105a92:	e9 56 f9 ff ff       	jmp    801053ed <alltraps>

80105a97 <vector41>:
.globl vector41
vector41:
  pushl $0
80105a97:	6a 00                	push   $0x0
  pushl $41
80105a99:	6a 29                	push   $0x29
  jmp alltraps
80105a9b:	e9 4d f9 ff ff       	jmp    801053ed <alltraps>

80105aa0 <vector42>:
.globl vector42
vector42:
  pushl $0
80105aa0:	6a 00                	push   $0x0
  pushl $42
80105aa2:	6a 2a                	push   $0x2a
  jmp alltraps
80105aa4:	e9 44 f9 ff ff       	jmp    801053ed <alltraps>

80105aa9 <vector43>:
.globl vector43
vector43:
  pushl $0
80105aa9:	6a 00                	push   $0x0
  pushl $43
80105aab:	6a 2b                	push   $0x2b
  jmp alltraps
80105aad:	e9 3b f9 ff ff       	jmp    801053ed <alltraps>

80105ab2 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ab2:	6a 00                	push   $0x0
  pushl $44
80105ab4:	6a 2c                	push   $0x2c
  jmp alltraps
80105ab6:	e9 32 f9 ff ff       	jmp    801053ed <alltraps>

80105abb <vector45>:
.globl vector45
vector45:
  pushl $0
80105abb:	6a 00                	push   $0x0
  pushl $45
80105abd:	6a 2d                	push   $0x2d
  jmp alltraps
80105abf:	e9 29 f9 ff ff       	jmp    801053ed <alltraps>

80105ac4 <vector46>:
.globl vector46
vector46:
  pushl $0
80105ac4:	6a 00                	push   $0x0
  pushl $46
80105ac6:	6a 2e                	push   $0x2e
  jmp alltraps
80105ac8:	e9 20 f9 ff ff       	jmp    801053ed <alltraps>

80105acd <vector47>:
.globl vector47
vector47:
  pushl $0
80105acd:	6a 00                	push   $0x0
  pushl $47
80105acf:	6a 2f                	push   $0x2f
  jmp alltraps
80105ad1:	e9 17 f9 ff ff       	jmp    801053ed <alltraps>

80105ad6 <vector48>:
.globl vector48
vector48:
  pushl $0
80105ad6:	6a 00                	push   $0x0
  pushl $48
80105ad8:	6a 30                	push   $0x30
  jmp alltraps
80105ada:	e9 0e f9 ff ff       	jmp    801053ed <alltraps>

80105adf <vector49>:
.globl vector49
vector49:
  pushl $0
80105adf:	6a 00                	push   $0x0
  pushl $49
80105ae1:	6a 31                	push   $0x31
  jmp alltraps
80105ae3:	e9 05 f9 ff ff       	jmp    801053ed <alltraps>

80105ae8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105ae8:	6a 00                	push   $0x0
  pushl $50
80105aea:	6a 32                	push   $0x32
  jmp alltraps
80105aec:	e9 fc f8 ff ff       	jmp    801053ed <alltraps>

80105af1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105af1:	6a 00                	push   $0x0
  pushl $51
80105af3:	6a 33                	push   $0x33
  jmp alltraps
80105af5:	e9 f3 f8 ff ff       	jmp    801053ed <alltraps>

80105afa <vector52>:
.globl vector52
vector52:
  pushl $0
80105afa:	6a 00                	push   $0x0
  pushl $52
80105afc:	6a 34                	push   $0x34
  jmp alltraps
80105afe:	e9 ea f8 ff ff       	jmp    801053ed <alltraps>

80105b03 <vector53>:
.globl vector53
vector53:
  pushl $0
80105b03:	6a 00                	push   $0x0
  pushl $53
80105b05:	6a 35                	push   $0x35
  jmp alltraps
80105b07:	e9 e1 f8 ff ff       	jmp    801053ed <alltraps>

80105b0c <vector54>:
.globl vector54
vector54:
  pushl $0
80105b0c:	6a 00                	push   $0x0
  pushl $54
80105b0e:	6a 36                	push   $0x36
  jmp alltraps
80105b10:	e9 d8 f8 ff ff       	jmp    801053ed <alltraps>

80105b15 <vector55>:
.globl vector55
vector55:
  pushl $0
80105b15:	6a 00                	push   $0x0
  pushl $55
80105b17:	6a 37                	push   $0x37
  jmp alltraps
80105b19:	e9 cf f8 ff ff       	jmp    801053ed <alltraps>

80105b1e <vector56>:
.globl vector56
vector56:
  pushl $0
80105b1e:	6a 00                	push   $0x0
  pushl $56
80105b20:	6a 38                	push   $0x38
  jmp alltraps
80105b22:	e9 c6 f8 ff ff       	jmp    801053ed <alltraps>

80105b27 <vector57>:
.globl vector57
vector57:
  pushl $0
80105b27:	6a 00                	push   $0x0
  pushl $57
80105b29:	6a 39                	push   $0x39
  jmp alltraps
80105b2b:	e9 bd f8 ff ff       	jmp    801053ed <alltraps>

80105b30 <vector58>:
.globl vector58
vector58:
  pushl $0
80105b30:	6a 00                	push   $0x0
  pushl $58
80105b32:	6a 3a                	push   $0x3a
  jmp alltraps
80105b34:	e9 b4 f8 ff ff       	jmp    801053ed <alltraps>

80105b39 <vector59>:
.globl vector59
vector59:
  pushl $0
80105b39:	6a 00                	push   $0x0
  pushl $59
80105b3b:	6a 3b                	push   $0x3b
  jmp alltraps
80105b3d:	e9 ab f8 ff ff       	jmp    801053ed <alltraps>

80105b42 <vector60>:
.globl vector60
vector60:
  pushl $0
80105b42:	6a 00                	push   $0x0
  pushl $60
80105b44:	6a 3c                	push   $0x3c
  jmp alltraps
80105b46:	e9 a2 f8 ff ff       	jmp    801053ed <alltraps>

80105b4b <vector61>:
.globl vector61
vector61:
  pushl $0
80105b4b:	6a 00                	push   $0x0
  pushl $61
80105b4d:	6a 3d                	push   $0x3d
  jmp alltraps
80105b4f:	e9 99 f8 ff ff       	jmp    801053ed <alltraps>

80105b54 <vector62>:
.globl vector62
vector62:
  pushl $0
80105b54:	6a 00                	push   $0x0
  pushl $62
80105b56:	6a 3e                	push   $0x3e
  jmp alltraps
80105b58:	e9 90 f8 ff ff       	jmp    801053ed <alltraps>

80105b5d <vector63>:
.globl vector63
vector63:
  pushl $0
80105b5d:	6a 00                	push   $0x0
  pushl $63
80105b5f:	6a 3f                	push   $0x3f
  jmp alltraps
80105b61:	e9 87 f8 ff ff       	jmp    801053ed <alltraps>

80105b66 <vector64>:
.globl vector64
vector64:
  pushl $0
80105b66:	6a 00                	push   $0x0
  pushl $64
80105b68:	6a 40                	push   $0x40
  jmp alltraps
80105b6a:	e9 7e f8 ff ff       	jmp    801053ed <alltraps>

80105b6f <vector65>:
.globl vector65
vector65:
  pushl $0
80105b6f:	6a 00                	push   $0x0
  pushl $65
80105b71:	6a 41                	push   $0x41
  jmp alltraps
80105b73:	e9 75 f8 ff ff       	jmp    801053ed <alltraps>

80105b78 <vector66>:
.globl vector66
vector66:
  pushl $0
80105b78:	6a 00                	push   $0x0
  pushl $66
80105b7a:	6a 42                	push   $0x42
  jmp alltraps
80105b7c:	e9 6c f8 ff ff       	jmp    801053ed <alltraps>

80105b81 <vector67>:
.globl vector67
vector67:
  pushl $0
80105b81:	6a 00                	push   $0x0
  pushl $67
80105b83:	6a 43                	push   $0x43
  jmp alltraps
80105b85:	e9 63 f8 ff ff       	jmp    801053ed <alltraps>

80105b8a <vector68>:
.globl vector68
vector68:
  pushl $0
80105b8a:	6a 00                	push   $0x0
  pushl $68
80105b8c:	6a 44                	push   $0x44
  jmp alltraps
80105b8e:	e9 5a f8 ff ff       	jmp    801053ed <alltraps>

80105b93 <vector69>:
.globl vector69
vector69:
  pushl $0
80105b93:	6a 00                	push   $0x0
  pushl $69
80105b95:	6a 45                	push   $0x45
  jmp alltraps
80105b97:	e9 51 f8 ff ff       	jmp    801053ed <alltraps>

80105b9c <vector70>:
.globl vector70
vector70:
  pushl $0
80105b9c:	6a 00                	push   $0x0
  pushl $70
80105b9e:	6a 46                	push   $0x46
  jmp alltraps
80105ba0:	e9 48 f8 ff ff       	jmp    801053ed <alltraps>

80105ba5 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ba5:	6a 00                	push   $0x0
  pushl $71
80105ba7:	6a 47                	push   $0x47
  jmp alltraps
80105ba9:	e9 3f f8 ff ff       	jmp    801053ed <alltraps>

80105bae <vector72>:
.globl vector72
vector72:
  pushl $0
80105bae:	6a 00                	push   $0x0
  pushl $72
80105bb0:	6a 48                	push   $0x48
  jmp alltraps
80105bb2:	e9 36 f8 ff ff       	jmp    801053ed <alltraps>

80105bb7 <vector73>:
.globl vector73
vector73:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $73
80105bb9:	6a 49                	push   $0x49
  jmp alltraps
80105bbb:	e9 2d f8 ff ff       	jmp    801053ed <alltraps>

80105bc0 <vector74>:
.globl vector74
vector74:
  pushl $0
80105bc0:	6a 00                	push   $0x0
  pushl $74
80105bc2:	6a 4a                	push   $0x4a
  jmp alltraps
80105bc4:	e9 24 f8 ff ff       	jmp    801053ed <alltraps>

80105bc9 <vector75>:
.globl vector75
vector75:
  pushl $0
80105bc9:	6a 00                	push   $0x0
  pushl $75
80105bcb:	6a 4b                	push   $0x4b
  jmp alltraps
80105bcd:	e9 1b f8 ff ff       	jmp    801053ed <alltraps>

80105bd2 <vector76>:
.globl vector76
vector76:
  pushl $0
80105bd2:	6a 00                	push   $0x0
  pushl $76
80105bd4:	6a 4c                	push   $0x4c
  jmp alltraps
80105bd6:	e9 12 f8 ff ff       	jmp    801053ed <alltraps>

80105bdb <vector77>:
.globl vector77
vector77:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $77
80105bdd:	6a 4d                	push   $0x4d
  jmp alltraps
80105bdf:	e9 09 f8 ff ff       	jmp    801053ed <alltraps>

80105be4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105be4:	6a 00                	push   $0x0
  pushl $78
80105be6:	6a 4e                	push   $0x4e
  jmp alltraps
80105be8:	e9 00 f8 ff ff       	jmp    801053ed <alltraps>

80105bed <vector79>:
.globl vector79
vector79:
  pushl $0
80105bed:	6a 00                	push   $0x0
  pushl $79
80105bef:	6a 4f                	push   $0x4f
  jmp alltraps
80105bf1:	e9 f7 f7 ff ff       	jmp    801053ed <alltraps>

80105bf6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105bf6:	6a 00                	push   $0x0
  pushl $80
80105bf8:	6a 50                	push   $0x50
  jmp alltraps
80105bfa:	e9 ee f7 ff ff       	jmp    801053ed <alltraps>

80105bff <vector81>:
.globl vector81
vector81:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $81
80105c01:	6a 51                	push   $0x51
  jmp alltraps
80105c03:	e9 e5 f7 ff ff       	jmp    801053ed <alltraps>

80105c08 <vector82>:
.globl vector82
vector82:
  pushl $0
80105c08:	6a 00                	push   $0x0
  pushl $82
80105c0a:	6a 52                	push   $0x52
  jmp alltraps
80105c0c:	e9 dc f7 ff ff       	jmp    801053ed <alltraps>

80105c11 <vector83>:
.globl vector83
vector83:
  pushl $0
80105c11:	6a 00                	push   $0x0
  pushl $83
80105c13:	6a 53                	push   $0x53
  jmp alltraps
80105c15:	e9 d3 f7 ff ff       	jmp    801053ed <alltraps>

80105c1a <vector84>:
.globl vector84
vector84:
  pushl $0
80105c1a:	6a 00                	push   $0x0
  pushl $84
80105c1c:	6a 54                	push   $0x54
  jmp alltraps
80105c1e:	e9 ca f7 ff ff       	jmp    801053ed <alltraps>

80105c23 <vector85>:
.globl vector85
vector85:
  pushl $0
80105c23:	6a 00                	push   $0x0
  pushl $85
80105c25:	6a 55                	push   $0x55
  jmp alltraps
80105c27:	e9 c1 f7 ff ff       	jmp    801053ed <alltraps>

80105c2c <vector86>:
.globl vector86
vector86:
  pushl $0
80105c2c:	6a 00                	push   $0x0
  pushl $86
80105c2e:	6a 56                	push   $0x56
  jmp alltraps
80105c30:	e9 b8 f7 ff ff       	jmp    801053ed <alltraps>

80105c35 <vector87>:
.globl vector87
vector87:
  pushl $0
80105c35:	6a 00                	push   $0x0
  pushl $87
80105c37:	6a 57                	push   $0x57
  jmp alltraps
80105c39:	e9 af f7 ff ff       	jmp    801053ed <alltraps>

80105c3e <vector88>:
.globl vector88
vector88:
  pushl $0
80105c3e:	6a 00                	push   $0x0
  pushl $88
80105c40:	6a 58                	push   $0x58
  jmp alltraps
80105c42:	e9 a6 f7 ff ff       	jmp    801053ed <alltraps>

80105c47 <vector89>:
.globl vector89
vector89:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $89
80105c49:	6a 59                	push   $0x59
  jmp alltraps
80105c4b:	e9 9d f7 ff ff       	jmp    801053ed <alltraps>

80105c50 <vector90>:
.globl vector90
vector90:
  pushl $0
80105c50:	6a 00                	push   $0x0
  pushl $90
80105c52:	6a 5a                	push   $0x5a
  jmp alltraps
80105c54:	e9 94 f7 ff ff       	jmp    801053ed <alltraps>

80105c59 <vector91>:
.globl vector91
vector91:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $91
80105c5b:	6a 5b                	push   $0x5b
  jmp alltraps
80105c5d:	e9 8b f7 ff ff       	jmp    801053ed <alltraps>

80105c62 <vector92>:
.globl vector92
vector92:
  pushl $0
80105c62:	6a 00                	push   $0x0
  pushl $92
80105c64:	6a 5c                	push   $0x5c
  jmp alltraps
80105c66:	e9 82 f7 ff ff       	jmp    801053ed <alltraps>

80105c6b <vector93>:
.globl vector93
vector93:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $93
80105c6d:	6a 5d                	push   $0x5d
  jmp alltraps
80105c6f:	e9 79 f7 ff ff       	jmp    801053ed <alltraps>

80105c74 <vector94>:
.globl vector94
vector94:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $94
80105c76:	6a 5e                	push   $0x5e
  jmp alltraps
80105c78:	e9 70 f7 ff ff       	jmp    801053ed <alltraps>

80105c7d <vector95>:
.globl vector95
vector95:
  pushl $0
80105c7d:	6a 00                	push   $0x0
  pushl $95
80105c7f:	6a 5f                	push   $0x5f
  jmp alltraps
80105c81:	e9 67 f7 ff ff       	jmp    801053ed <alltraps>

80105c86 <vector96>:
.globl vector96
vector96:
  pushl $0
80105c86:	6a 00                	push   $0x0
  pushl $96
80105c88:	6a 60                	push   $0x60
  jmp alltraps
80105c8a:	e9 5e f7 ff ff       	jmp    801053ed <alltraps>

80105c8f <vector97>:
.globl vector97
vector97:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $97
80105c91:	6a 61                	push   $0x61
  jmp alltraps
80105c93:	e9 55 f7 ff ff       	jmp    801053ed <alltraps>

80105c98 <vector98>:
.globl vector98
vector98:
  pushl $0
80105c98:	6a 00                	push   $0x0
  pushl $98
80105c9a:	6a 62                	push   $0x62
  jmp alltraps
80105c9c:	e9 4c f7 ff ff       	jmp    801053ed <alltraps>

80105ca1 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ca1:	6a 00                	push   $0x0
  pushl $99
80105ca3:	6a 63                	push   $0x63
  jmp alltraps
80105ca5:	e9 43 f7 ff ff       	jmp    801053ed <alltraps>

80105caa <vector100>:
.globl vector100
vector100:
  pushl $0
80105caa:	6a 00                	push   $0x0
  pushl $100
80105cac:	6a 64                	push   $0x64
  jmp alltraps
80105cae:	e9 3a f7 ff ff       	jmp    801053ed <alltraps>

80105cb3 <vector101>:
.globl vector101
vector101:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $101
80105cb5:	6a 65                	push   $0x65
  jmp alltraps
80105cb7:	e9 31 f7 ff ff       	jmp    801053ed <alltraps>

80105cbc <vector102>:
.globl vector102
vector102:
  pushl $0
80105cbc:	6a 00                	push   $0x0
  pushl $102
80105cbe:	6a 66                	push   $0x66
  jmp alltraps
80105cc0:	e9 28 f7 ff ff       	jmp    801053ed <alltraps>

80105cc5 <vector103>:
.globl vector103
vector103:
  pushl $0
80105cc5:	6a 00                	push   $0x0
  pushl $103
80105cc7:	6a 67                	push   $0x67
  jmp alltraps
80105cc9:	e9 1f f7 ff ff       	jmp    801053ed <alltraps>

80105cce <vector104>:
.globl vector104
vector104:
  pushl $0
80105cce:	6a 00                	push   $0x0
  pushl $104
80105cd0:	6a 68                	push   $0x68
  jmp alltraps
80105cd2:	e9 16 f7 ff ff       	jmp    801053ed <alltraps>

80105cd7 <vector105>:
.globl vector105
vector105:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $105
80105cd9:	6a 69                	push   $0x69
  jmp alltraps
80105cdb:	e9 0d f7 ff ff       	jmp    801053ed <alltraps>

80105ce0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105ce0:	6a 00                	push   $0x0
  pushl $106
80105ce2:	6a 6a                	push   $0x6a
  jmp alltraps
80105ce4:	e9 04 f7 ff ff       	jmp    801053ed <alltraps>

80105ce9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $107
80105ceb:	6a 6b                	push   $0x6b
  jmp alltraps
80105ced:	e9 fb f6 ff ff       	jmp    801053ed <alltraps>

80105cf2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105cf2:	6a 00                	push   $0x0
  pushl $108
80105cf4:	6a 6c                	push   $0x6c
  jmp alltraps
80105cf6:	e9 f2 f6 ff ff       	jmp    801053ed <alltraps>

80105cfb <vector109>:
.globl vector109
vector109:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $109
80105cfd:	6a 6d                	push   $0x6d
  jmp alltraps
80105cff:	e9 e9 f6 ff ff       	jmp    801053ed <alltraps>

80105d04 <vector110>:
.globl vector110
vector110:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $110
80105d06:	6a 6e                	push   $0x6e
  jmp alltraps
80105d08:	e9 e0 f6 ff ff       	jmp    801053ed <alltraps>

80105d0d <vector111>:
.globl vector111
vector111:
  pushl $0
80105d0d:	6a 00                	push   $0x0
  pushl $111
80105d0f:	6a 6f                	push   $0x6f
  jmp alltraps
80105d11:	e9 d7 f6 ff ff       	jmp    801053ed <alltraps>

80105d16 <vector112>:
.globl vector112
vector112:
  pushl $0
80105d16:	6a 00                	push   $0x0
  pushl $112
80105d18:	6a 70                	push   $0x70
  jmp alltraps
80105d1a:	e9 ce f6 ff ff       	jmp    801053ed <alltraps>

80105d1f <vector113>:
.globl vector113
vector113:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $113
80105d21:	6a 71                	push   $0x71
  jmp alltraps
80105d23:	e9 c5 f6 ff ff       	jmp    801053ed <alltraps>

80105d28 <vector114>:
.globl vector114
vector114:
  pushl $0
80105d28:	6a 00                	push   $0x0
  pushl $114
80105d2a:	6a 72                	push   $0x72
  jmp alltraps
80105d2c:	e9 bc f6 ff ff       	jmp    801053ed <alltraps>

80105d31 <vector115>:
.globl vector115
vector115:
  pushl $0
80105d31:	6a 00                	push   $0x0
  pushl $115
80105d33:	6a 73                	push   $0x73
  jmp alltraps
80105d35:	e9 b3 f6 ff ff       	jmp    801053ed <alltraps>

80105d3a <vector116>:
.globl vector116
vector116:
  pushl $0
80105d3a:	6a 00                	push   $0x0
  pushl $116
80105d3c:	6a 74                	push   $0x74
  jmp alltraps
80105d3e:	e9 aa f6 ff ff       	jmp    801053ed <alltraps>

80105d43 <vector117>:
.globl vector117
vector117:
  pushl $0
80105d43:	6a 00                	push   $0x0
  pushl $117
80105d45:	6a 75                	push   $0x75
  jmp alltraps
80105d47:	e9 a1 f6 ff ff       	jmp    801053ed <alltraps>

80105d4c <vector118>:
.globl vector118
vector118:
  pushl $0
80105d4c:	6a 00                	push   $0x0
  pushl $118
80105d4e:	6a 76                	push   $0x76
  jmp alltraps
80105d50:	e9 98 f6 ff ff       	jmp    801053ed <alltraps>

80105d55 <vector119>:
.globl vector119
vector119:
  pushl $0
80105d55:	6a 00                	push   $0x0
  pushl $119
80105d57:	6a 77                	push   $0x77
  jmp alltraps
80105d59:	e9 8f f6 ff ff       	jmp    801053ed <alltraps>

80105d5e <vector120>:
.globl vector120
vector120:
  pushl $0
80105d5e:	6a 00                	push   $0x0
  pushl $120
80105d60:	6a 78                	push   $0x78
  jmp alltraps
80105d62:	e9 86 f6 ff ff       	jmp    801053ed <alltraps>

80105d67 <vector121>:
.globl vector121
vector121:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $121
80105d69:	6a 79                	push   $0x79
  jmp alltraps
80105d6b:	e9 7d f6 ff ff       	jmp    801053ed <alltraps>

80105d70 <vector122>:
.globl vector122
vector122:
  pushl $0
80105d70:	6a 00                	push   $0x0
  pushl $122
80105d72:	6a 7a                	push   $0x7a
  jmp alltraps
80105d74:	e9 74 f6 ff ff       	jmp    801053ed <alltraps>

80105d79 <vector123>:
.globl vector123
vector123:
  pushl $0
80105d79:	6a 00                	push   $0x0
  pushl $123
80105d7b:	6a 7b                	push   $0x7b
  jmp alltraps
80105d7d:	e9 6b f6 ff ff       	jmp    801053ed <alltraps>

80105d82 <vector124>:
.globl vector124
vector124:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $124
80105d84:	6a 7c                	push   $0x7c
  jmp alltraps
80105d86:	e9 62 f6 ff ff       	jmp    801053ed <alltraps>

80105d8b <vector125>:
.globl vector125
vector125:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $125
80105d8d:	6a 7d                	push   $0x7d
  jmp alltraps
80105d8f:	e9 59 f6 ff ff       	jmp    801053ed <alltraps>

80105d94 <vector126>:
.globl vector126
vector126:
  pushl $0
80105d94:	6a 00                	push   $0x0
  pushl $126
80105d96:	6a 7e                	push   $0x7e
  jmp alltraps
80105d98:	e9 50 f6 ff ff       	jmp    801053ed <alltraps>

80105d9d <vector127>:
.globl vector127
vector127:
  pushl $0
80105d9d:	6a 00                	push   $0x0
  pushl $127
80105d9f:	6a 7f                	push   $0x7f
  jmp alltraps
80105da1:	e9 47 f6 ff ff       	jmp    801053ed <alltraps>

80105da6 <vector128>:
.globl vector128
vector128:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $128
80105da8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105dad:	e9 3b f6 ff ff       	jmp    801053ed <alltraps>

80105db2 <vector129>:
.globl vector129
vector129:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $129
80105db4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105db9:	e9 2f f6 ff ff       	jmp    801053ed <alltraps>

80105dbe <vector130>:
.globl vector130
vector130:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $130
80105dc0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105dc5:	e9 23 f6 ff ff       	jmp    801053ed <alltraps>

80105dca <vector131>:
.globl vector131
vector131:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $131
80105dcc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105dd1:	e9 17 f6 ff ff       	jmp    801053ed <alltraps>

80105dd6 <vector132>:
.globl vector132
vector132:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $132
80105dd8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105ddd:	e9 0b f6 ff ff       	jmp    801053ed <alltraps>

80105de2 <vector133>:
.globl vector133
vector133:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $133
80105de4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105de9:	e9 ff f5 ff ff       	jmp    801053ed <alltraps>

80105dee <vector134>:
.globl vector134
vector134:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $134
80105df0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105df5:	e9 f3 f5 ff ff       	jmp    801053ed <alltraps>

80105dfa <vector135>:
.globl vector135
vector135:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $135
80105dfc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105e01:	e9 e7 f5 ff ff       	jmp    801053ed <alltraps>

80105e06 <vector136>:
.globl vector136
vector136:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $136
80105e08:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105e0d:	e9 db f5 ff ff       	jmp    801053ed <alltraps>

80105e12 <vector137>:
.globl vector137
vector137:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $137
80105e14:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105e19:	e9 cf f5 ff ff       	jmp    801053ed <alltraps>

80105e1e <vector138>:
.globl vector138
vector138:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $138
80105e20:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105e25:	e9 c3 f5 ff ff       	jmp    801053ed <alltraps>

80105e2a <vector139>:
.globl vector139
vector139:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $139
80105e2c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105e31:	e9 b7 f5 ff ff       	jmp    801053ed <alltraps>

80105e36 <vector140>:
.globl vector140
vector140:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $140
80105e38:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105e3d:	e9 ab f5 ff ff       	jmp    801053ed <alltraps>

80105e42 <vector141>:
.globl vector141
vector141:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $141
80105e44:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105e49:	e9 9f f5 ff ff       	jmp    801053ed <alltraps>

80105e4e <vector142>:
.globl vector142
vector142:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $142
80105e50:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105e55:	e9 93 f5 ff ff       	jmp    801053ed <alltraps>

80105e5a <vector143>:
.globl vector143
vector143:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $143
80105e5c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105e61:	e9 87 f5 ff ff       	jmp    801053ed <alltraps>

80105e66 <vector144>:
.globl vector144
vector144:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $144
80105e68:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105e6d:	e9 7b f5 ff ff       	jmp    801053ed <alltraps>

80105e72 <vector145>:
.globl vector145
vector145:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $145
80105e74:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105e79:	e9 6f f5 ff ff       	jmp    801053ed <alltraps>

80105e7e <vector146>:
.globl vector146
vector146:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $146
80105e80:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105e85:	e9 63 f5 ff ff       	jmp    801053ed <alltraps>

80105e8a <vector147>:
.globl vector147
vector147:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $147
80105e8c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105e91:	e9 57 f5 ff ff       	jmp    801053ed <alltraps>

80105e96 <vector148>:
.globl vector148
vector148:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $148
80105e98:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105e9d:	e9 4b f5 ff ff       	jmp    801053ed <alltraps>

80105ea2 <vector149>:
.globl vector149
vector149:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $149
80105ea4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105ea9:	e9 3f f5 ff ff       	jmp    801053ed <alltraps>

80105eae <vector150>:
.globl vector150
vector150:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $150
80105eb0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105eb5:	e9 33 f5 ff ff       	jmp    801053ed <alltraps>

80105eba <vector151>:
.globl vector151
vector151:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $151
80105ebc:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105ec1:	e9 27 f5 ff ff       	jmp    801053ed <alltraps>

80105ec6 <vector152>:
.globl vector152
vector152:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $152
80105ec8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105ecd:	e9 1b f5 ff ff       	jmp    801053ed <alltraps>

80105ed2 <vector153>:
.globl vector153
vector153:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $153
80105ed4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105ed9:	e9 0f f5 ff ff       	jmp    801053ed <alltraps>

80105ede <vector154>:
.globl vector154
vector154:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $154
80105ee0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105ee5:	e9 03 f5 ff ff       	jmp    801053ed <alltraps>

80105eea <vector155>:
.globl vector155
vector155:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $155
80105eec:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105ef1:	e9 f7 f4 ff ff       	jmp    801053ed <alltraps>

80105ef6 <vector156>:
.globl vector156
vector156:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $156
80105ef8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105efd:	e9 eb f4 ff ff       	jmp    801053ed <alltraps>

80105f02 <vector157>:
.globl vector157
vector157:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $157
80105f04:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105f09:	e9 df f4 ff ff       	jmp    801053ed <alltraps>

80105f0e <vector158>:
.globl vector158
vector158:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $158
80105f10:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105f15:	e9 d3 f4 ff ff       	jmp    801053ed <alltraps>

80105f1a <vector159>:
.globl vector159
vector159:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $159
80105f1c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105f21:	e9 c7 f4 ff ff       	jmp    801053ed <alltraps>

80105f26 <vector160>:
.globl vector160
vector160:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $160
80105f28:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105f2d:	e9 bb f4 ff ff       	jmp    801053ed <alltraps>

80105f32 <vector161>:
.globl vector161
vector161:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $161
80105f34:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105f39:	e9 af f4 ff ff       	jmp    801053ed <alltraps>

80105f3e <vector162>:
.globl vector162
vector162:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $162
80105f40:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105f45:	e9 a3 f4 ff ff       	jmp    801053ed <alltraps>

80105f4a <vector163>:
.globl vector163
vector163:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $163
80105f4c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105f51:	e9 97 f4 ff ff       	jmp    801053ed <alltraps>

80105f56 <vector164>:
.globl vector164
vector164:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $164
80105f58:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105f5d:	e9 8b f4 ff ff       	jmp    801053ed <alltraps>

80105f62 <vector165>:
.globl vector165
vector165:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $165
80105f64:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105f69:	e9 7f f4 ff ff       	jmp    801053ed <alltraps>

80105f6e <vector166>:
.globl vector166
vector166:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $166
80105f70:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105f75:	e9 73 f4 ff ff       	jmp    801053ed <alltraps>

80105f7a <vector167>:
.globl vector167
vector167:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $167
80105f7c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105f81:	e9 67 f4 ff ff       	jmp    801053ed <alltraps>

80105f86 <vector168>:
.globl vector168
vector168:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $168
80105f88:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105f8d:	e9 5b f4 ff ff       	jmp    801053ed <alltraps>

80105f92 <vector169>:
.globl vector169
vector169:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $169
80105f94:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105f99:	e9 4f f4 ff ff       	jmp    801053ed <alltraps>

80105f9e <vector170>:
.globl vector170
vector170:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $170
80105fa0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105fa5:	e9 43 f4 ff ff       	jmp    801053ed <alltraps>

80105faa <vector171>:
.globl vector171
vector171:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $171
80105fac:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105fb1:	e9 37 f4 ff ff       	jmp    801053ed <alltraps>

80105fb6 <vector172>:
.globl vector172
vector172:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $172
80105fb8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105fbd:	e9 2b f4 ff ff       	jmp    801053ed <alltraps>

80105fc2 <vector173>:
.globl vector173
vector173:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $173
80105fc4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105fc9:	e9 1f f4 ff ff       	jmp    801053ed <alltraps>

80105fce <vector174>:
.globl vector174
vector174:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $174
80105fd0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105fd5:	e9 13 f4 ff ff       	jmp    801053ed <alltraps>

80105fda <vector175>:
.globl vector175
vector175:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $175
80105fdc:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105fe1:	e9 07 f4 ff ff       	jmp    801053ed <alltraps>

80105fe6 <vector176>:
.globl vector176
vector176:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $176
80105fe8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105fed:	e9 fb f3 ff ff       	jmp    801053ed <alltraps>

80105ff2 <vector177>:
.globl vector177
vector177:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $177
80105ff4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105ff9:	e9 ef f3 ff ff       	jmp    801053ed <alltraps>

80105ffe <vector178>:
.globl vector178
vector178:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $178
80106000:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106005:	e9 e3 f3 ff ff       	jmp    801053ed <alltraps>

8010600a <vector179>:
.globl vector179
vector179:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $179
8010600c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106011:	e9 d7 f3 ff ff       	jmp    801053ed <alltraps>

80106016 <vector180>:
.globl vector180
vector180:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $180
80106018:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010601d:	e9 cb f3 ff ff       	jmp    801053ed <alltraps>

80106022 <vector181>:
.globl vector181
vector181:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $181
80106024:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106029:	e9 bf f3 ff ff       	jmp    801053ed <alltraps>

8010602e <vector182>:
.globl vector182
vector182:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $182
80106030:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106035:	e9 b3 f3 ff ff       	jmp    801053ed <alltraps>

8010603a <vector183>:
.globl vector183
vector183:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $183
8010603c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106041:	e9 a7 f3 ff ff       	jmp    801053ed <alltraps>

80106046 <vector184>:
.globl vector184
vector184:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $184
80106048:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010604d:	e9 9b f3 ff ff       	jmp    801053ed <alltraps>

80106052 <vector185>:
.globl vector185
vector185:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $185
80106054:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106059:	e9 8f f3 ff ff       	jmp    801053ed <alltraps>

8010605e <vector186>:
.globl vector186
vector186:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $186
80106060:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106065:	e9 83 f3 ff ff       	jmp    801053ed <alltraps>

8010606a <vector187>:
.globl vector187
vector187:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $187
8010606c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106071:	e9 77 f3 ff ff       	jmp    801053ed <alltraps>

80106076 <vector188>:
.globl vector188
vector188:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $188
80106078:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010607d:	e9 6b f3 ff ff       	jmp    801053ed <alltraps>

80106082 <vector189>:
.globl vector189
vector189:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $189
80106084:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106089:	e9 5f f3 ff ff       	jmp    801053ed <alltraps>

8010608e <vector190>:
.globl vector190
vector190:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $190
80106090:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106095:	e9 53 f3 ff ff       	jmp    801053ed <alltraps>

8010609a <vector191>:
.globl vector191
vector191:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $191
8010609c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801060a1:	e9 47 f3 ff ff       	jmp    801053ed <alltraps>

801060a6 <vector192>:
.globl vector192
vector192:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $192
801060a8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801060ad:	e9 3b f3 ff ff       	jmp    801053ed <alltraps>

801060b2 <vector193>:
.globl vector193
vector193:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $193
801060b4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801060b9:	e9 2f f3 ff ff       	jmp    801053ed <alltraps>

801060be <vector194>:
.globl vector194
vector194:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $194
801060c0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801060c5:	e9 23 f3 ff ff       	jmp    801053ed <alltraps>

801060ca <vector195>:
.globl vector195
vector195:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $195
801060cc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801060d1:	e9 17 f3 ff ff       	jmp    801053ed <alltraps>

801060d6 <vector196>:
.globl vector196
vector196:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $196
801060d8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801060dd:	e9 0b f3 ff ff       	jmp    801053ed <alltraps>

801060e2 <vector197>:
.globl vector197
vector197:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $197
801060e4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801060e9:	e9 ff f2 ff ff       	jmp    801053ed <alltraps>

801060ee <vector198>:
.globl vector198
vector198:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $198
801060f0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801060f5:	e9 f3 f2 ff ff       	jmp    801053ed <alltraps>

801060fa <vector199>:
.globl vector199
vector199:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $199
801060fc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106101:	e9 e7 f2 ff ff       	jmp    801053ed <alltraps>

80106106 <vector200>:
.globl vector200
vector200:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $200
80106108:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010610d:	e9 db f2 ff ff       	jmp    801053ed <alltraps>

80106112 <vector201>:
.globl vector201
vector201:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $201
80106114:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106119:	e9 cf f2 ff ff       	jmp    801053ed <alltraps>

8010611e <vector202>:
.globl vector202
vector202:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $202
80106120:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106125:	e9 c3 f2 ff ff       	jmp    801053ed <alltraps>

8010612a <vector203>:
.globl vector203
vector203:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $203
8010612c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106131:	e9 b7 f2 ff ff       	jmp    801053ed <alltraps>

80106136 <vector204>:
.globl vector204
vector204:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $204
80106138:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010613d:	e9 ab f2 ff ff       	jmp    801053ed <alltraps>

80106142 <vector205>:
.globl vector205
vector205:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $205
80106144:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106149:	e9 9f f2 ff ff       	jmp    801053ed <alltraps>

8010614e <vector206>:
.globl vector206
vector206:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $206
80106150:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106155:	e9 93 f2 ff ff       	jmp    801053ed <alltraps>

8010615a <vector207>:
.globl vector207
vector207:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $207
8010615c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106161:	e9 87 f2 ff ff       	jmp    801053ed <alltraps>

80106166 <vector208>:
.globl vector208
vector208:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $208
80106168:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010616d:	e9 7b f2 ff ff       	jmp    801053ed <alltraps>

80106172 <vector209>:
.globl vector209
vector209:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $209
80106174:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106179:	e9 6f f2 ff ff       	jmp    801053ed <alltraps>

8010617e <vector210>:
.globl vector210
vector210:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $210
80106180:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106185:	e9 63 f2 ff ff       	jmp    801053ed <alltraps>

8010618a <vector211>:
.globl vector211
vector211:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $211
8010618c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106191:	e9 57 f2 ff ff       	jmp    801053ed <alltraps>

80106196 <vector212>:
.globl vector212
vector212:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $212
80106198:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010619d:	e9 4b f2 ff ff       	jmp    801053ed <alltraps>

801061a2 <vector213>:
.globl vector213
vector213:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $213
801061a4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801061a9:	e9 3f f2 ff ff       	jmp    801053ed <alltraps>

801061ae <vector214>:
.globl vector214
vector214:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $214
801061b0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801061b5:	e9 33 f2 ff ff       	jmp    801053ed <alltraps>

801061ba <vector215>:
.globl vector215
vector215:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $215
801061bc:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801061c1:	e9 27 f2 ff ff       	jmp    801053ed <alltraps>

801061c6 <vector216>:
.globl vector216
vector216:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $216
801061c8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801061cd:	e9 1b f2 ff ff       	jmp    801053ed <alltraps>

801061d2 <vector217>:
.globl vector217
vector217:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $217
801061d4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801061d9:	e9 0f f2 ff ff       	jmp    801053ed <alltraps>

801061de <vector218>:
.globl vector218
vector218:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $218
801061e0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801061e5:	e9 03 f2 ff ff       	jmp    801053ed <alltraps>

801061ea <vector219>:
.globl vector219
vector219:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $219
801061ec:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801061f1:	e9 f7 f1 ff ff       	jmp    801053ed <alltraps>

801061f6 <vector220>:
.globl vector220
vector220:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $220
801061f8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801061fd:	e9 eb f1 ff ff       	jmp    801053ed <alltraps>

80106202 <vector221>:
.globl vector221
vector221:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $221
80106204:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106209:	e9 df f1 ff ff       	jmp    801053ed <alltraps>

8010620e <vector222>:
.globl vector222
vector222:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $222
80106210:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106215:	e9 d3 f1 ff ff       	jmp    801053ed <alltraps>

8010621a <vector223>:
.globl vector223
vector223:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $223
8010621c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106221:	e9 c7 f1 ff ff       	jmp    801053ed <alltraps>

80106226 <vector224>:
.globl vector224
vector224:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $224
80106228:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010622d:	e9 bb f1 ff ff       	jmp    801053ed <alltraps>

80106232 <vector225>:
.globl vector225
vector225:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $225
80106234:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106239:	e9 af f1 ff ff       	jmp    801053ed <alltraps>

8010623e <vector226>:
.globl vector226
vector226:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $226
80106240:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106245:	e9 a3 f1 ff ff       	jmp    801053ed <alltraps>

8010624a <vector227>:
.globl vector227
vector227:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $227
8010624c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106251:	e9 97 f1 ff ff       	jmp    801053ed <alltraps>

80106256 <vector228>:
.globl vector228
vector228:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $228
80106258:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010625d:	e9 8b f1 ff ff       	jmp    801053ed <alltraps>

80106262 <vector229>:
.globl vector229
vector229:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $229
80106264:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106269:	e9 7f f1 ff ff       	jmp    801053ed <alltraps>

8010626e <vector230>:
.globl vector230
vector230:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $230
80106270:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106275:	e9 73 f1 ff ff       	jmp    801053ed <alltraps>

8010627a <vector231>:
.globl vector231
vector231:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $231
8010627c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106281:	e9 67 f1 ff ff       	jmp    801053ed <alltraps>

80106286 <vector232>:
.globl vector232
vector232:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $232
80106288:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010628d:	e9 5b f1 ff ff       	jmp    801053ed <alltraps>

80106292 <vector233>:
.globl vector233
vector233:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $233
80106294:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106299:	e9 4f f1 ff ff       	jmp    801053ed <alltraps>

8010629e <vector234>:
.globl vector234
vector234:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $234
801062a0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801062a5:	e9 43 f1 ff ff       	jmp    801053ed <alltraps>

801062aa <vector235>:
.globl vector235
vector235:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $235
801062ac:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801062b1:	e9 37 f1 ff ff       	jmp    801053ed <alltraps>

801062b6 <vector236>:
.globl vector236
vector236:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $236
801062b8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801062bd:	e9 2b f1 ff ff       	jmp    801053ed <alltraps>

801062c2 <vector237>:
.globl vector237
vector237:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $237
801062c4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801062c9:	e9 1f f1 ff ff       	jmp    801053ed <alltraps>

801062ce <vector238>:
.globl vector238
vector238:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $238
801062d0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801062d5:	e9 13 f1 ff ff       	jmp    801053ed <alltraps>

801062da <vector239>:
.globl vector239
vector239:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $239
801062dc:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801062e1:	e9 07 f1 ff ff       	jmp    801053ed <alltraps>

801062e6 <vector240>:
.globl vector240
vector240:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $240
801062e8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801062ed:	e9 fb f0 ff ff       	jmp    801053ed <alltraps>

801062f2 <vector241>:
.globl vector241
vector241:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $241
801062f4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801062f9:	e9 ef f0 ff ff       	jmp    801053ed <alltraps>

801062fe <vector242>:
.globl vector242
vector242:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $242
80106300:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106305:	e9 e3 f0 ff ff       	jmp    801053ed <alltraps>

8010630a <vector243>:
.globl vector243
vector243:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $243
8010630c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106311:	e9 d7 f0 ff ff       	jmp    801053ed <alltraps>

80106316 <vector244>:
.globl vector244
vector244:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $244
80106318:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010631d:	e9 cb f0 ff ff       	jmp    801053ed <alltraps>

80106322 <vector245>:
.globl vector245
vector245:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $245
80106324:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106329:	e9 bf f0 ff ff       	jmp    801053ed <alltraps>

8010632e <vector246>:
.globl vector246
vector246:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $246
80106330:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106335:	e9 b3 f0 ff ff       	jmp    801053ed <alltraps>

8010633a <vector247>:
.globl vector247
vector247:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $247
8010633c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106341:	e9 a7 f0 ff ff       	jmp    801053ed <alltraps>

80106346 <vector248>:
.globl vector248
vector248:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $248
80106348:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010634d:	e9 9b f0 ff ff       	jmp    801053ed <alltraps>

80106352 <vector249>:
.globl vector249
vector249:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $249
80106354:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106359:	e9 8f f0 ff ff       	jmp    801053ed <alltraps>

8010635e <vector250>:
.globl vector250
vector250:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $250
80106360:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106365:	e9 83 f0 ff ff       	jmp    801053ed <alltraps>

8010636a <vector251>:
.globl vector251
vector251:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $251
8010636c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106371:	e9 77 f0 ff ff       	jmp    801053ed <alltraps>

80106376 <vector252>:
.globl vector252
vector252:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $252
80106378:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010637d:	e9 6b f0 ff ff       	jmp    801053ed <alltraps>

80106382 <vector253>:
.globl vector253
vector253:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $253
80106384:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106389:	e9 5f f0 ff ff       	jmp    801053ed <alltraps>

8010638e <vector254>:
.globl vector254
vector254:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $254
80106390:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106395:	e9 53 f0 ff ff       	jmp    801053ed <alltraps>

8010639a <vector255>:
.globl vector255
vector255:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $255
8010639c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801063a1:	e9 47 f0 ff ff       	jmp    801053ed <alltraps>
801063a6:	66 90                	xchg   %ax,%ax
801063a8:	66 90                	xchg   %ax,%ax
801063aa:	66 90                	xchg   %ax,%ax
801063ac:	66 90                	xchg   %ax,%ax
801063ae:	66 90                	xchg   %ax,%ax

801063b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	57                   	push   %edi
801063b4:	56                   	push   %esi
801063b5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801063b7:	c1 ea 16             	shr    $0x16,%edx
{
801063ba:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801063bb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801063be:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
801063c1:	8b 1f                	mov    (%edi),%ebx
801063c3:	f6 c3 01             	test   $0x1,%bl
801063c6:	74 28                	je     801063f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801063c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801063ce:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801063d4:	c1 ee 0a             	shr    $0xa,%esi
}
801063d7:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
801063da:	89 f2                	mov    %esi,%edx
801063dc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801063e2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801063e5:	5b                   	pop    %ebx
801063e6:	5e                   	pop    %esi
801063e7:	5f                   	pop    %edi
801063e8:	5d                   	pop    %ebp
801063e9:	c3                   	ret    
801063ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801063f0:	85 c9                	test   %ecx,%ecx
801063f2:	74 34                	je     80106428 <walkpgdir+0x78>
801063f4:	e8 b7 c0 ff ff       	call   801024b0 <kalloc>
801063f9:	85 c0                	test   %eax,%eax
801063fb:	89 c3                	mov    %eax,%ebx
801063fd:	74 29                	je     80106428 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
801063ff:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106406:	00 
80106407:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010640e:	00 
8010640f:	89 04 24             	mov    %eax,(%esp)
80106412:	e8 79 de ff ff       	call   80104290 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106417:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010641d:	83 c8 07             	or     $0x7,%eax
80106420:	89 07                	mov    %eax,(%edi)
80106422:	eb b0                	jmp    801063d4 <walkpgdir+0x24>
80106424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80106428:	83 c4 1c             	add    $0x1c,%esp
      return 0;
8010642b:	31 c0                	xor    %eax,%eax
}
8010642d:	5b                   	pop    %ebx
8010642e:	5e                   	pop    %esi
8010642f:	5f                   	pop    %edi
80106430:	5d                   	pop    %ebp
80106431:	c3                   	ret    
80106432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106440 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
80106443:	57                   	push   %edi
80106444:	89 c7                	mov    %eax,%edi
80106446:	56                   	push   %esi
80106447:	89 d6                	mov    %edx,%esi
80106449:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010644a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106450:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106453:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106459:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010645b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010645e:	72 3b                	jb     8010649b <deallocuvm.part.0+0x5b>
80106460:	eb 5e                	jmp    801064c0 <deallocuvm.part.0+0x80>
80106462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106468:	8b 10                	mov    (%eax),%edx
8010646a:	f6 c2 01             	test   $0x1,%dl
8010646d:	74 22                	je     80106491 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010646f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106475:	74 54                	je     801064cb <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106477:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010647d:	89 14 24             	mov    %edx,(%esp)
80106480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106483:	e8 78 be ff ff       	call   80102300 <kfree>
      *pte = 0;
80106488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010648b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106497:	39 f3                	cmp    %esi,%ebx
80106499:	73 25                	jae    801064c0 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010649b:	31 c9                	xor    %ecx,%ecx
8010649d:	89 da                	mov    %ebx,%edx
8010649f:	89 f8                	mov    %edi,%eax
801064a1:	e8 0a ff ff ff       	call   801063b0 <walkpgdir>
    if(!pte)
801064a6:	85 c0                	test   %eax,%eax
801064a8:	75 be                	jne    80106468 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801064aa:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801064b0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801064b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801064bc:	39 f3                	cmp    %esi,%ebx
801064be:	72 db                	jb     8010649b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
801064c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801064c3:	83 c4 1c             	add    $0x1c,%esp
801064c6:	5b                   	pop    %ebx
801064c7:	5e                   	pop    %esi
801064c8:	5f                   	pop    %edi
801064c9:	5d                   	pop    %ebp
801064ca:	c3                   	ret    
        panic("kfree");
801064cb:	c7 04 24 c2 70 10 80 	movl   $0x801070c2,(%esp)
801064d2:	e8 89 9e ff ff       	call   80100360 <panic>
801064d7:	89 f6                	mov    %esi,%esi
801064d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064e0 <seginit>:
{
801064e0:	55                   	push   %ebp
801064e1:	89 e5                	mov    %esp,%ebp
801064e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801064e6:	e8 a5 d1 ff ff       	call   80103690 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064eb:	31 c9                	xor    %ecx,%ecx
801064ed:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
801064f2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801064f8:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064fd:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106501:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
80106506:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106509:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010650d:	31 c9                	xor    %ecx,%ecx
8010650f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106513:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106518:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010651c:	31 c9                	xor    %ecx,%ecx
8010651e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106522:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106527:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010652b:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010652d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106531:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106535:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106539:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010653d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106541:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106545:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106549:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010654d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106551:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106556:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010655a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010655e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106562:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106566:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010656a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010656e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106572:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106576:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010657a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010657e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106582:	c1 e8 10             	shr    $0x10,%eax
80106585:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106589:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010658c:	0f 01 10             	lgdtl  (%eax)
}
8010658f:	c9                   	leave  
80106590:	c3                   	ret    
80106591:	eb 0d                	jmp    801065a0 <mappages>
80106593:	90                   	nop
80106594:	90                   	nop
80106595:	90                   	nop
80106596:	90                   	nop
80106597:	90                   	nop
80106598:	90                   	nop
80106599:	90                   	nop
8010659a:	90                   	nop
8010659b:	90                   	nop
8010659c:	90                   	nop
8010659d:	90                   	nop
8010659e:	90                   	nop
8010659f:	90                   	nop

801065a0 <mappages>:
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	57                   	push   %edi
801065a4:	56                   	push   %esi
801065a5:	53                   	push   %ebx
801065a6:	83 ec 1c             	sub    $0x1c,%esp
801065a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801065ac:	8b 55 10             	mov    0x10(%ebp),%edx
{
801065af:	8b 7d 14             	mov    0x14(%ebp),%edi
    *pte = pa | perm | PTE_P;
801065b2:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
801065b6:	89 c3                	mov    %eax,%ebx
801065b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801065be:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
801065c2:	29 df                	sub    %ebx,%edi
801065c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801065c7:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801065ce:	eb 15                	jmp    801065e5 <mappages+0x45>
    if(*pte & PTE_P)
801065d0:	f6 00 01             	testb  $0x1,(%eax)
801065d3:	75 3d                	jne    80106612 <mappages+0x72>
    *pte = pa | perm | PTE_P;
801065d5:	0b 75 18             	or     0x18(%ebp),%esi
    if(a == last)
801065d8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801065db:	89 30                	mov    %esi,(%eax)
    if(a == last)
801065dd:	74 29                	je     80106608 <mappages+0x68>
    a += PGSIZE;
801065df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801065e5:	8b 45 08             	mov    0x8(%ebp),%eax
801065e8:	b9 01 00 00 00       	mov    $0x1,%ecx
801065ed:	89 da                	mov    %ebx,%edx
801065ef:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801065f2:	e8 b9 fd ff ff       	call   801063b0 <walkpgdir>
801065f7:	85 c0                	test   %eax,%eax
801065f9:	75 d5                	jne    801065d0 <mappages+0x30>
}
801065fb:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801065fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106603:	5b                   	pop    %ebx
80106604:	5e                   	pop    %esi
80106605:	5f                   	pop    %edi
80106606:	5d                   	pop    %ebp
80106607:	c3                   	ret    
80106608:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010660b:	31 c0                	xor    %eax,%eax
}
8010660d:	5b                   	pop    %ebx
8010660e:	5e                   	pop    %esi
8010660f:	5f                   	pop    %edi
80106610:	5d                   	pop    %ebp
80106611:	c3                   	ret    
      panic("remap");
80106612:	c7 04 24 dc 77 10 80 	movl   $0x801077dc,(%esp)
80106619:	e8 42 9d ff ff       	call   80100360 <panic>
8010661e:	66 90                	xchg   %ax,%ax

80106620 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106620:	a1 a4 55 11 80       	mov    0x801155a4,%eax
{
80106625:	55                   	push   %ebp
80106626:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106628:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010662d:	0f 22 d8             	mov    %eax,%cr3
}
80106630:	5d                   	pop    %ebp
80106631:	c3                   	ret    
80106632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106640 <switchuvm>:
{
80106640:	55                   	push   %ebp
80106641:	89 e5                	mov    %esp,%ebp
80106643:	57                   	push   %edi
80106644:	56                   	push   %esi
80106645:	53                   	push   %ebx
80106646:	83 ec 1c             	sub    $0x1c,%esp
80106649:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010664c:	85 f6                	test   %esi,%esi
8010664e:	0f 84 cd 00 00 00    	je     80106721 <switchuvm+0xe1>
  if(p->kstack == 0)
80106654:	8b 46 08             	mov    0x8(%esi),%eax
80106657:	85 c0                	test   %eax,%eax
80106659:	0f 84 da 00 00 00    	je     80106739 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010665f:	8b 7e 04             	mov    0x4(%esi),%edi
80106662:	85 ff                	test   %edi,%edi
80106664:	0f 84 c3 00 00 00    	je     8010672d <switchuvm+0xed>
  pushcli();
8010666a:	e8 a1 da ff ff       	call   80104110 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010666f:	e8 9c cf ff ff       	call   80103610 <mycpu>
80106674:	89 c3                	mov    %eax,%ebx
80106676:	e8 95 cf ff ff       	call   80103610 <mycpu>
8010667b:	89 c7                	mov    %eax,%edi
8010667d:	e8 8e cf ff ff       	call   80103610 <mycpu>
80106682:	83 c7 08             	add    $0x8,%edi
80106685:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106688:	e8 83 cf ff ff       	call   80103610 <mycpu>
8010668d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106690:	ba 67 00 00 00       	mov    $0x67,%edx
80106695:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010669c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801066a3:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801066aa:	83 c1 08             	add    $0x8,%ecx
801066ad:	c1 e9 10             	shr    $0x10,%ecx
801066b0:	83 c0 08             	add    $0x8,%eax
801066b3:	c1 e8 18             	shr    $0x18,%eax
801066b6:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801066bc:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801066c3:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801066c9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801066ce:	e8 3d cf ff ff       	call   80103610 <mycpu>
801066d3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801066da:	e8 31 cf ff ff       	call   80103610 <mycpu>
801066df:	b9 10 00 00 00       	mov    $0x10,%ecx
801066e4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801066e8:	e8 23 cf ff ff       	call   80103610 <mycpu>
801066ed:	8b 56 08             	mov    0x8(%esi),%edx
801066f0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801066f6:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801066f9:	e8 12 cf ff ff       	call   80103610 <mycpu>
801066fe:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106702:	b8 28 00 00 00       	mov    $0x28,%eax
80106707:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010670a:	8b 46 04             	mov    0x4(%esi),%eax
8010670d:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106712:	0f 22 d8             	mov    %eax,%cr3
}
80106715:	83 c4 1c             	add    $0x1c,%esp
80106718:	5b                   	pop    %ebx
80106719:	5e                   	pop    %esi
8010671a:	5f                   	pop    %edi
8010671b:	5d                   	pop    %ebp
  popcli();
8010671c:	e9 af da ff ff       	jmp    801041d0 <popcli>
    panic("switchuvm: no process");
80106721:	c7 04 24 e2 77 10 80 	movl   $0x801077e2,(%esp)
80106728:	e8 33 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
8010672d:	c7 04 24 0d 78 10 80 	movl   $0x8010780d,(%esp)
80106734:	e8 27 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106739:	c7 04 24 f8 77 10 80 	movl   $0x801077f8,(%esp)
80106740:	e8 1b 9c ff ff       	call   80100360 <panic>
80106745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106750 <inituvm>:
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	53                   	push   %ebx
80106756:	83 ec 2c             	sub    $0x2c,%esp
80106759:	8b 75 10             	mov    0x10(%ebp),%esi
8010675c:	8b 55 08             	mov    0x8(%ebp),%edx
8010675f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106762:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106768:	77 64                	ja     801067ce <inituvm+0x7e>
8010676a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
8010676d:	e8 3e bd ff ff       	call   801024b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106772:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106779:	00 
8010677a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106781:	00 
80106782:	89 04 24             	mov    %eax,(%esp)
  mem = kalloc();
80106785:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106787:	e8 04 db ff ff       	call   80104290 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010678c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010678f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106795:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010679c:	00 
8010679d:	89 44 24 0c          	mov    %eax,0xc(%esp)
801067a1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801067a8:	00 
801067a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067b0:	00 
801067b1:	89 14 24             	mov    %edx,(%esp)
801067b4:	e8 e7 fd ff ff       	call   801065a0 <mappages>
  memmove(mem, init, sz);
801067b9:	89 75 10             	mov    %esi,0x10(%ebp)
801067bc:	89 7d 0c             	mov    %edi,0xc(%ebp)
801067bf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801067c2:	83 c4 2c             	add    $0x2c,%esp
801067c5:	5b                   	pop    %ebx
801067c6:	5e                   	pop    %esi
801067c7:	5f                   	pop    %edi
801067c8:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801067c9:	e9 62 db ff ff       	jmp    80104330 <memmove>
    panic("inituvm: more than a page");
801067ce:	c7 04 24 21 78 10 80 	movl   $0x80107821,(%esp)
801067d5:	e8 86 9b ff ff       	call   80100360 <panic>
801067da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067e0 <loaduvm>:
{
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	57                   	push   %edi
801067e4:	56                   	push   %esi
801067e5:	53                   	push   %ebx
801067e6:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
801067e9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801067f0:	0f 85 98 00 00 00    	jne    8010688e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
801067f6:	8b 75 18             	mov    0x18(%ebp),%esi
801067f9:	31 db                	xor    %ebx,%ebx
801067fb:	85 f6                	test   %esi,%esi
801067fd:	75 1a                	jne    80106819 <loaduvm+0x39>
801067ff:	eb 77                	jmp    80106878 <loaduvm+0x98>
80106801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106808:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010680e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106814:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106817:	76 5f                	jbe    80106878 <loaduvm+0x98>
80106819:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010681c:	31 c9                	xor    %ecx,%ecx
8010681e:	8b 45 08             	mov    0x8(%ebp),%eax
80106821:	01 da                	add    %ebx,%edx
80106823:	e8 88 fb ff ff       	call   801063b0 <walkpgdir>
80106828:	85 c0                	test   %eax,%eax
8010682a:	74 56                	je     80106882 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
8010682c:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
8010682e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106833:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106836:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
8010683b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106841:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106844:	05 00 00 00 80       	add    $0x80000000,%eax
80106849:	89 44 24 04          	mov    %eax,0x4(%esp)
8010684d:	8b 45 10             	mov    0x10(%ebp),%eax
80106850:	01 d9                	add    %ebx,%ecx
80106852:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106856:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010685a:	89 04 24             	mov    %eax,(%esp)
8010685d:	e8 0e b1 ff ff       	call   80101970 <readi>
80106862:	39 f8                	cmp    %edi,%eax
80106864:	74 a2                	je     80106808 <loaduvm+0x28>
}
80106866:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010686e:	5b                   	pop    %ebx
8010686f:	5e                   	pop    %esi
80106870:	5f                   	pop    %edi
80106871:	5d                   	pop    %ebp
80106872:	c3                   	ret    
80106873:	90                   	nop
80106874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106878:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010687b:	31 c0                	xor    %eax,%eax
}
8010687d:	5b                   	pop    %ebx
8010687e:	5e                   	pop    %esi
8010687f:	5f                   	pop    %edi
80106880:	5d                   	pop    %ebp
80106881:	c3                   	ret    
      panic("loaduvm: address should exist");
80106882:	c7 04 24 3b 78 10 80 	movl   $0x8010783b,(%esp)
80106889:	e8 d2 9a ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
8010688e:	c7 04 24 dc 78 10 80 	movl   $0x801078dc,(%esp)
80106895:	e8 c6 9a ff ff       	call   80100360 <panic>
8010689a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801068a0 <allocuvm>:
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	57                   	push   %edi
801068a4:	56                   	push   %esi
801068a5:	53                   	push   %ebx
801068a6:	83 ec 2c             	sub    $0x2c,%esp
801068a9:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
801068ac:	85 ff                	test   %edi,%edi
801068ae:	0f 88 8f 00 00 00    	js     80106943 <allocuvm+0xa3>
  if(newsz < oldsz)
801068b4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801068b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801068ba:	0f 82 85 00 00 00    	jb     80106945 <allocuvm+0xa5>
  a = PGROUNDUP(oldsz);
801068c0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801068c6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801068cc:	39 df                	cmp    %ebx,%edi
801068ce:	77 57                	ja     80106927 <allocuvm+0x87>
801068d0:	eb 7e                	jmp    80106950 <allocuvm+0xb0>
801068d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801068d8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068df:	00 
801068e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068e7:	00 
801068e8:	89 04 24             	mov    %eax,(%esp)
801068eb:	e8 a0 d9 ff ff       	call   80104290 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801068f0:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801068f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
801068fa:	8b 45 08             	mov    0x8(%ebp),%eax
801068fd:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106904:	00 
80106905:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010690c:	00 
8010690d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106911:	89 04 24             	mov    %eax,(%esp)
80106914:	e8 87 fc ff ff       	call   801065a0 <mappages>
80106919:	85 c0                	test   %eax,%eax
8010691b:	78 43                	js     80106960 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
8010691d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106923:	39 df                	cmp    %ebx,%edi
80106925:	76 29                	jbe    80106950 <allocuvm+0xb0>
    mem = kalloc();
80106927:	e8 84 bb ff ff       	call   801024b0 <kalloc>
    if(mem == 0){
8010692c:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010692e:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106930:	75 a6                	jne    801068d8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106932:	c7 04 24 59 78 10 80 	movl   $0x80107859,(%esp)
80106939:	e8 12 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010693e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106941:	77 47                	ja     8010698a <allocuvm+0xea>
      return 0;
80106943:	31 c0                	xor    %eax,%eax
}
80106945:	83 c4 2c             	add    $0x2c,%esp
80106948:	5b                   	pop    %ebx
80106949:	5e                   	pop    %esi
8010694a:	5f                   	pop    %edi
8010694b:	5d                   	pop    %ebp
8010694c:	c3                   	ret    
8010694d:	8d 76 00             	lea    0x0(%esi),%esi
80106950:	83 c4 2c             	add    $0x2c,%esp
80106953:	89 f8                	mov    %edi,%eax
80106955:	5b                   	pop    %ebx
80106956:	5e                   	pop    %esi
80106957:	5f                   	pop    %edi
80106958:	5d                   	pop    %ebp
80106959:	c3                   	ret    
8010695a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106960:	c7 04 24 71 78 10 80 	movl   $0x80107871,(%esp)
80106967:	e8 e4 9c ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010696c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010696f:	76 0d                	jbe    8010697e <allocuvm+0xde>
80106971:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106974:	89 fa                	mov    %edi,%edx
80106976:	8b 45 08             	mov    0x8(%ebp),%eax
80106979:	e8 c2 fa ff ff       	call   80106440 <deallocuvm.part.0>
      kfree(mem);
8010697e:	89 34 24             	mov    %esi,(%esp)
80106981:	e8 7a b9 ff ff       	call   80102300 <kfree>
      return 0;
80106986:	31 c0                	xor    %eax,%eax
80106988:	eb bb                	jmp    80106945 <allocuvm+0xa5>
8010698a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010698d:	89 fa                	mov    %edi,%edx
8010698f:	8b 45 08             	mov    0x8(%ebp),%eax
80106992:	e8 a9 fa ff ff       	call   80106440 <deallocuvm.part.0>
      return 0;
80106997:	31 c0                	xor    %eax,%eax
80106999:	eb aa                	jmp    80106945 <allocuvm+0xa5>
8010699b:	90                   	nop
8010699c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069a0 <deallocuvm>:
{
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801069a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801069a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801069ac:	39 d1                	cmp    %edx,%ecx
801069ae:	73 08                	jae    801069b8 <deallocuvm+0x18>
}
801069b0:	5d                   	pop    %ebp
801069b1:	e9 8a fa ff ff       	jmp    80106440 <deallocuvm.part.0>
801069b6:	66 90                	xchg   %ax,%ax
801069b8:	89 d0                	mov    %edx,%eax
801069ba:	5d                   	pop    %ebp
801069bb:	c3                   	ret    
801069bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	56                   	push   %esi
801069c4:	53                   	push   %ebx
801069c5:	83 ec 10             	sub    $0x10,%esp
801069c8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801069cb:	85 f6                	test   %esi,%esi
801069cd:	74 59                	je     80106a28 <freevm+0x68>
801069cf:	31 c9                	xor    %ecx,%ecx
801069d1:	ba 00 00 00 80       	mov    $0x80000000,%edx
801069d6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801069d8:	31 db                	xor    %ebx,%ebx
801069da:	e8 61 fa ff ff       	call   80106440 <deallocuvm.part.0>
801069df:	eb 12                	jmp    801069f3 <freevm+0x33>
801069e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069e8:	83 c3 01             	add    $0x1,%ebx
801069eb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801069f1:	74 27                	je     80106a1a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801069f3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
801069f6:	f6 c2 01             	test   $0x1,%dl
801069f9:	74 ed                	je     801069e8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801069fb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106a01:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106a04:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106a0a:	89 14 24             	mov    %edx,(%esp)
80106a0d:	e8 ee b8 ff ff       	call   80102300 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106a12:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106a18:	75 d9                	jne    801069f3 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
80106a1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106a1d:	83 c4 10             	add    $0x10,%esp
80106a20:	5b                   	pop    %ebx
80106a21:	5e                   	pop    %esi
80106a22:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106a23:	e9 d8 b8 ff ff       	jmp    80102300 <kfree>
    panic("freevm: no pgdir");
80106a28:	c7 04 24 8d 78 10 80 	movl   $0x8010788d,(%esp)
80106a2f:	e8 2c 99 ff ff       	call   80100360 <panic>
80106a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a40 <setupkvm>:
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	56                   	push   %esi
80106a44:	53                   	push   %ebx
80106a45:	83 ec 20             	sub    $0x20,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106a48:	e8 63 ba ff ff       	call   801024b0 <kalloc>
80106a4d:	85 c0                	test   %eax,%eax
80106a4f:	89 c6                	mov    %eax,%esi
80106a51:	74 75                	je     80106ac8 <setupkvm+0x88>
  memset(pgdir, 0, PGSIZE);
80106a53:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a5a:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a5b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106a60:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a67:	00 
80106a68:	89 04 24             	mov    %eax,(%esp)
80106a6b:	e8 20 d8 ff ff       	call   80104290 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106a70:	8b 53 0c             	mov    0xc(%ebx),%edx
80106a73:	8b 43 04             	mov    0x4(%ebx),%eax
80106a76:	89 34 24             	mov    %esi,(%esp)
80106a79:	89 54 24 10          	mov    %edx,0x10(%esp)
80106a7d:	8b 53 08             	mov    0x8(%ebx),%edx
80106a80:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106a84:	29 c2                	sub    %eax,%edx
80106a86:	8b 03                	mov    (%ebx),%eax
80106a88:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a90:	e8 0b fb ff ff       	call   801065a0 <mappages>
80106a95:	85 c0                	test   %eax,%eax
80106a97:	78 17                	js     80106ab0 <setupkvm+0x70>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a99:	83 c3 10             	add    $0x10,%ebx
80106a9c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106aa2:	72 cc                	jb     80106a70 <setupkvm+0x30>
80106aa4:	89 f0                	mov    %esi,%eax
}
80106aa6:	83 c4 20             	add    $0x20,%esp
80106aa9:	5b                   	pop    %ebx
80106aaa:	5e                   	pop    %esi
80106aab:	5d                   	pop    %ebp
80106aac:	c3                   	ret    
80106aad:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
80106ab0:	89 34 24             	mov    %esi,(%esp)
80106ab3:	e8 08 ff ff ff       	call   801069c0 <freevm>
}
80106ab8:	83 c4 20             	add    $0x20,%esp
      return 0;
80106abb:	31 c0                	xor    %eax,%eax
}
80106abd:	5b                   	pop    %ebx
80106abe:	5e                   	pop    %esi
80106abf:	5d                   	pop    %ebp
80106ac0:	c3                   	ret    
80106ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106ac8:	31 c0                	xor    %eax,%eax
80106aca:	eb da                	jmp    80106aa6 <setupkvm+0x66>
80106acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ad0 <kvmalloc>:
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106ad6:	e8 65 ff ff ff       	call   80106a40 <setupkvm>
80106adb:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ae0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ae5:	0f 22 d8             	mov    %eax,%cr3
}
80106ae8:	c9                   	leave  
80106ae9:	c3                   	ret    
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106af0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106af0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106af1:	31 c9                	xor    %ecx,%ecx
{
80106af3:	89 e5                	mov    %esp,%ebp
80106af5:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106af8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106afb:	8b 45 08             	mov    0x8(%ebp),%eax
80106afe:	e8 ad f8 ff ff       	call   801063b0 <walkpgdir>
  if(pte == 0)
80106b03:	85 c0                	test   %eax,%eax
80106b05:	74 05                	je     80106b0c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106b07:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106b0a:	c9                   	leave  
80106b0b:	c3                   	ret    
    panic("clearpteu");
80106b0c:	c7 04 24 9e 78 10 80 	movl   $0x8010789e,(%esp)
80106b13:	e8 48 98 ff ff       	call   80100360 <panic>
80106b18:	90                   	nop
80106b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b20 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, uint stackSize)
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	57                   	push   %edi
80106b24:	56                   	push   %esi
80106b25:	53                   	push   %ebx
80106b26:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106b29:	e8 12 ff ff ff       	call   80106a40 <setupkvm>
80106b2e:	85 c0                	test   %eax,%eax
80106b30:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b33:	0f 84 6f 01 00 00    	je     80106ca8 <copyuvm+0x188>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b39:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b3c:	85 c0                	test   %eax,%eax
80106b3e:	0f 84 ac 00 00 00    	je     80106bf0 <copyuvm+0xd0>
80106b44:	31 db                	xor    %ebx,%ebx
80106b46:	eb 51                	jmp    80106b99 <copyuvm+0x79>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106b48:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106b4e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b55:	00 
80106b56:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106b5a:	89 04 24             	mov    %eax,(%esp)
80106b5d:	e8 ce d7 ff ff       	call   80104330 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b65:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106b6b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106b6f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b76:	00 
80106b77:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106b7b:	89 44 24 10          	mov    %eax,0x10(%esp)
80106b7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b82:	89 04 24             	mov    %eax,(%esp)
80106b85:	e8 16 fa ff ff       	call   801065a0 <mappages>
80106b8a:	85 c0                	test   %eax,%eax
80106b8c:	78 4d                	js     80106bdb <copyuvm+0xbb>
  for(i = 0; i < sz; i += PGSIZE){
80106b8e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b94:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106b97:	76 57                	jbe    80106bf0 <copyuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106b99:	8b 45 08             	mov    0x8(%ebp),%eax
80106b9c:	31 c9                	xor    %ecx,%ecx
80106b9e:	89 da                	mov    %ebx,%edx
80106ba0:	e8 0b f8 ff ff       	call   801063b0 <walkpgdir>
80106ba5:	85 c0                	test   %eax,%eax
80106ba7:	0f 84 0e 01 00 00    	je     80106cbb <copyuvm+0x19b>
    if(!(*pte & PTE_P))
80106bad:	8b 30                	mov    (%eax),%esi
80106baf:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106bb5:	0f 84 f4 00 00 00    	je     80106caf <copyuvm+0x18f>
    pa = PTE_ADDR(*pte);
80106bbb:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106bbd:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106bc3:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106bc6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106bcc:	e8 df b8 ff ff       	call   801024b0 <kalloc>
80106bd1:	85 c0                	test   %eax,%eax
80106bd3:	89 c6                	mov    %eax,%esi
80106bd5:	0f 85 6d ff ff ff    	jne    80106b48 <copyuvm+0x28>
  }

  return d;

bad:
  freevm(d);
80106bdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bde:	89 04 24             	mov    %eax,(%esp)
80106be1:	e8 da fd ff ff       	call   801069c0 <freevm>
  return 0;
80106be6:	31 c0                	xor    %eax,%eax
}
80106be8:	83 c4 2c             	add    $0x2c,%esp
80106beb:	5b                   	pop    %ebx
80106bec:	5e                   	pop    %esi
80106bed:	5f                   	pop    %edi
80106bee:	5d                   	pop    %ebp
80106bef:	c3                   	ret    
  for(i = PGROUNDUP(KERNBASE - 1 - myproc()->stackSize * PGSIZE); i < KERNBASE; i += PGSIZE){
80106bf0:	e8 bb ca ff ff       	call   801036b0 <myproc>
80106bf5:	bb fe 0f 00 80       	mov    $0x80000ffe,%ebx
80106bfa:	8b 40 7c             	mov    0x7c(%eax),%eax
80106bfd:	c1 e0 0c             	shl    $0xc,%eax
80106c00:	29 c3                	sub    %eax,%ebx
80106c02:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106c08:	79 54                	jns    80106c5e <copyuvm+0x13e>
80106c0a:	e9 8e 00 00 00       	jmp    80106c9d <copyuvm+0x17d>
80106c0f:	90                   	nop
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106c10:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106c16:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c1d:	00 
80106c1e:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106c22:	89 04 24             	mov    %eax,(%esp)
80106c25:	e8 06 d7 ff ff       	call   80104330 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106c2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c2d:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106c33:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106c37:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c3e:	00 
80106c3f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106c43:	89 44 24 10          	mov    %eax,0x10(%esp)
80106c47:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c4a:	89 04 24             	mov    %eax,(%esp)
80106c4d:	e8 4e f9 ff ff       	call   801065a0 <mappages>
80106c52:	85 c0                	test   %eax,%eax
80106c54:	78 85                	js     80106bdb <copyuvm+0xbb>
  for(i = PGROUNDUP(KERNBASE - 1 - myproc()->stackSize * PGSIZE); i < KERNBASE; i += PGSIZE){
80106c56:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c5c:	78 3f                	js     80106c9d <copyuvm+0x17d>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106c5e:	8b 45 08             	mov    0x8(%ebp),%eax
80106c61:	31 c9                	xor    %ecx,%ecx
80106c63:	89 da                	mov    %ebx,%edx
80106c65:	e8 46 f7 ff ff       	call   801063b0 <walkpgdir>
80106c6a:	85 c0                	test   %eax,%eax
80106c6c:	74 4d                	je     80106cbb <copyuvm+0x19b>
    if(!(*pte & PTE_P))
80106c6e:	8b 30                	mov    (%eax),%esi
80106c70:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106c76:	74 37                	je     80106caf <copyuvm+0x18f>
    pa = PTE_ADDR(*pte);
80106c78:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106c7a:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106c80:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106c83:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106c89:	e8 22 b8 ff ff       	call   801024b0 <kalloc>
80106c8e:	85 c0                	test   %eax,%eax
80106c90:	89 c6                	mov    %eax,%esi
80106c92:	0f 85 78 ff ff ff    	jne    80106c10 <copyuvm+0xf0>
80106c98:	e9 3e ff ff ff       	jmp    80106bdb <copyuvm+0xbb>
80106c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80106ca0:	83 c4 2c             	add    $0x2c,%esp
80106ca3:	5b                   	pop    %ebx
80106ca4:	5e                   	pop    %esi
80106ca5:	5f                   	pop    %edi
80106ca6:	5d                   	pop    %ebp
80106ca7:	c3                   	ret    
    return 0;
80106ca8:	31 c0                	xor    %eax,%eax
80106caa:	e9 39 ff ff ff       	jmp    80106be8 <copyuvm+0xc8>
      panic("copyuvm: page not present");
80106caf:	c7 04 24 c2 78 10 80 	movl   $0x801078c2,(%esp)
80106cb6:	e8 a5 96 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106cbb:	c7 04 24 a8 78 10 80 	movl   $0x801078a8,(%esp)
80106cc2:	e8 99 96 ff ff       	call   80100360 <panic>
80106cc7:	89 f6                	mov    %esi,%esi
80106cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cd0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106cd0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106cd1:	31 c9                	xor    %ecx,%ecx
{
80106cd3:	89 e5                	mov    %esp,%ebp
80106cd5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80106cde:	e8 cd f6 ff ff       	call   801063b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ce3:	8b 00                	mov    (%eax),%eax
80106ce5:	89 c2                	mov    %eax,%edx
80106ce7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106cea:	83 fa 05             	cmp    $0x5,%edx
80106ced:	75 11                	jne    80106d00 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106cef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cf4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106cf9:	c9                   	leave  
80106cfa:	c3                   	ret    
80106cfb:	90                   	nop
80106cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106d00:	31 c0                	xor    %eax,%eax
}
80106d02:	c9                   	leave  
80106d03:	c3                   	ret    
80106d04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d10 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
80106d19:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106d1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d1f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106d22:	85 db                	test   %ebx,%ebx
80106d24:	75 3a                	jne    80106d60 <copyout+0x50>
80106d26:	eb 68                	jmp    80106d90 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d28:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d2b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d2d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106d31:	29 ca                	sub    %ecx,%edx
80106d33:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106d39:	39 da                	cmp    %ebx,%edx
80106d3b:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106d3e:	29 f1                	sub    %esi,%ecx
80106d40:	01 c8                	add    %ecx,%eax
80106d42:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d46:	89 04 24             	mov    %eax,(%esp)
80106d49:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106d4c:	e8 df d5 ff ff       	call   80104330 <memmove>
    len -= n;
    buf += n;
80106d51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106d54:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106d5a:	01 d7                	add    %edx,%edi
  while(len > 0){
80106d5c:	29 d3                	sub    %edx,%ebx
80106d5e:	74 30                	je     80106d90 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106d60:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106d63:	89 ce                	mov    %ecx,%esi
80106d65:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106d6b:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106d6f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106d72:	89 04 24             	mov    %eax,(%esp)
80106d75:	e8 56 ff ff ff       	call   80106cd0 <uva2ka>
    if(pa0 == 0)
80106d7a:	85 c0                	test   %eax,%eax
80106d7c:	75 aa                	jne    80106d28 <copyout+0x18>
  }
  return 0;
}
80106d7e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d86:	5b                   	pop    %ebx
80106d87:	5e                   	pop    %esi
80106d88:	5f                   	pop    %edi
80106d89:	5d                   	pop    %ebp
80106d8a:	c3                   	ret    
80106d8b:	90                   	nop
80106d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d90:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106d93:	31 c0                	xor    %eax,%eax
}
80106d95:	5b                   	pop    %ebx
80106d96:	5e                   	pop    %esi
80106d97:	5f                   	pop    %edi
80106d98:	5d                   	pop    %ebp
80106d99:	c3                   	ret    
80106d9a:	66 90                	xchg   %ax,%ax
80106d9c:	66 90                	xchg   %ax,%ax
80106d9e:	66 90                	xchg   %ax,%ax

80106da0 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106da6:	c7 44 24 04 00 79 10 	movl   $0x80107900,0x4(%esp)
80106dad:	80 
80106dae:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106db5:	e8 a6 d2 ff ff       	call   80104060 <initlock>
  acquire(&(shm_table.lock));
80106dba:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106dc1:	e8 8a d3 ff ff       	call   80104150 <acquire>
80106dc6:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
80106dcb:	90                   	nop
80106dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106dd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106dd6:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80106dd9:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80106de0:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (i = 0; i< 64; i++) {
80106de7:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
80106dec:	75 e2                	jne    80106dd0 <shminit+0x30>
  }
  release(&(shm_table.lock));
80106dee:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106df5:	e8 46 d4 ff ff       	call   80104240 <release>
}
80106dfa:	c9                   	leave  
80106dfb:	c3                   	ret    
80106dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e00 <shm_open>:

int shm_open(int id, char **pointer) {
80106e00:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106e01:	31 c0                	xor    %eax,%eax
int shm_open(int id, char **pointer) {
80106e03:	89 e5                	mov    %esp,%ebp
}
80106e05:	5d                   	pop    %ebp
80106e06:	c3                   	ret    
80106e07:	89 f6                	mov    %esi,%esi
80106e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e10 <shm_close>:


int shm_close(int id) {
80106e10:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106e11:	31 c0                	xor    %eax,%eax
int shm_close(int id) {
80106e13:	89 e5                	mov    %esp,%ebp
}
80106e15:	5d                   	pop    %ebp
80106e16:	c3                   	ret    
