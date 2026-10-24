"""Hide the linked Codex split and give its Neovim editor the full tab."""

from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    codex = boss.window_id_map.get(target_window_id)
    if codex is None:
        return
    try:
        editor_id = int(codex.user_vars.get("NVIM_CODEX_EDITOR", ""))
    except ValueError:
        return
    editor = boss.window_id_map.get(editor_id)
    if editor is None or "IS_NVIM" not in editor.user_vars:
        return
    tab = editor.tabref()
    if tab is None or tab is not codex.tabref():
        return
    boss.set_active_window(editor)
    # Avoid replacing Kitty's saved split layout when already maximized.
    if tab.current_layout.name != "stack":
        tab.goto_layout("stack")
