# Blueprint Reviewer Directive

## Slug
iter109

## Iter
109 (Archon canonical)

## Strategy snapshot (one paragraph)

This iteration the project fires the **C1 promotion** of `Picard/LineBundle.lean`: refactor the body of `LineBundle X` from the current `CommRing.Pic Γ(X, ⊤)` global-sections approximation to the canonical sheaf-theoretic idiom `(Shrink (Skeleton X.Modules))ˣ`, mirroring Mathlib's `CommRing.Pic R := Shrink (Skeleton (SemimoduleCat R))ˣ`. The refactor commits to the analogist's "default option (c)" for `Pic.pullback`: introduce a new named-deferred sorry `SheafOfModules.pullback_tensorObj` (the iso `(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N` is absent from Mathlib b80f227). Post-C1, `instIsMonoidal_W` (`Modules/Monoidal.lean` L173, currently dormant) becomes **load-bearing** for the entire Pic-and-down arc (LineBundle, Pic, Pic.pullback, PicardFunctor, PicardFunctorAb, Jacobian instances, AbelJacobi).

## What I need from you

Audit the **entire** blueprint (every chapter in `blueprint/src/chapters/*.tex`). Per the dispatcher notes, I do not pass you a scope-limiting directive — the cross-chapter view is the point.

Pay extra attention this iter to:

- **`Picard_LineBundle.tex`**: does the chapter accurately describe the *current* (pre-C1) state and the *post-refactor* target? The existing "Status note (Phase C1)" prose at L17-27 cites `MonoidalCategory.Invertible (X.Modules)` as the target, which is **wrong per analogist**: the canonical idiom is `(Shrink (Skeleton X.Modules))ˣ` via `CategoryTheory.Skeleton.instCommMonoid [BraidedCategory C]`. After the iter-109 C1 refactor lands, this chapter needs an update; flag it as must-fix-this-iter if you agree.

- **`Modules_Monoidal.tex`**: does the chapter disclose the post-C1 load-bearing transition of `instIsMonoidal_W`? Per the iter-108 mathlib-analogist `c1-route` finding, post-C1 every Lean term referencing `LineBundle X`, `Pic X`, `Pic.pullback`, or `PicardFunctor` will transitively depend on this sorry. The honest-disclosure paragraph mirrors the `JacobianWitness` one. Flag if missing.

- **`Picard_Functor.tex` + `Picard_FunctorAb.tex`**: are downstream chapters consistent with the C1 refactor's new shape? If `Pic.pullback` is going to depend on `SheafOfModules.pullback_tensorObj` (a new named deferred sorry), the relative-Picard chapter's prose should acknowledge this.

- **`Cohomology_MayerVietoris.tex`**: the iter-108 `blueprint-writer mv-step2` dispatch expanded Step 2 of `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` with the four Mathlib API pieces + a labelled "Implementation status (iter-108)" sub-block + the missing § "Use in the project" status acknowledgement. Verify those land correctly and are internally consistent. The lean-vs-blueprint-checker-iter108 flagged 2 minor cosmetic items: (1) substep-numbering inconsistency in `rem:basicOpenCover_step2_status` at L1196 (the (i)/(ii)/(iii) ordering does not match the recipe's at L1167-1176), (2) blueprint remark omits `IsLocalizedModule.prodMap` cited by Lean DEFERRED comment. Confirm whether these are still live and, if so, flag for blueprint-writer attention.

- **Cross-chapter consistency**: the iter-108 expansion to the end-state framing in STRATEGY.md disclosed 5 named Mathlib-gap sorries + 1 budget-deferral. Verify the blueprint chapters' "Mathlib gap" and "Status note" prose reflect this 5+1 framing rather than the older 3 framing.

- **Carry-over from iter-108**: the lean-auditor-iter108 flagged 4 must-fix carry-over items (LineBundle wrong-def excuse-prose; Functor.representable excuse-prose; instIsMonoidal_W excuse-prose; Differentials.lean:27 stale status header) and 2 new major items (BasicOpenCech.lean:17 stale sorry-count file header; BasicOpenCech.lean:1846 DEFERRED annotation cites invented declaration names). These are Lean-side issues but you may cross-check whether the relevant chapter prose reinforces or contradicts them.

## Output

Per `.archon/subagents/blueprint-reviewer.md` body. Render the per-chapter checklist (`complete: true|partial|false` × `correct: true|partial|false`) and must-fix-this-iter list. Highlight chapters needing a blueprint-writer this iter.

Do NOT read PROGRESS.md, task_pending.md, task_done.md, iter sidecars, or recent task_results. Read only the blueprint chapters and the references named.
