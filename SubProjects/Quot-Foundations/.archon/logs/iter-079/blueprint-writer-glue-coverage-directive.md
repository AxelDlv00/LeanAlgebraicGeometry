# blueprint-writer — glue-coverage

Target: `blueprint/src/chapters/Picard_GlueDescent.tex`

Action: Author 1-to-1 blueprint blocks for the new GlueDescent declarations listed under
"## Needs blueprint entry" in `.archon/task_results/AlgebraicJacobian_Picard_GlueDescent.lean.md`
(read it for exact Lean names + the `Uses:` lists). For each decl: a `\begin{lemma}`/`\begin{definition}`
block with `\label`, `\lean{<exact namespaced name>}`, an accurate `\uses{}` reflecting what the Lean
proof needs, and a ≥1-line informal proof. Group the helpers as sublemmas of `thm:isIso_glueRestrictionHom`.

Two are SORRIED open sub-lemmas of the keystone — give each a full proof sketch from the task result:
- `glueOverlapFactor_transpose` — m-free, cocycle-free site-level mate core: transpose along `ι_i` of
  `glueOverlapFactorIso.hom` equals the four-functor comparison
  `(ι_j)_*(unit) ≫ pushforwardComp ≫ pushforwardCongr ≫ pushforwardComp⁻¹`.
- `glueChartFamily_equalizes` — the (C2)-transported equalizing condition: componentwise via
  `piComparison`, transposed along the triple-overlap immersion (triple-overlap opens identity + a
  triple β by the 4-factor `appIso_compat` recipe; the transposed component is `hC2 i p q`).

Also: re-point `lem:gr_modules_glue_unique` to `pullback_map_jointly_faithful` (joint faithfulness of
chart restrictions), or add a dedicated block + repoint `\uses`. If a `glueRestrictionIso` Lean decl
exists, pin `def:gr_modules_glueRestrictionIso`'s `\lean{}`.

Constraints: math-only prose, NO Lean tactic strings; NO `\leanok` (sync owns it). These are
Archon-original (no external source) — omit SOURCE/SOURCE QUOTE lines. Do not edit any other chapter.
