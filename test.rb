#!/usr/bin/ruby


out=[]
out.push("手が離せませんッ")
out.push("ガンダム、次回大気圏突入")
out.push("ホワイトベースにあげて戦闘準備させるんだぞ")
out.push("あ、赤いやつだ")
out.push("シャアだって、戦場の戦いで勝って出世した")
out.push("これくらいはやってくれないとな")


loop do
  print "YOU: "
	gets
  puts "AI : #{out.shift}"
end
