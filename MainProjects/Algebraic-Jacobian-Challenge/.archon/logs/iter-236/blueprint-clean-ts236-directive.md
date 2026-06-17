# blueprint-clean — iter-236 post-writer gate

Two chapters were edited by blueprint-writers this iter. Clean BOTH:

1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — writer `d2-balancing` expanded
   the stage-(iv) balancing prose in the proof of `lem:stalk_tensor_commutation` (stalk-level
   balancing, section-level carrier-duality warning, stage-(iii) bridge cross-reference).
2. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — writer `fbc-brick` filled the
   `lem:pushforward_spec_tilde_iso` block with a `\lean{}` hint, a `\begin{proof}` sketch
   (project-bespoke Mathlib-gradient lemma; no external source), and a corollary remark.

Standard clean pass: strip any Lean tactic leakage / project-history / iteration-workflow
verbosity from the newly-written prose; verify SOURCE QUOTE integrity on any block that
carries one (the d.2 Stacks lemma-stalk-tensor-product quote must remain byte-intact; the
FBC brick is project-bespoke and correctly carries no external SOURCE line). Do NOT add or
remove `\leanok`/`\mathlibok` markers. The FBC brick `lem:pushforward_spec_tilde_iso` is a
NEW project-bespoke result — confirm it is correctly uncited and unmarked (no `\leanok`).
