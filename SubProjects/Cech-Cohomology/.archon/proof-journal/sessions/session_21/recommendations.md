# Recommendations for iter-022 (plan agent)

## CRITICAL — the FreePresheafComplex lane never ran; fix the noop-keyword placement and re-dispatch

`planValidate` NOOP-dropped `FreePresheafComplex.lean` this iter (`meta.json:
objectivesNoop`). The file has 0 open sorries, so the noop filter requires a scaffold keyword
(`scaffold` / `does not yet exist` / `declarations for` / `add the import`) on the **SAME PHYSICAL
LINE** that bears the `.lean` path. In iter-021's PROGRESS.md the path was on line 45 with no
keyword; the keyword was on line 46 → dropped. **This is the iter-017 noop trap recurring.**

Action for iter-022:
- Put the scaffold keyword **on the same line as the `.lean` path** for any zero-sorry lane, e.g.
  `1. **\`…/FreePresheafComplex.lean\`** — declarations that **do not yet exist** (scaffold them): …`.
  Do NOT split the path and the keyword across two lines.
- The intended corrective is **unchanged and still correct**: build `cechFreeEvalEngineIso` (the
  evaluated-differential ↔ `FreeCechEngine.combDifferential` match on coproduct injections) FIRST,
  then the nonempty homotopy + glue. The blueprint nodes (`lem:cech_free_eval_engine_iso` etc.) are
  already in place from iter-021's writer round.
- Route 2 has now had **zero new prover work for an extra iter** through no fault of the math. Do
  NOT count this as a 4th CHURNING round against the math — it is an administrative loss. But if the
  re-dispatched lane returns setup-only AGAIN, the iter-021 escalation plan (mathlib-analogist on
  `HomologicalComplex.Homotopy` packaging) stands.

## HIGH — CechAcyclic step (d) is blocked on the tilde F-bridge (genuinely new infra)

`sectionCech_affine_vanishing` cannot close until the **tilde F-bridge** exists: a per-coordinate
`AddEquiv φ_σ : ToType(F.presheaf.obj (op (⨅ₖ U(σ k)))) ≃+ SectionCechModule.dCoeff s M σ`
intertwining `sectionCechFaceRestr` with `dCoface`. The obstruction is reconciling **three distinct
presheaf accessors** (the `toPresheafOfModules` underlying-Ab presheaf vs `modulesSpecToSheaf` /
`tilde.toOpen` ModuleCat sections). The full ladder-assembly recipe (items A/B/C) is in
`task_results/CechAcyclic.md`.

- This is the ONE deep remaining ingredient; the abstract homological half (c1–c3) is DONE.
- Recommend a **mathlib-analogist (api-alignment)** consult on the right way to bridge
  `toPresheafOfModules`-sections to `tilde`/`modulesSpecToSheaf` sections BEFORE dispatching a
  prover at the bridge — the accessor reconciliation is exactly the kind of API-shape question that
  agent answers, and getting it wrong would churn the lane.
- Once the bridge exists, step (d) is mechanical: `Function.Exact.of_ladder_addEquiv_of_exact` +
  `sectionCech_isZero_homology_of_objD_exact` (built this iter) + `SectionCechModule.dDiff_exact`
  (built iter-019).

## MEDIUM — blueprint coverage debt: 5 new unmatched `lean_aux` nodes

`archon dag-query unmatched` returns exactly the 5 decls added this iter (all proved, no sorry, no
blueprint entry). The planner should add `\lean{}` references for them next iter (the doctrine:
when there is Lean there must be tex). Suggested bundling into existing
`chapters/Cohomology_CechHigherDirectImage.tex` blocks:
- `AlgebraicGeometry.sectionCechProductEquiv_apply` → `lem:section_cech_product_equiv` (helper of it).
- `AlgebraicGeometry.sectionCechFaceRestr` → `lem:section_cech_coface_match` (the face-restriction def).
- `AlgebraicGeometry.sectionCech_objD_apply` → `lem:section_cech_coface_match` (the abstract coface match).
- `AlgebraicGeometry.sectionCech_isZero_homology_of_objD_exact` → `lem:section_cech_ab_exact`.
- `AlgebraicGeometry.ab_hom_finsetSum_apply` (private) → bundle into whichever block consumes it
  (`lem:section_cech_coface_match`), or leave un-blueprinted as a trivial private helper.

## MEDIUM — split the `lem:section_cech_coface_match` chapter block (lvb finding)

The lvb checker flags that `lem:section_cech_coface_match` does not distinguish the **abstract
cosimplicial-unfold** step (`sectionCech_objD_apply`, DONE) from the **tilde-bridge** step (the
`faceRestr ↔ dCoface` identification, still open). A blueprint-writer pass should decompose the
block so the next prover sees the abstract half is closed and only the bridge remains. Report:
`task_results/lean-vs-blueprint-checker-cechacyclic.md`.

## LOW — overstated `SectionCechBridge` module doc (lean-auditor major; cosmetic)

`CechAcyclic.lean:~1200–1209` the module doc claims the section moves the complex to `dDiff` "and
reads off homology vanishing," but the `faceRestr ↔ dCoface` identification is absent and decl 5 is
*conditional*, not unconditional vanishing. Not blocking; fix with a one-line comment correction
(refactor agent or the next prover touching the file). Also minor: drop the unnecessary `classical`
in `ab_hom_finsetSum_apply`; consider `omega`/`norm_num` over `(by simp)` for the decl-5 side
conditions. Report: `task_results/lean-auditor-iter021.md`.

## Do NOT retry without a structural change
- Nothing on CechAcyclic is at risk of a known-blocker re-run; step (d) is a genuine new-infra gap,
  not a re-attempt of a failed approach. The patterns above (named term-mode `productEquiv` apply
  lemma; named-def factoring to dodge heartbeat blow-up) are reusable, not dead ends.
