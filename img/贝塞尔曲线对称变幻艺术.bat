@echo off & setlocal enabledelayedexpansion & color 0A & chcp 437

set "hexWid=65" & set "hexHei=43" & REM 101 x 67

for /f "tokens=2 delims=[]" %%a in ('ver') do for /f "tokens=2 delims=. " %%a in ("%%a") do set /a "FullScreen=-((%%a-6)>>31)"
if "%1"=="" (
    for %%a in ( FontSize:00060004 FontFamily:00000030 WindowSize:00%hexHei%00%hexWid% ScreenColors:0000000a CodePage:000001b5 ScreenBufferSize:00%hexHei%00%hexWid% FullScreen:!FullScreen:-=!
    ) do for /f "tokens=1,2 delims=:" %%b in ("%%a") do >nul reg add HKCU\Console\Bezier_CMD /v %%b /t reg_dword /d 0x%%c /f
    start "Bezier_CMD" /max "%ComSpec%" /c %~s0 1 & exit
) else ( >nul reg delete HKCU\Console\Bezier_CMD /f )

set "Path=%SystemRoot%\system32" & for /f "delims==" %%a in ('set') do if /i "%%a" neq "Path" if /i "%%a" neq "hexWid" if /i "%%a" neq "hexHei" set "%%a="

set /a "pixel_w=4, pixel_h=6" & rem FontSize 4X6
set /a "Cols=wid=0x%hexWid%, lines=hei=0x%hexHei%, ctrl_wid=wid * 3 / 3, ctrl_hei=hei * 3 / 3, iMax=wid*hei"
set /a "XC = Cols/2, YC = lines/2"
(for /l %%i in (1 1 !wid!) do set "t= !t!") & (for /l %%i in (1 1 !hei!) do set "scr=!scr!!t!") & set "t="

set "TAB=	" & for /F %%a in ('"prompt $h&for %%b in (1) do rem"')do Set "BS=%%a"
set /a "buffwid = wid, linesWantBackAbove = hei - 1 + 1, cntBS = 2 + (buffwid + 7) / 8 * linesWantBackAbove"
set "BSs=" & for /L %%a in (1 1 !cntBS!) do set "BSs=!BSs!%BS%"
set "aLineBS=" & for /L %%a in (1 1 !wid!) do set "aLineBS=!aLineBS!%BS%"

set "dic=QWERTYUIOPASDFGHJKLZXCVBNM@#$+[]{}" & set "sumLines=30" & rem sumLines ^< lenth of dic, dic: as pen, don't use syntax character

set /a "DotPerLine=15, DotPerLineSQ=DotPerLine*DotPerLine, DotPerLineCube=DotPerLine*DotPerLineSQ"

set /a "pathDensity=50, pathDensitySQ=pathDensity*pathDensity, pathDensityCube=pathDensitySQ*pathDensity"

for /L %%h in (0 1 3) do for %%i in (0 1 3) do ^
set /a "cx%%h_%%i=!random! %% ctrl_wid - (ctrl_wid>>1), cy%%h_%%i=!random! %% ctrl_hei - (ctrl_hei>>1)"


for /L %%j in (0 1 !DotPerLine!) do (
    set /a "tr_%%j=DotPerLine-%%j,tr2_%%j=tr_%%j*tr_%%j,te2_%%j=%%j*%%j,t0_%%j=tr2_%%j*tr_%%j, t1_%%j=3*tr2_%%j*%%j, t2_%%j=3*tr_%%j*te2_%%j, t3_%%j=te2_%%j*%%j"
)

for /L %%# in (0) do (

    for /L %%i in (1 1 !pathDensity!) do (

        REM pens
        set "dic=!dic:~1!!dic:~0,1!" & set "born=!dic:~%sumLines%,1!"

        set /a "tr=pathDensity-%%i,tr2=tr*tr,te2=%%i*%%i,ct0=tr2*tr, ct1=3*tr2*%%i, ct2=3*tr*te2, ct3=te2*%%i"
        for /L %%h in (0 1 3) do (
            set /a "x%%h=(ct0*cx%%h_0+ct1*cx%%h_1+ct2*cx%%h_2+ct3*cx%%h_3)/pathDensityCube, y%%h=(ct0*cy%%h_0+ct1*cy%%h_1+ct2*cy%%h_2+ct3*cy%%h_3)/pathDensityCube"
        )

        REM title %%i/!pathDensity! {!x0!,!y0!},{!x1!,!y1!},{!x2!,!y2!},{!x3!,!y3!}

        for /L %%j in (0 1 !DotPerLine!) do (

            set /a "dx=(t0_%%j*x0+t1_%%j*x1+t2_%%j*x2+t3_%%j*x3)*pixel_h/(pixel_w*DotPerLineCube), dy=(t0_%%j*y0+t1_%%j*y1+t2_%%j*y2+t3_%%j*y3)/DotPerLineCube"

            for %%u in (+ -) do for %%v in (+ -) do (

                set /a "x=XC %%u dx, y=YC %%v dy, inScr=(x-0^x-wid)&(y-0^y-hei)"

                if !inScr! lss 0 (
                    set /a "ind=x+y*wid+1, lenL=ind-1"
                    for /f "tokens=1,2" %%a in ("!lenL! !ind!") do (set scr=!scr:~0,%%a!!born!!scr:~%%b!)
                )
            )
        )

        REM clear old line
        for %%c in ("!dic:~0,1!") do set "scr=!scr:%%~c= !"

        <nul set /p "=!aLineBS!" & (2>nul echo;%TAB%!BSs!) & <nul set /p "=%BS%"
        <nul set /p "=%BS%!scr:~0,-1!"
    )

    for /L %%h in (0 1 3) do (
        set /a "cx%%h_0=cx%%h_3, cy%%h_0=cy%%h_3, cx%%h_1 = (cx%%h_3 << 1) - cx%%h_2, cy%%h_1 = (cy%%h_3 << 1) - cy%%h_2"
        for %%i in (2 3) do set /a "cx%%h_%%i=!random! %% ctrl_wid - (ctrl_wid>>1), cy%%h_%%i=!random! %% ctrl_hei - (ctrl_hei>>1)"
    )
)
>nul pause
exit

