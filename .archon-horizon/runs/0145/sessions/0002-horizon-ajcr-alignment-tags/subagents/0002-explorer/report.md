No existing structured tag system was found; only prose precedents such as `**Provenance.**` and `Source:`.

Recommended minimal plumbing:

- Add `\provenancetag{REFERENCE|ADAPTED|CUSTOM}` and `\alignmentcheck{TO CHECK: ...}` one-argument macros to `blueprint/src/macros/common.tex`.
- Use `/-- **REFERENCE.** ... -/` and optional `**TO CHECK.** ...` in public Lean docstrings.
- Mirror classifications into hgraph’s existing generic metadata:
  ```bash
  "$HORIZON_BIN" graph -p Algebraic-Jacobian-Challenge-Rebuild \
    modify node label:<label> --set 'tags=["ADAPTED", "TO CHECK"]'
  ```
- Query with:
  ```bash
  "$HORIZON_BIN" graph -p Algebraic-Jacobian-Challenge-Rebuild list --tag 'TO CHECK' --json
  ```
- Validate explicitly because this project lacks `hgraph/config.yaml`:
  ```bash
  "$HORIZON_BIN" graph -p Algebraic-Jacobian-Challenge-Rebuild \
    sync --blueprint blueprint/src/content.tex --lean AlgebraicJacobian -v
  (cd blueprint/src && latexmk -output-directory=../print)
  (cd blueprint/src && plastex -c plastex.cfg web.tex)
  ```

Hgraph sync preserves authored `tags`. The dashboard JSON exports them, but the current React UI does not render them. TeX `% SOURCE:` comments and `\source{...}` are unsuitable as visible classifications.

Full file references and implementation details were sent to `/root`.
