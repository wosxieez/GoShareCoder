package {

    import com.goshare.Sb2Player;

    import flash.display.Sprite;
    import flash.utils.setTimeout;

    public class Main extends Sprite {
    public function Main() {
        var sb2Player = new Sb2Player()
        sb2Player.width = 100
        sb2Player.height = 100
        addChild(sb2Player)

        setTimeout(function (): void { sb2Player.selectFile() }, 2000)
    }
}
}
