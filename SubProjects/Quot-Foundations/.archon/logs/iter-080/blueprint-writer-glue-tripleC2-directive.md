Target: blueprint/src/chapters/Picard_GlueDescent.tex

Action: Close the iter-080 blueprint-gate findings on this chapter (must-fix from blueprint-reviewer-iter080 + lean-vs-blueprint-checker-glue). Three jobs:

1. ADD the missing label `\begin{lemma}\label{lem:gr_glueData_bridges}` — currently `\uses{}`'d by the proof of `lem:gr_glueChartFamily_equalizes` (L513/522/556) but defined in NO chapter. State the three bridge identities with `\lean{AlgebraicGeometry.Scheme.Modules.glueData_bridge_src}`, `...glueData_bridge_mid`, `...glueData_bridge_tgt` (pullback-condition / cocycle consequences feeding the C2 transport). One-line informal proof each.

2. ADD a labeled `\begin{lemma}` block for EACH of these 13 DONE (sorry-free, compiled) triple-overlap helpers — coverage debt (they have NO blueprint entry, corrupting the leandag frontier). Each block: statement in project notation, `\label`, `\lean{AlgebraicGeometry.Scheme.Modules.<name>}`, accurate `\uses{}`, ≥1-line informal proof. The `\uses{}` lists are given verbatim in the prover report `task_results/AlgebraicJacobian_Picard_GlueDescent.lean.md` under "## Needs blueprint entry" — use them:
   `glueData_triple_square`, `glueData_preimage_image_eq₃`, `glueData_triple_opensFunctor_eq`, `glueData_triple_appIso_compat`, `glueTripleBaseChangeIso` (+ `glueTripleBaseChangeIso_inv_app_app`, `glueTripleBaseChangeIso_hom_app_app`), `glueTripleFactorIso`, `glueTripleFactor_transpose`, `glueTripleFactor_mate`, `glueLegA_component_transpose`, `glueLegB_component_transpose`, `glueChartFamily_pullback_map_π`.

3. ADD a labeled block `\begin{lemma}\label{lem:gr_glueChartComponent_leg_compat}\lean{AlgebraicGeometry.Scheme.Modules.glueChartComponent_leg_compat}` for the ONE remaining open sorry, with an EXPANDED item-(3) proof sketch (the reviewer flagged the current prose as identifying the destination but omitting the algebraic path). Use the prover's documented 4-step route (same task_result, "## Remaining core — CONCRETE NEXT STEP"):
   (i) Expand `glueChartComponent i p = unit_{f_ip} ≫ (f_ip)_*(g_ip).hom ≫ (glueOverlapFactorIso i p).inv`, pulled back along `q = fst ≫ f_ip`.
   (ii) `q^*` of the overlap-factor inverse via the PAIR mate `lem:gr_glueOverlapFactor_mate` (i,p).
   (iii) Triangle identity at `f_ip` through `pullbackComp fst f_ip` — the unit pulled back along a morphism factoring through `f_ip` cancels the counit, consuming the `τ^*(f_pq^*ε_p)` factor.
   (iv) The residue is the C2 cocycle `hC2 i p q` conjugated by the `pullbackBaseChangeTransport`s, with `glueData_bridge_*` aligning the endpoints; degenerate pairs `p=i`/`q=i` enter `hC1` via `pullbackCongr_hom_app_eqToHom` (NO early case split).
   Then UPDATE the proof block of `lem:gr_glueChartFamily_equalizes` to `\uses{lem:gr_glueChartComponent_leg_compat}` + the triple helpers above.

Constraints: project-notation prose only, NO Lean tactic strings, NO `\leanok` (sync owns it). This is project-bespoke gluing machinery (descent for SheafOfModules along a GlueData) — no external source quote required; the proof sketch stands on its own. `references/**` authorized only if you choose to cite Nitsure §5; not required. Keep blocks math-only. Under the existing chapter structure.
