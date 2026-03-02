# TODO: Replace generated PNGs with final artwork. Re-run to regenerate placeholders.
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ICON_SIZE = 1024
CENTER = ICON_SIZE // 2
CIRCLE_DIAMETER = 680
CIRCLE_STROKE = 40
TEXT = "P"
TEXT_SIZE = 380
TEXT_VERTICAL_OFFSET = -20


def load_font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
        "/System/Library/Fonts/Supplemental/Helvetica.ttc",
        "/Library/Fonts/Arial Bold.ttf",
        "DejaVuSans-Bold.ttf",
    ]
    for candidate in candidates:
        try:
            return ImageFont.truetype(candidate, size=size)
        except OSError:
            continue
    return ImageFont.load_default()


def render_icon(background: str, foreground: str, output_path: Path) -> None:
    image = Image.new("RGB", (ICON_SIZE, ICON_SIZE), background)
    draw = ImageDraw.Draw(image)

    radius = CIRCLE_DIAMETER / 2
    circle_bounds = (
        CENTER - radius,
        CENTER - radius,
        CENTER + radius,
        CENTER + radius,
    )
    draw.ellipse(circle_bounds, outline=foreground, width=CIRCLE_STROKE)

    font = load_font(TEXT_SIZE)
    text_bbox = draw.textbbox((0, 0), TEXT, font=font)
    text_width = text_bbox[2] - text_bbox[0]
    text_height = text_bbox[3] - text_bbox[1]
    text_x = (ICON_SIZE - text_width) / 2
    text_y = (ICON_SIZE - text_height) / 2 + TEXT_VERTICAL_OFFSET
    draw.text((text_x, text_y), TEXT, font=font, fill=foreground)

    image.save(output_path, format="PNG")


def main() -> None:
    output_dir = (
        Path(__file__).resolve().parent.parent
        / "portent"
        / "Assets.xcassets"
        / "AppIcon.appiconset"
    )
    output_dir.mkdir(parents=True, exist_ok=True)

    render_icon("#1C1B4B", "#FFFFFF", output_dir / "AppIcon-Light.png")
    render_icon("#0A0918", "#F0EFFF", output_dir / "AppIcon-Dark.png")
    render_icon("#000000", "#FFFFFF", output_dir / "AppIcon-Tinted.png")

    print("Generated: AppIcon-Light.png, AppIcon-Dark.png, AppIcon-Tinted.png")


if __name__ == "__main__":
    main()