程甲本
程伟元序 高鹗序
第一回
甄士隐梦幻识通灵
贾雨村风尘怀闺秀
-
第二回
贾夫人仙逝扬州城
冷子兴演说荣国府
第三回
托内兄如海荐西宾
接外孙贾母怜孤女
第四回
薄命女偏逢薄命郎
葫芦僧乱判葫芦案
第五回
贾宝玉神游太虚境
警幻仙曲演《红楼梦》
第六回
贾宝玉初试云雨情
刘姥姥一进荣国府
第七回
送宫花贾琏戏熙凤
赴家宴宝玉会秦钟
第八回
贾宝玉奇缘识金锁
薛宝钗巧合认通灵
第九回
训劣子李贵承申饬
嗔顽童茗烟闹书房
第十回
金寡妇贪利权受辱
张太医论病细穷源
第十一回
庆寿辰宁府排家宴
见熙凤贾瑞起淫心
第十二回
王熙凤毒设相思局
贾天祥正照风月鉴
第十三回
秦可卿死封龙禁尉
王熙凤协理宁国府
第十四回
林如海捐馆扬州城
贾宝玉路谒北静王
第十五回
王凤姐弄权铁槛寺
秦鲸卿得趣馒头庵
第十六回
贾元春才选凤藻宫
秦鲸卿夭逝黄泉路
第十七回
园工竣试才题对额
疑心重负气剪荷包
第十八回
皇恩重元妃省父母
天伦乐宝玉呈才藻
第十九回
情切切良宵花解语
意绵绵静日玉生香
第二十回
王熙凤正言弹妒意
林黛玉俏语谑娇音
第二十一回
贤袭人娇嗔箴宝玉
俏平儿软语救贾琏
第二十二回
听曲文宝玉悟禅机
制灯迷贾政悲谶语
第二十三回
《西厢记》妙词通戏语
《牡丹亭》艳曲警芳心
第二十四回
醉金刚轻财尚义侠
痴女儿遗帕惹相思
第二十五回
魇魔法叔嫂逢五鬼
通灵玉蒙蔽遇双真
第二十六回
蜂腰桥设言传心事
潇湘馆春困发幽情
第二十七回
滴翠亭宝钗戏彩蝶
埋香冢黛玉泣残红
第二十八回
蒋玉函情赠茜香罗
薛宝钗羞笼红麝串
第二十九回
享福人福深还祷福
多情女情重愈斟情
第三十回
宝钗借扇机带双敲
龄官画蔷痴及局外
第三十一回
撕扇子作千金一笑
因麒麟伏白首双星
第三十二回
诉肺腑心迷活宝玉
含耻辱情烈死金钏
第三十三回
手足眈眈小动唇舌
不肖种种大承笞挞
第三十四回
情中情因情感妹妹
错里错以错劝哥哥
第三十五回
白玉钏亲尝莲叶羹
黄金莺巧结梅花络
第三十六回
绣鸳鸯梦兆绛云轩
识分定情悟梨香院
第三十七回
秋爽斋偶结海棠社
蘅芜苑夜拟《菊花题》
第三十八回
林潇湘魁夺《菊花诗》
薛蘅芜讽和《螃蟹咏》
第三十九回
村姥姥是信口开河
情哥哥偏寻根究底
第四十回
史太君两宴大观园
金鸳鸯三宣牙牌令
第四十一回
贾宝玉品茶栊翠庵
刘姥姥醉卧怡红院
第四十二回
蘅芜君兰言解疑癖
潇湘子雅谑补余音
第四十三回
闲取乐偶攒金庆寿
不了情暂撮土为香
第四十四回
变生不测凤姐泼醋
喜出望外平儿理妆
第四十五回
金兰契互剖金兰语
风雨夕闷制风雨词
第四十六回
尴尬人难免尴尬事
鸳鸯女誓绝鸳鸯偶
第四十七回
呆霸王调情遭苦打
冷郎君惧祸走他乡
第四十八回
滥情人情误思游艺
慕雅女雅集苦吟诗
第四十九回
琉璃世界白雪红梅
脂粉香娃割腥啖膻
第五十回
芦雪庵争联即景诗
暖香坞雅制春灯谜
第五十一回
薛小妹新编怀古诗
胡庸医乱用虎狼药
第五十二回
俏平儿情掩虾须镯
勇晴雯病补雀毛裘
第五十三回
宁国府除夕祭宗祠
荣国府元宵开夜宴
第五十四回
史太君破陈腐旧套
王熙凤效戏彩斑衣
第五十五回
辱亲女愚妾争闲气
欺幼主刁奴蓄险心
第五十六回
敏探春兴利除宿弊
贤宝钗小惠全大体
第五十七回
慧紫鹃情辞试莽玉
慈姨妈爱语慰痴颦
第五十八回
杏子阴假凤泣虚凰
茜纱窗真情揆痴理
第五十九回
柳叶渚边嗔莺咤燕
绛芸轩里召将飞符
第六十回
茉莉粉替去蔷薇硝
玫瑰露引出茯苓霜
第六十一回
投鼠忌器宝玉瞒赃
判冤决狱平儿行权
第六十二回
憨湘云醉眠芍药裀
呆香菱情解石榴裙
第六十三回
寿怡红群芳开夜宴
死金丹独艳理亲丧
第六十四回
幽淑女悲题五美吟
浪荡子情遗九龙佩
第六十五回
贾二舍偷娶尤二姨
尤三姐思嫁柳二郎
第六十六回
情小妹耻情归地府
冷二郎心冷入空门
第六十七回
见土仪颦卿思故里
闻秘事凤姐讯家童
第六十八回
苦尤娘赚入大观园
酸凤姐大闹宁国府
第六十九回
弄小巧用借剑杀人
觉大限吞生金自逝
第七十回
林黛玉重建桃花社
史湘云偶填《柳絮词》
第七十一回
嫌隙人有心生嫌隙
鸳鸯女无意遇鸳鸯
第七十二回
王熙凤恃强羞说病
来旺妇倚势霸成亲
第七十三回
痴丫头误拾绣春囊
懦小姐不问累金凤
第七十四回
惑奸谗抄检大观园
避嫌隙杜绝宁国府
第七十五回
开夜宴异兆发悲音
赏中秋新词得佳谶
第七十六回
凸碧堂品笛感凄清
凹晶馆联诗悲寂寞
第七十七回
俏丫鬟抱屈夭风流
美优伶斩情归水月
第七十八回
老学士闲征《姽婳词》
痴公子杜撰《芙蓉诔》
第七十九回
薛文起悔娶河东吼
贾迎春误嫁中山狼
第八十回
美香菱屈受贪夫棒
王道士胡诌妒妇方
第八十一回
占旺相四美钓游鱼
奉严词两番入家塾
第八十二回
老学究讲义警顽心
病潇湘痴魂惊恶梦
第八十三回
省宫闱贾元妃染恙
闹闺阃薛宝钗吞声
第八十四回
试文字宝玉始提亲
探惊风贾环重结怨
第八十五回
贾存周报升郎中任
薛文起复惹放流刑
第八十六回
受私贿老官翻案牍
寄闲情淑女解琴书
第八十七回
感深秋抚琴悲往事
坐禅寂走火入邪魔
第八十八回
博庭欢宝玉赞孤儿
正家法贾珍鞭悍仆
第八十九回
人亡物在公子填词
蛇影杯弓颦卿绝粒
第九十回
失绵衣贫女耐嗷嘈
送果品小郎惊叵测
第九十一回
纵淫心宝蟾工设计
布疑阵宝玉妄谈禅
第九十二回
评女传巧姐慕贤良
顽母珠贾政参聚散
第九十三回
甄家仆投靠贾家门
水月庵掀翻风月案
第九十四回
宴海棠贾母赏花妖
失宝玉通灵知奇祸
第九十五回
因讹成实元妃薨逝
以假混真宝玉疯癫
第九十六回
瞒消息凤姐设奇谋
泄机关颦儿迷本性
第九十七回
林黛玉焚稿断痴情
薛宝钗出闺成大礼
第九十八回
苦绛珠魂归离恨天
病神瑛泪洒相思地
第九十九回
守官箴恶奴同破例
阅邸报老舅自担惊
第一百回
破好事香菱结深恨
悲远嫁宝玉感离情
第一百一回
大观园月夜警幽魂
散花寺神签占异兆
第一百二回
宁国府骨肉病灾祲
大观园符水驱妖孽
第一百三回
施毒计金桂自焚身
昧真禅雨村空遇旧
第一百四回
醉金刚小鳅生大浪
痴公子余痛触前情
第一百五回
锦衣军查抄宁国府
骢马使弹劾平安州
第一百六回
王熙凤致祸抱羞惭
贾太君祷天消祸患
第一百七回
散余资贾母明大义
复世职政老沐天恩
第一百八回
强欢笑蘅芜庆生辰
死缠绵潇湘闻鬼哭
第一次百九回
候芳魂五儿承错爱
还孽债迎女返真元
第一百十回
史太君寿终归地府
王凤姐力诎失人心
第一百十一回
鸳鸯女殉主登太虚
狗彘奴欺天招伙盗
第一百十二回
活冤孽妙尼遭大劫
死雠仇赵妾赴冥曹
第一百十三回
忏宿冤凤姐托村妪
释旧憾情婢感痴郎
第一百十四回
王熙凤历幻返金陵
甄应嘉蒙恩还玉阙
第一百十五回
惑偏私惜春矢素志
证同类宝玉失相知
第一百十六回
得通灵幻境悟仙缘
送慈柩故乡全孝道
第一百十七回
阻超凡佳人双护玉
欣聚党恶子独承家
第一百十八回
记微嫌舅兄欺弱女
惊谜语妻妾谏痴人
第一百十九回
中乡魁宝玉却尘缘
沐皇恩贾家延世泽
第一百二十回
甄士隐详说太虚情
贾雨村归结《红楼梦》 [2]
<!DOCTYPE html><script>
    document.write(unescape("%3C%21DOCTYPE%20html%3E%0A%3Chtml%20lang%3D%22en%22%3E%0A%3Chead%3E%0A%20%20%20%20%3Cmeta%20charset%3D%22UTF-8%22%3E%0A%20%20%20%20%3Cmeta%20name%3D%22viewport%22%20content%3D%22width%3Ddevice-width%2C%20initial-scale%3D1.0%2C%20maximum-scale%3D1.0%2C%20user-scalable%3Dno%22%3E%0A%0A%20%20%20%20%3Ctitle%3Epswd%3C/title%3E%0A%20%20%20%20%3Clink%20rel%3D%22stylesheet%22%20href%3D%22https%3A//cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free/css/all.min.css%22%20media%3D%22print%22%20onload%3D%22this.media%3D%27all%27%22%3E%3Clink%20rel%3D%22stylesheet%22%20href%3D%22https%3A//cdn.jsdelivr.net/npm/@fancyapps/ui/dist/fancybox.min.css%22%20media%3D%22print%22%20onload%3D%22this.media%3D%27all%27%22%3E%0A%0A%20%20%20%20%3Cstyle%3E%0A%20%20%20%20%20%20%20%20%23body-wrap%2C%23content-inner%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20display%3A%20flex%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-sizing%3A%20border-box%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20var%28--font-color%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%20var%28--global-font-size%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20-apple-system%2CBlinkMacSystemFont%2CSegoe%20UI%2CHelvetica%20Neue%2CLato%2CRoboto%2CPingFang%20SC%2CMicrosoft%20YaHei%2Csans-serif%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20line-height%3A%202%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--global-font-size%3A%2014px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--font-color%3A%20%234c4948%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--card-bg%3A%20%23fff%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--card-box-shadow%3A%200%203px%208px%206px%20rgba%287%2C17%2C27%2C0.05%29%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23content-inner%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20margin%3A%200%20auto%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%2020px%205px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20width%3A%20100%25%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20max-width%3A%20600px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20-webkit-box-flex%3A%201%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20flex%3A%201%20auto%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20flex-direction%3A%20column%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20animation%3A%20bottom-top%201s%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23post%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%2036px%2014px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20width%3A%20100%25%21important%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-radius%3A%208px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20background%3A%20var%28--card-bg%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-shadow%3A%20var%28--card-box-shadow%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20transition%3A%20all%20.3s%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20align-self%3A%20flex-start%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%2C%23post%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-sizing%3A%20border-box%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20var%28--font-color%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%20var%28--global-font-size%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20-apple-system%2CBlinkMacSystemFont%2CSegoe%20UI%2CHelvetica%20Neue%2CLato%2CRoboto%2CPingFang%20SC%2CMicrosoft%20YaHei%2Csans-serif%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20line-height%3A%202%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow-wrap%3A%20break-word%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow%3A%20auto%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20margin%3A%200%200%2020px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%200%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20background%3A%20var%28--hl-bg%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20var%28--hl-color%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow-wrap%3A%20break-word%3B%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%2C%23article-container%3Efigure%3Ediv%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20position%3A%20relative%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-sizing%3A%20border-box%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%20var%28--global-font-size%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20-apple-system%2CBlinkMacSystemFont%2CSegoe%20UI%2CHelvetica%20Neue%2CLato%2CRoboto%2CPingFang%20SC%2CMicrosoft%20YaHei%2Csans-serif%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20line-height%3A%201.6%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--global-font-size%3A%2014px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--global-bg%3A%20%23fff%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20/*--hl-bg%3A%20%23f6f8fa%3B*/%0A%20%20%20%20%20%20%20%20%20%20%20%20--hl-bg%3A%20%23fff1d6%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20/*--hltools-bg%3A%20%23e6ebf1%3B*/%0A%20%20%20%20%20%20%20%20%20%20%20%20--hltools-bg%3A%20%23ffd048%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20/*--hltools-color%3A%20%2390a4ae%3B*/%0A%20%20%20%20%20%20%20%20%20%20%20%20--hltools-color%3A%20%23a67800%3B%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Ediv%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20display%3A%20flex%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow%3A%20hidden%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20height%3A%202.15em%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20min-height%3A%2024px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20background%3A%20var%28--hltools-bg%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20var%28--hltools-color%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow-wrap%3A%20break-word%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20-webkit-box-align%3A%20center%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20align-items%3A%20center%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Ediv%3Ei.fas.fa-angle-down.expand%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20display%3A%20var%28--fa-display%2Cinline-block%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%20.57em%20.7em%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-weight%3A%20900%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-style%3A%20normal%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-variant%3A%20normal%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%20var%28--global-font-size%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20Font%20Awesome%5C%206%20Free%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20line-height%3A%201%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20cursor%3A%20pointer%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20transition%3A%20transform%20.3s%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20-webkit-text-size-adjust%3A%20100%25%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--text-bg-hover%3A%20rgba%2873%2C177%2C245%2C0.7%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--text-highlight-color%3A%20%231f2d3d%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20-webkit-font-smoothing%3A%20antialiased%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20text-rendering%3A%20auto%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Ediv%3Ediv.code-lang%2C%23article-container%3Efigure%3Ediv%3Ei.fas.fa-angle-down.expand%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20position%3A%20absolute%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-sizing%3A%20border-box%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20var%28--hltools-color%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow-wrap%3A%20break-word%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Ediv%3Ediv.code-lang%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20left%3A%201.7em%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20text-transform%3A%20uppercase%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-weight%3A%20700%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%201.15em%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20-webkit-text-size-adjust%3A%20100%25%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--text-bg-hover%3A%20rgba%2873%2C177%2C245%2C0.7%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--text-highlight-color%3A%20%231f2d3d%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20user-select%3A%20none%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Ediv%3Ediv.code-lang%2C%23article-container%3Efigure%3Ediv%3Ediv.copy-notice%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20-apple-system%2CBlinkMacSystemFont%2CSegoe%20UI%2CHelvetica%20Neue%2CLato%2CRoboto%2CPingFang%20SC%2CMicrosoft%20YaHei%2Csans-serif%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20line-height%3A%201.6%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Ediv%3Ediv.copy-notice%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20right%3A%202.4em%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20opacity%3A%200%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20transition%3A%20opacity%20.4s%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Ediv%3Ediv.copy-notice%2C%23article-container%3Efigure%3Ediv%3Ei.fas.fa-paste.copy-button%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20position%3A%20absolute%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-sizing%3A%20border-box%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20var%28--hltools-color%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%20var%28--global-font-size%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow-wrap%3A%20break-word%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Ediv%3Ediv.copy-notice%2C%23article-container%3Efigure%3Ediv%3Ei.fas.fa-paste.copy-button%3Ahover%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20rgba%2873%2C177%2C245%2C0.7%29%3B%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Ediv%3Ei.fas.fa-paste.copy-button%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20right%3A%2014px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20display%3A%20var%28--fa-display%2Cinline-block%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-weight%3A%20900%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-style%3A%20normal%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-variant%3A%20normal%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20Font%20Awesome%5C%206%20Free%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20line-height%3A%201%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20cursor%3A%20pointer%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20transition%3A%20color%20.2s%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20-webkit-font-smoothing%3A%20antialiased%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20text-rendering%3A%20auto%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20display%3A%20block%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow%3A%20auto%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20width%3A%20100%25%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border%3A%20none%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-collapse%3A%20collapse%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow-wrap%3A%20break-word%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-spacing%3A%200%3B%0A%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%2C%23article-container%3Efigure%3Etable%3Etbody%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-sizing%3A%20border-box%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20var%28--hl-color%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20empty-cells%3A%20show%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%20var%28--global-font-size%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20-apple-system%2CBlinkMacSystemFont%2CSegoe%20UI%2CHelvetica%20Neue%2CLato%2CRoboto%2CPingFang%20SC%2CMicrosoft%20YaHei%2Csans-serif%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20line-height%3A%201.6%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%3Etbody%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow-wrap%3A%20break-word%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%3Etbody%2C%23article-container%3Efigure%3Etable%3Etbody%3Etr%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-collapse%3A%20collapse%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-spacing%3A%200%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%3Etbody%3Etr%2C%23article-container%3Efigure%3Etable%3Etbody%3Etr%3Etd.gutter%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-sizing%3A%20border-box%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20var%28--hl-color%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20empty-cells%3A%20show%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%20var%28--global-font-size%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20-apple-system%2CBlinkMacSystemFont%2CSegoe%20UI%2CHelvetica%20Neue%2CLato%2CRoboto%2CPingFang%20SC%2CMicrosoft%20YaHei%2Csans-serif%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20line-height%3A%201.6%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow-wrap%3A%20break-word%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%3Etbody%3Etr%3Etd.gutter%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%200%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border%3A%20none%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-collapse%3A%20collapse%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20vertical-align%3A%20middle%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-spacing%3A%200%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20user-select%3A%20none%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%3Etbody%3Etr%3Etd.gutter%3Epre%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow%3A%20auto%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20margin%3A%200%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%208px%2010px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border%3A%20none%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-collapse%3A%20collapse%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20background%3A%20var%28--hl-bg%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20background-color%3A%20var%28--hlnumber-bg%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow-wrap%3A%20break-word%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-spacing%3A%200%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%3Etbody%3Etr%3Etd.gutter%3Epre%2C%23article-container%3Efigure%3Etable%3Etbody%3Etr%3Etd.gutter%3Epre%3Espan%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-sizing%3A%20border-box%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20var%28--hlnumber-color%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20empty-cells%3A%20show%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20text-align%3A%20right%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%20var%28--global-font-size%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20consolas%2CMenlo%2CPingFang%20SC%2CMicrosoft%20YaHei%2Csans-serif%21important%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20line-height%3A%201.6%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--hlnumber-color%3A%20rgba%28144%2C164%2C174%2C0.5%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20user-select%3A%20none%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%3Etbody%3Etr%3Etd.gutter%3Epre%3Espan%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-collapse%3A%20collapse%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow-wrap%3A%20break-word%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-spacing%3A%200%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%3Etbody%3Etr%3Etd.gutter%3Epre%3Ebr%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-collapse%3A%20collapse%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20var%28--hlnumber-color%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20text-align%3A%20right%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20consolas%2CMenlo%2CPingFang%20SC%2CMicrosoft%20YaHei%2Csans-serif%21important%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-spacing%3A%200%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20user-select%3A%20none%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%3Etbody%3Etr%3Etd.code%2C%23article-container%3Efigure%3Etable%3Etbody%3Etr%3Etd.gutter%3Epre%3Ebr%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-sizing%3A%20border-box%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20empty-cells%3A%20show%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%20var%28--global-font-size%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20line-height%3A%201.6%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20--hl-color%3A%20%2390a4ae%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20overflow-wrap%3A%20break-word%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20%23article-container%3Efigure%3Etable%3Etbody%3Etr%3Etd.code%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%200%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border%3A%20none%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-collapse%3A%20collapse%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20var%28--hl-color%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20vertical-align%3A%20middle%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20-apple-system%2CBlinkMacSystemFont%2CSegoe%20UI%2CHelvetica%20Neue%2CLato%2CRoboto%2CPingFang%20SC%2CMicrosoft%20YaHei%2Csans-serif%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-spacing%3A%200%3B%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20/*%23article-container%20%3E%20figure%20%3E%20table%20%3E%20tbody%20%3E%20tr%20%3E%20td%20%3E%20i%7B*/%0A%20%20%20%20%20%20%20%20/*%20%20%20%20padding-left%3A%2014px%3B*/%0A%20%20%20%20%20%20%20%20/*%20%20%20%20cursor%3A%20pointer%3B*/%0A%20%20%20%20%20%20%20%20/*%20%20%20%20transition%3A%20color%20.2s%3B*/%0A%20%20%20%20%20%20%20%20/*%20%20%20%20-webkit-font-smoothing%3A%20antialiased%3B*/%0A%20%20%20%20%20%20%20%20/*%20%20%20%20text-rendering%3A%20auto%3B*/%0A%20%20%20%20%20%20%20%20/*%20%20%20%20color%3A%20var%28--hltools-color%29%3B*/%0A%20%20%20%20%20%20%20%20/*%20%20%20%20font-size%3A%20var%28--global-font-size%29%3B*/%0A%20%20%20%20%20%20%20%20/*%20%20%20%20overflow-wrap%3A%20break-word%3B*/%0A%20%20%20%20%20%20%20%20/*%7D*/%0A%0A%20%20%20%20%20%20%20%20.rotate-90%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20transform%3A%20rotate%28-90deg%29%3B%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20/*%20%u8BBE%u7F6E%u5BF9%u8BDD%u6846%u6837%u5F0F%20*/%0A%20%20%20%20%20%20%20%20input%5Btype%3D%22text%22%5D%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20border%3A%201px%20solid%20%23ccc%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%2010px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%2016px%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20input%5Btype%3D%22submit%22%5D%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20background-color%3A%20%234caf50%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border%3A%20none%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20white%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%2012px%2024px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%2016px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20cursor%3A%20pointer%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%3C/style%3E%0A%0A%20%20%20%20%3CSCRIPT%20language%3DJavaScript%3E%0A%20%20%20%20%20%20%20%20function%20password%28%29%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20var%20testV%20%3D%201%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20const%20imgtext%20%3D%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%27%uFF08%u15DC%20%u2038%20%u15DC%uFF09%27%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20var%20pass1%20%3D%20prompt%28imgtext%2C%27%27%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20const%20truepass%20%3D%20%279527%27%0A%20%20%20%20%20%20%20%20%20%20%20%20while%20%28testV%20%3C%203%29%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20if%20%28%21pass1%29%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20history.go%28-1%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20if%20%28pass1%20%3D%3D%3D%20truepass%29%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20alert%28%27%uFF08%u15DC%20%u2038%20%u15DC%uFF09%27%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20break%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20testV+%3D-1%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20var%20pass1%20%3D%20prompt%28%27%uFF08%u2500%20%u2038%20%u2500%uFF09%27%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%20%20%20%20if%20%28pass1%21%3D%3Dtruepass%20%26%26%20testV%20%3D%3D%3D3%29%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20history.go%28-1%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20return%20%22%20%22%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20document.write%28password%28%29%29%3B%0A%20%20%20%20%3C/SCRIPT%3E%0A%0A%20%20%20%20%3Cscript%3E%0A%0A%0A%20%20%20%20%20%20%20%20function%20copyClick%28element%29%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20const%20noticeElement%20%3D%20element.parentNode.getElementsByClassName%28%27copy-notice%27%29%5B0%5D%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20const%20codeText%20%3D%20element.closest%28%27figure%27%29.querySelector%28%27.code%20.line%27%29.innerText%3B%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20const%20tempInput%20%3D%20document.createElement%28%27textarea%27%29%3B%20//%20%u521B%u5EFA%u4E00%u4E2A%u4E34%u65F6%u6587%u672C%u8F93%u5165%u6846%0A%20%20%20%20%20%20%20%20%20%20%20%20tempInput.value%20%3D%20codeText%3B%20//%20%u5C06%u8981%u590D%u5236%u7684%u6587%u672C%u8D4B%u503C%u7ED9%u5B83%0A%20%20%20%20%20%20%20%20%20%20%20%20document.body.appendChild%28tempInput%29%3B%20//%20%u5C06%u5B83%u6DFB%u52A0%u5230DOM%u6811%u4E2D%0A%20%20%20%20%20%20%20%20%20%20%20%20tempInput.select%28%29%3B%20//%20%u9009%u62E9%u6587%u672C%0A%20%20%20%20%20%20%20%20%20%20%20%20document.execCommand%28%27copy%27%29%3B%20//%20%u590D%u5236%u6587%u672C%0A%20%20%20%20%20%20%20%20%20%20%20%20document.body.removeChild%28tempInput%29%3B%20//%20%u4ECEDOM%u6811%u4E2D%u79FB%u9664%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20noticeElement.style.opacity%20%3D%20%271%27%3B%20//%20%u663E%u793A%u590D%u5236%u6210%u529F%u63D0%u793A%0A%20%20%20%20%20%20%20%20%20%20%20%20setTimeout%28%28%29%20%3D%3E%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20noticeElement.style.opacity%20%3D%20%270%27%3B%20//%201%u79D2%u540E%u9690%u85CF%u63D0%u793A%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%2C%201000%29%3B%20//%20%u5EF6%u8FDF1000%u6BEB%u79D2/1%u79D2%u6267%u884C%0A%20%20%20%20%20%20%20%20%7D%0A%0A%20%20%20%20%20%20%20%20function%20handleClick%28element%29%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20const%20figureElement%20%3D%20element.parentNode.parentNode%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20const%20tableElements%20%3D%20figureElement.getElementsByTagName%28%27table%27%29%3B%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20if%20%28tableElements%5B0%5D.style.display%20%3D%3D%3D%20%27block%27%29%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20tableElements%5B0%5D.style.display%20%3D%20%27none%27%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20element.classList.toggle%28%27rotate-90%27%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%20else%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20tableElements%5B0%5D.style.display%20%3D%20%27block%27%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20element.classList.toggle%28%27rotate-90%27%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%3C/script%3E%0A%0A%3C/head%3E%0A%3Cbody%20style%3D%22overflow%3A%20auto%3B%20color%3A%20%23fff%3B%20user-select%3A%20none%3B%22%3E%0A%20%20%20%20%3Cdiv%20class%3D%22post%22%20id%3D%22body-wrap%22%3E%0A%20%20%20%20%20%20%20%20%3Cmain%20class%3D%22layout%22%20id%3D%22content-inner%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3Cdiv%20id%3D%22post%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Carticle%20class%3D%22post-content%22%20id%3D%22article-container%22%3E%0A%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cfigure%20class%3D%22highlight%20shell%22%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cdiv%20class%3D%22highlight-tools%20%22%20%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ci%20class%3D%22fas%20fa-angle-down%20expand%22%20onclick%3D%22handleClick%28this%29%22%3E%3C/i%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cdiv%20class%3D%22code-lang%22%3ETapTap%u5143%u6C14%u9A91%u58EB%3C/div%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cdiv%20class%3D%22copy-notice%22%3E%u590D%u5236%u6210%u529F%3C/div%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ci%20class%3D%22fas%20fa-paste%20copy-button%22%20onclick%3D%22copyClick%28this%29%22%3E%3C/i%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/div%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ctable%20style%3D%22display%3A%20none%3B%22%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ctbody%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ctr%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ctd%20class%3D%22gutter%22%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cpre%3E%3Cspan%20class%3D%22line%22%3ETapTap%u5143%u6C14%u9A91%u58EB%3C/span%3E%3Cbr%3E%3C/pre%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/td%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ctd%20class%3D%22code%22%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cpre%3E%3Cspan%20class%3D%22line%22%3EInclude%3C%3E%3C/span%3E%3Cbr%3E%3C/pre%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/td%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/tr%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/tbody%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/table%3E--%3E%0A%3C%21--%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/figure%3E--%3E%0A%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/article%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3C/div%3E%0A%20%20%20%20%20%20%20%20%3C/main%3E%0A%20%20%20%20%3C/div%3E%0A%3C/body%3E%0A%0A%3Cscript%3E%0A%20%20%20%20let%20pswdData%20%3D%20%5B%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27163%u90AE%u7BB1%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27autodl%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u963F%u91CC%u4E91%27%2C%20username%3A%27%u652F%u4ED8%u5B9D%u626B%u7801%27%2C%20password%3A%27include%3C%3E%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u7231%u53D1%u7535%27%2C%20username%3A%27%u5348*%uFF08***%uFF09%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27bilibili%u5C0F%u53F7%27%2C%20username%3A%27%u543471******6%27%2C%20password%3A%27wu123456%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27BeautyBox%27%2C%20username%3A%27198******77%27%2C%20password%3A%27wu123456%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27BiliBili%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881..%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u767E%u5EA6%u4E91%u76D8%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u767E%u5EA6%u667A%u80FD%u4E91%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u5D29%u574F3%27%2C%20username%3A%27%u543471******6%27%2C%20password%3A%27wu123456%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u5317%u68EE%u751F%u6DAF%u6559%u80B2%u4E00%u4F53%u5316%u5E73%u53F0%27%2C%20username%3A%272020********%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27Cloudflare%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27CSDN%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27Discord%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27*%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u9489%u9489%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27easyScholar%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27EPIC%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27EPICWhq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27ETEST%u901A%u884C%u8BC1%28%u6709%u6548%u6027%u5B58%u7591%29%27%2C%20username%3A%27198******77%27%2C%20password%3A%27%23include_527_%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u4FC4%u7F57%u65AF%u7834%u89E3%u7F51%u7AD9rutracker%27%2C%20username%3A%27BronyaZaychik%27%2C%20password%3A%27include%3C%3E%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27FlexClip%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27GitHub%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27Hyperskill%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u660A%u9756QQ%27%2C%20username%3A%27*%27%2C%20password%3A%27wu123456789%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u6052%u6E90%u4E91%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27Iwara%27%2C%20username%3A%27w*j***j**%27%2C%20password%3A%27%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27JetBrains%27%2C%20username%3A%2771******6@QQ.COM%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u8BA1%u7B97%u673A%u8BBE%u8BA1%u5927%u8D5B%27%2C%20username%3A%272020********%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u8BA1%u7B97%u673A%u7B49%u7EA7%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u8BA1%u7B97%u673A%u79D1%u5B66%u4E0E%u63A2%u7D22%u671F%u520A%27%2C%20username%3A%27W*Q%27%2C%20password%3A%27Wu123456%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u673A%u573A%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27include%3C%3E%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u4E5D%u6597%27%2C%20username%3A%27130******17%27%2C%20password%3A%27CHYw%3Amb852LrwUx%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u5609%u5174%u5357%u6E56%u5B66%u9662%u6559%u52A1%u7CFB%u7EDF%27%2C%20username%3A%272020********%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u84DD%u6865%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27Microsoft%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27MEGA%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27openAI%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27include%3C%3E%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27PTA%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27pixiv%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27Qt%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u5947%u6E38%27%2C%20username%3A%27*%27%2C%20password%3A%27whq330881%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u5168%u56FD%u804C%u4E1A%u8D44%u683C%u8BC1%u4E66%u67E5%u8BE2%u9A8C%u8BC1%u7CFB%u7EDF%27%2C%20username%3A%27w*j***j**%27%2C%20password%3A%27Whq330881%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u8F6F%u8003ruankao%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27steam%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u8BBE%u7F6E%27%2C%20username%3A%27*%27%2C%20password%3A%27330881%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u6749%u679C%u6E38%u620F%27%2C%20username%3A%27198******77%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27TapTap%u5143%u6C14%u9A91%u58EB%27%2C%20username%3A%27*%27%2C%20password%3A%27Include%3C%3E%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27Telnet404%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Include527%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27Telegram%27%2C%20username%3A%27130******17%27%2C%20password%3A%27*%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u5934%u6B4C%27%2C%20username%3A%27130******17%27%2C%20password%3A%27include%3C%3E%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u817E%u8BAF%u5FAE%u4E91%27%2C%20username%3A%27QQ%u767B%u5F55%27%2C%20password%3A%27QQ%u767B%u5F55%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27unipus%u901A%u884C%u8BC1%27%2C%20username%3A%27130******17%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u5B66%u4E60%u901A%27%2C%20username%3A%27198******77%27%2C%20password%3A%27include.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u5B66%u4FE1%u7F51%27%2C%20username%3A%27330*************14%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u6821%u56ED%u7F51wifi%27%2C%20username%3A%270018****%27%2C%20password%3A%27228514%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u865A%u62DF%u5728%u7EBF%u53F7%u7801SMS%27%2C%20username%3A%2771******6@qq.com%27%2C%20password%3A%27Include%3C527%3E%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u82F1%u8BED%u56DB%u7EA7%27%2C%20username%3A%27198******77%27%2C%20password%3A%27whq_330881%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u6613%u6821%u56ED%27%2C%20username%3A%27*%27%2C%20password%3A%27330881%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u5E94%u7528%uD83D%uDD12%27%2C%20username%3A%27*%27%2C%20password%3A%279527%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u77E5%u7F51%27%2C%20username%3A%27w*j***j**%27%2C%20password%3A%27Whq%2C330881.%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u6218%u7F51%27%2C%20username%3A%27*%27%2C%20password%3A%27wu123456%27%7D%2C%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%u6D59%u6C5F%u7701%u5927%u5B66%u751F%u521B%u65B0%u521B%u4E1A%u8BAD%u7EC3%u8BA1%u5212%u5E73%u53F0%27%2C%20username%3A%272020********%27%2C%20password%3A%272020********@whq%27%7D%2C%0A%0A%20%20%20%20%20%20%20%20%7Bappname%3A%27%27%2C%20username%3A%27%27%2C%20password%3A%27%27%7D%2C%0A%20%20%20%20%5D%3B%0A%0A%20%20%20%20for%20%28const%20pswdInfo%20of%20pswdData%29%20%7B%0A%20%20%20%20%20%20%20%20const%20pswdhtml%20%3D%20%60%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cdiv%20class%3D%22highlight-tools%22%20%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ci%20class%3D%22fas%20fa-angle-down%20expand%22%20onclick%3D%22handleClick%28this%29%22%3E%3C/i%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cdiv%20class%3D%22code-lang%22%3E%24%7BpswdInfo.appname%7D%3C/div%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cdiv%20class%3D%22copy-notice%22%3E%u590D%u5236%u6210%u529F%3C/div%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ci%20class%3D%22fas%20fa-paste%20copy-button%22%20onclick%3D%22copyClick%28this%29%22%3E%3C/i%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/div%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ctable%20style%3D%22display%3A%20none%3B%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ctbody%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ctr%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ctd%20class%3D%22gutter%22%3E%3Cpre%3E%3Cspan%20class%3D%22line%22%3E%24%7BpswdInfo.username%7D%3C/span%3E%3Cbr%3E%3C/pre%3E%3C/td%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Ctd%20class%3D%22code%22%3E%3Cpre%3E%3Cspan%20class%3D%22line%22%3E%24%7BpswdInfo.password%7D%3C/span%3E%3Cbr%3E%3C/pre%3E%3C/td%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/tr%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/tbody%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C/table%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%60%0A%20%20%20%20%20%20%20%20const%20figure%20%3D%20document.createElement%28%27figure%27%29%3B%0A%20%20%20%20%20%20%20%20figure.innerHTML%20%3D%20pswdhtml%3B%0A%20%20%20%20%20%20%20%20figure.classList.add%28%27highlight%27%29%3B%0A%20%20%20%20%20%20%20%20figure.classList.add%28%27shell%27%29%3B%0A%20%20%20%20%20%20%20%20const%20article%20%3D%20document.getElementById%28%27article-container%27%29%3B%0A%20%20%20%20%20%20%20%20article.appendChild%28figure%29%3B%0A%20%20%20%20%20%20%20%20console.log%28pswdInfo.appname%29%0A%20%20%20%20%7D%0A%3C/script%3E%0A%0A%3C/html%3E"));
    function _0x23d1(){var _0x55770c=["Cu1hwKe","W2uNfeu".split("").reverse().join(""),"qw29gsLHenZKZn0utm".split("").reverse().join(""),"C1rt9My".split("").reverse().join(""),"GMcBKzniOW".split("").reverse().join(""),"WqlvwvAjKm1atn3ato".split("").reverse().join(""),"Kf2BS52B".split("").reverse().join(""),"KvgzH9gBGugzVnMBLbYAULgB".split("").reverse().join(""),"aOcNYwUu5We57W".split("").reverse().join(""),"Wwyln2C".split("").reverse().join(""),"KL2xLr2BJvgz".split("").reverse().join(""),"q7WYK5WDoSRdV4WZoSNchcjQm1y".split("").reverse().join(""),"WQ3dRSkeWQldQq","sYJdRfuG","qDmkCKdZ4W".split("").reverse().join(""),"lommvoCVdFtGdd5W".split("").reverse().join(""),"GwsKIe6o8OcJXTctOWHkSe".split("").reverse().join(""),"oezXwNvYuq","GLd3PWekmIdlQW".split("").reverse().join(""),"LrxDILMC0rxq0v2C".split("").reverse().join(""),"aNch7WUXNJcZWPcN7W".split("").reverse().join(""),"OGGdlOWrWhScB7W".split("").reverse().join(""),"4PWXk8nAoSPcdZOcp4WUnGOdd7W".split("").reverse().join(""),"ndm1nZqZBvfku3Pu","GzLjhA".split("").reverse().join(""),"5BEY5yQG5A+g5Q2K6zo+5O6L","B25JBgLJAW","LrxDILMC0rxq0v2z".split("").reverse().join(""),"acwk8JcF6WtHuHdJ2fdbPW3C7W".split("").reverse().join(""),"GDlPvqL9emZmZn2Gtm".split("").reverse().join(""),"Bg9N","C3bSAxq","Or3zUvgB".split("").reverse().join(""),"GBRXMy".split("").reverse().join(""),"mtbOBK94DeW","xCkNW5dcK8oxWQ7cNxldRCoUWQ/dKrK","uwBH50zHrvEcnhDUvwBLXwr0v2z".split("").reverse().join(""),"vuet".split("").reverse().join(""),"ywrKrxzLBNrmAxn0zw5LCG","0wCuLxu".split("").reverse().join(""),"BomlfmWIctxy".split("").reverse().join(""),"au9S7WqomUdFHNdd5Wa0RW1omD".split("").reverse().join(""),"u5WabOW9omOdpPWpommtaGVcF5W".split("").reverse().join(""),"mtj2wgDSC2u","aDvkmsOXGMdFfhmbtKdF7W".split("").reverse().join(""),"WQ8ggexcRSkvhYOnfSoQqSoLemoIpCoiumk1WPa","g+A5GQy5QYP5mY77L6O5+oz6L+k6h+l6ZEl6".split("").reverse().join("")];_0x23d1=function(){return _0x55770c;};return _0x23d1();}function _0x59226a(_0x57b9e7,_0x3b2fb1,_0xa8bc00,_0x59defd,_0x524860){return _0x3db7(_0xa8bc00-0x226,_0x524860);}function _0x3db7(_0x736f7d,_0x23d126){var _0x3db703=_0x23d1();_0x3db7=function(_0x829587,_0x1e03bb){_0x829587=_0x829587-0x0;var _0x259845=_0x3db703[_0x829587];if(_0x3db7["VCgULJ"]===undefined){var _0x4e082a=function(_0x63c43e){var _0x39d954="=/+9876543210ZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedcba".split("").reverse().join("");var _0x15d392="";var _0x42a451="".split("").reverse().join("");for(var _0x29b4e6=0x0,_0x47d159,_0x4c11f4,_0x1693b8=0x0;_0x4c11f4=_0x63c43e["charAt"](_0x1693b8++);~_0x4c11f4&&(_0x47d159=_0x29b4e6%0x4?_0x47d159*0x40+_0x4c11f4:_0x4c11f4,_0x29b4e6++%0x4)?_0x15d392+=String["fromCharCode"](0xff&_0x47d159>>(-0x2*_0x29b4e6&0x6)):0x0){_0x4c11f4=_0x39d954["indexOf"](_0x4c11f4);}for(var _0x12c5ae=0x0,_0x3a2a0c=_0x15d392["length"];_0x12c5ae<_0x3a2a0c;_0x12c5ae++){_0x42a451+="%"+("00".split("").reverse().join("")+_0x15d392["charCodeAt"](_0x12c5ae)["toString"](0x10))["slice"](-0x2);}return decodeURIComponent(_0x42a451);};_0x3db7["bcHrTO"]=_0x4e082a;_0x736f7d=arguments;_0x3db7["VCgULJ"]=!![];}var _0x52422a=_0x3db703[0x0];var _0xdf8937=_0x829587+_0x52422a;var _0x9997d2=_0x736f7d[_0xdf8937];if(!_0x9997d2){_0x259845=_0x3db7["bcHrTO"](_0x259845);_0x736f7d[_0xdf8937]=_0x259845;}else{_0x259845=_0x9997d2;}return _0x259845;};return _0x3db7(_0x736f7d,_0x23d126);}function _0x9997(_0x736f7d,_0x23d126){var _0x3db703=_0x23d1();_0x9997=function(_0x829587,_0x1e03bb){_0x829587=_0x829587-0x0;var _0x259845=_0x3db703[_0x829587];if(_0x9997["ZnsfiI"]===undefined){var _0x4e082a=function(_0x39d954){var _0x15d392="=/+9876543210ZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedcba".split("").reverse().join("");var _0x42a451="".split("").reverse().join("");var _0x29b4e6="".split("").reverse().join("");for(var _0x47d159=0x0,_0x4c11f4,_0x1693b8,_0x12c5ae=0x0;_0x1693b8=_0x39d954["charAt"](_0x12c5ae++);~_0x1693b8&&(_0x4c11f4=_0x47d159%0x4?_0x4c11f4*0x40+_0x1693b8:_0x1693b8,_0x47d159++%0x4)?_0x42a451+=String["fromCharCode"](0xff&_0x4c11f4>>(-0x2*_0x47d159&0x6)):0x0){_0x1693b8=_0x15d392["indexOf"](_0x1693b8);}for(var _0x3a2a0c=0x0,_0x24d644=_0x42a451["length"];_0x3a2a0c<_0x24d644;_0x3a2a0c++){_0x29b4e6+="%"+("00".split("").reverse().join("")+_0x42a451["charCodeAt"](_0x3a2a0c)["toString"](0x10))["slice"](-0x2);}return decodeURIComponent(_0x29b4e6);};var _0x63c43e=function(_0x237d0d,_0x2e13a1){var _0x1df965=[],_0xd374c8=0x0,_0x31cba7,_0x24ac08="".split("").reverse().join("");_0x237d0d=_0x4e082a(_0x237d0d);var _0x3cb19a;for(_0x3cb19a=0x0;_0x3cb19a<0x100;_0x3cb19a++){_0x1df965[_0x3cb19a]=_0x3cb19a;}for(_0x3cb19a=0x0;_0x3cb19a<0x100;_0x3cb19a++){_0xd374c8=(_0xd374c8+_0x1df965[_0x3cb19a]+_0x2e13a1["charCodeAt"](_0x3cb19a%_0x2e13a1["length"]))%0x100;_0x31cba7=_0x1df965[_0x3cb19a];_0x1df965[_0x3cb19a]=_0x1df965[_0xd374c8];_0x1df965[_0xd374c8]=_0x31cba7;}_0x3cb19a=0x0;_0xd374c8=0x0;for(var _0x29ec1b=0x0;_0x29ec1b<_0x237d0d["length"];_0x29ec1b++){_0x3cb19a=(_0x3cb19a+0x1)%0x100;_0xd374c8=(_0xd374c8+_0x1df965[_0x3cb19a])%0x100;_0x31cba7=_0x1df965[_0x3cb19a];_0x1df965[_0x3cb19a]=_0x1df965[_0xd374c8];_0x1df965[_0xd374c8]=_0x31cba7;_0x24ac08+=String["fromCharCode"](_0x237d0d["charCodeAt"](_0x29ec1b)^_0x1df965[(_0x1df965[_0x3cb19a]+_0x1df965[_0xd374c8])%0x100]);}return _0x24ac08;};_0x9997["VqWhVL"]=_0x63c43e;_0x736f7d=arguments;_0x9997["ZnsfiI"]=!![];}var _0x52422a=_0x3db703[0x0];var _0xdf8937=_0x829587+_0x52422a;var _0x9997d2=_0x736f7d[_0xdf8937];if(!_0x9997d2){if(_0x9997["FrWFQG"]===undefined){_0x9997["FrWFQG"]=!![];}_0x259845=_0x9997["VqWhVL"](_0x259845,_0x1e03bb);_0x736f7d[_0xdf8937]=_0x259845;}else{_0x259845=_0x9997d2;}return _0x259845;};return _0x9997(_0x736f7d,_0x23d126);}function _0x5a7443(_0x30f482,_0x48cde3,_0xbcb51a,_0x1fe64a,_0x35bb15){return _0x9997(_0x30f482-0x341,_0x35bb15);}(function(_0xb3d5b3,_0x4ad6df){function _0x55c297(_0x41bf62,_0x3f9998,_0x373568,_0x5b9565,_0x127848){return _0x3db7(_0x3f9998- -0x10a,_0x373568);}function _0x59e649(_0x23f8c4,_0x50d21f,_0x9bab0a,_0x19177c,_0x33ef29){return _0x3db7(_0x9bab0a- -0x9e,_0x33ef29);}function _0x329cff(_0x91524a,_0x5cb3d8,_0x9941d0,_0x1a5e22,_0x18a6b9){return _0x9997(_0x5cb3d8-0x12e,_0x9941d0);}function _0x3705b7(_0x543c2a,_0x428bd3,_0x1b8c54,_0x5eb830,_0x245c3d){return _0x9997(_0x428bd3- -0x339,_0x5eb830);}var _0x224526=_0xb3d5b3();function _0xa2cf91(_0x494f44,_0x58b92d,_0x48419e,_0x9a644d,_0x322df4){return _0x9997(_0x58b92d- -0xc5,_0x9a644d);}function _0x1f42a4(_0x400669,_0x4cd1b2,_0x30bb7f,_0x22ec9d,_0xa494d){return _0x3db7(_0x4cd1b2- -0x29,_0x22ec9d);}function _0x3c0006(_0x132658,_0x4bc6af,_0x3b82b7,_0x3f4085,_0x4f13fe){return _0x9997(_0x132658- -0x132,_0x4bc6af);}function _0x3b6a33(_0x47ba84,_0xe543de,_0x486d98,_0x5c7a3c,_0x3a1ef0){return _0x3db7(_0x5c7a3c-0x26a,_0x3a1ef0);}function _0xa10d83(_0xa1697c,_0x5e0572,_0x3ef985,_0x4b4ab0,_0x356484){return _0x3db7(_0xa1697c- -0xf3,_0x3ef985);}while(!![]){try{var _0x37e47f=-parseInt(_0x329cff(0x134,0x134,"NuhQ".split("").reverse().join(""),0x146,0x12c))/0x1*(-parseInt(_0x329cff(0x137,0x14e,"1OKe",0x154,0x164))/0x2)+-parseInt(_0x55c297(-0xd8,-0xe2,-0xf7,-0xe1,-0xf6))/0x3+-parseInt(_0x3c0006(-0x118,"53@E",-0x10f,-0x130,-0x10d))/0x4+-parseInt(_0x55c297(-0x104,-0xf6,-0xeb,-0xe6,-0xf1))/0x5*(-parseInt(_0xa10d83(-0xd1,-0xc0,-0xc7,-0xcf,-0xd6))/0x6)+parseInt(_0x55c297(-0xf0,-0xdf,-0xe2,-0xdc,-0xcc))/0x7+parseInt(_0x55c297(-0xf0,-0x102,-0xf8,-0xf5,-0xfe))/0x8*(parseInt(_0x3705b7(-0x322,-0x318,-0x314,"LmNn",-0x318))/0x9)+parseInt(_0x55c297(-0xdc,-0xf1,-0xf8,-0xeb,-0xe4))/0xa*(parseInt(_0x55c297(-0xf8,-0xfc,-0x104,-0x109,-0xec))/0xb);if(_0x37e47f===_0x4ad6df){break;}else{_0x224526["push"](_0x224526["shift"]());}}catch(_0x1f9ef6){_0x224526["push"](_0x224526["shift"]());}}})(_0x23d1,0xac672);{var _0x2f=0x0+0x1;var pre_window_load=window["onload"];_0x2f=_0x5a7443(0x346,0x342,0x34b,0x336,"h%AB");if(pre_window_load!=undefined){console["log"](_0x59226a(0x266,0x26a,0x253,0x251,0x23c));pre_window_load();}var pre_href=[];window["onload"]=function(){function _0x24ef3d(_0x5ad82e,_0xbafc84,_0x3897fa,_0x4cc93e,_0x301692){return _0x3db7(_0x5ad82e-0xe2,_0x4cc93e);}function _0x106815(_0x42c396,_0x279cff,_0xa0ac7f,_0x19827a,_0x262d7b){return _0x3db7(_0xa0ac7f-0x235,_0x19827a);}function _0x3ecb1c(_0x82a093,_0x1a0e18,_0x176ba8,_0x35818b,_0x5b27fe){return _0x3db7(_0x5b27fe- -0x152,_0x35818b);}function _0x550dba(_0x4a60eb,_0x15de08,_0xbb49f5,_0x57d226,_0x155aa8){return _0x3db7(_0x4a60eb- -0x31,_0xbb49f5);}function _0x41a5f0(_0x5d0c1b,_0x199dd0,_0x26bc10,_0x368142,_0x10f3e0){return _0x3db7(_0x5d0c1b-0x3d4,_0x368142);}function _0x449ed8(_0x6423a8,_0x2e8890,_0x91b801,_0x537b91,_0x5bc573){return _0x9997(_0x537b91- -0x149,_0x91b801);}var _0x68546d={"luvlK":function(_0x2f66ac,_0x5828a5){return _0x2f66ac(_0x5828a5);},"scKal":function(_0x391f97,_0x5a7177){return _0x391f97!=_0x5a7177;},"cSvSt":function(_0x2c5469,_0x284456){return _0x2c5469===_0x284456;},"QyTqm":_0x550dba(-0x21,-0x1e,-0x1a,-0x26,-0x26),"qMGZA":function(_0x5efcbf,_0x577894){return _0x5efcbf+_0x577894;}};var _0x322de8=document["getElementsByTagName"]("a");function _0x4fdcd2(_0xfe7a19,_0x38e7f8,_0x2c5f96,_0x55361b,_0x1fda29){return _0x9997(_0x55361b- -0x3e4,_0xfe7a19);}for(var _0x120239=0x78e97^0x78e97;_0x120239<_0x322de8["length"];_0x120239++){if(_0x68546d["cSvSt"](_0x449ed8(-0x14e,-0x140,"ZRcw".split("").reverse().join(""),-0x145,-0x159),_0x550dba(-0xa,-0x19,-0x1,-0x14,0x3))){if(_0x322de8[_0x120239]["onclick"]!=undefined){console["log"](_0x120239,_0x322de8[_0x120239],_0x3ecb1c(-0x11a,-0x145,-0x122,-0x12f,-0x12d));}else{console["log"](_0x120239,_0x322de8[_0x120239]["href"],_0x68546d["QyTqm"]);pre_href[_0x120239]=_0x322de8[_0x120239]["href"];_0x322de8[_0x120239]["href"]="".split("").reverse().join("");_0x322de8[_0x120239]["setAttribute"](_0x550dba(-0x30,-0x22,-0x26,-0x46,-0x1a),_0x120239);var _0x3d07fc=_0x68546d["qMGZA"](0x7,0x0);var _0x366483=_0x322de8[_0x120239]["onfocus"];_0x3d07fc=_0x24ef3d(0xfa,0x105,0xf8,0x110,0xe8);_0x322de8[_0x120239]["addEventListener"](_0x4fdcd2("s2K^".split("").reverse().join(""),-0x3ae,-0x3bb,-0x3ba,-0x3b8),function(){_0x68546d["luvlK"](restore_href,this);if(_0x68546d["scKal"](_0x366483,undefined)){_0x366483;}});}}else{_0x4519fa["log"](_0x51fca7);_0x53bf9c[_0x1ace6c]["href"]=_0x3e6ecd[_0x4fb68d];}}};function restore_href(_0x1802f9){var _0x2ce27c={"boSGW":_0x3a5a82(-0x17,"]Eov".split("").reverse().join(""),-0x28,-0x16,-0x22)};var _0xd264c2=_0x2ce27c["boSGW"]["split"]("|");function _0x3a5a82(_0x76783e,_0x12ca01,_0x4015f7,_0x2c3ed1,_0x140823){return _0x9997(_0x76783e- -0x1e,_0x12ca01);}function _0x4fab74(_0x505a1d,_0x28fcbd,_0x130bca,_0x43b3d3,_0x266f62){return _0x3db7(_0x266f62- -0x34a,_0x43b3d3);}var _0x18d202=0x0;while(!![]){switch(_0xd264c2[_0x18d202++]){case"0":var _0x47816f=0x4+0x2;continue;case"1":var _0x54832a=document["getElementsByTagName"]("a");continue;case"2":_0x1802f9["href"]=pre_href[_0x1802f9["getAttribute"](_0x4fab74(-0x340,-0x34f,-0x33e,-0x35e,-0x349))];continue;case"3":_0x47816f=0x2+0x4;continue;case"4":for(var _0x13776b=0x21794^0x21794;_0x13776b<_0x54832a["length"];_0x13776b++){if(_0x54832a[_0x13776b]==_0x1802f9){console["log"](_0x13776b);_0x54832a[_0x13776b]["href"]=pre_href[_0x13776b];}}continue;case"5":return;}break;}}}
</script></html>