Target: blueprint/src/chapters/Picard_GrassmannianQuot.tex
Action: Two jobs — (A) align the chapter with the equalizer-route `glue` that actually landed iter-056, and (B) decompose the GL_d bundle transition cocycle so a prover can attack `universalQuotient`/`tautologicalQuotient`/`represents` next iter.

(A) Cleanup (per iter-058 review GR Phantom Triage):
- REMOVE the 3 phantom blocks `def:gr_modules_gluePresheaf`, `def:gr_modules_gluePresheafModule`, `lem:gr_modules_gluePresheaf_isSheaf` (their `\lean{}` pins name decls that do not and will not exist — abandoned presheaf route). Replace with a one-line historical `%`-comment, no `\lean{}` pin.
- REWRITE the `def:scheme_modules_glue` Construction paragraph to the equalizer-of-pushforwards route: glued sheaf = `equalizer a b` of the two maps `∏ᵢ (ιᵢ)_* Mᵢ ⇉ ∏_{ij} (j_ij)_* (f_ij^* Mᵢ)` in `Scheme.Modules` (leg a via `pullbackPushforwardAdjunction` unit + `pushforwardComp`; leg b additionally transports across `(g i j).inv` and the glue condition). Note `_hC1`/`_hC2` are NOT consumed by the object but pin down `glueRestrictionIso` downstream.
- UPDATE the 3 forward-spec blocks `def:gr_modules_glueRestrictionIso`, `lem:gr_modules_glue_unique`, `def:gr_modules_glueHom`: rewrite proof sketches to reference the equalizer `def:scheme_modules_glue` (remove `\uses{def:gr_modules_gluePresheaf}`); keep `\lean{}` pins as forward declarations with a `% NOTE:` (planned work).
- WIRE `\uses{lem:gr_homEquiv_conjugateEquiv_app}` into the `lem:gr_pullbackObjUnitToUnit_comp` proof block.

(B) New section "GL_d bundle transition cocycle" — decompose into a `\uses`-linked chain, each with statement + one-line informal proof:
- `def:gr_bundleTransition` (`g I J`) — the matrix automorphism of `free (Fin d)` induced by the inverse minor `universalMinorInv I J = (X^I_J)⁻¹` over the overlap ring, built like `chartQuotientMap` (scalarEnd of entries, assembled over the rank-d biproduct, conjugated by `pullbackFreeIso`).
- `lem:gr_bundleCocycle_id` (hC1, self-identity) and `lem:gr_bundleCocycle_mul` (hC2, triple-overlap multiplicativity) — the module-level cocycle, related to the matrix cocycle identities of `universalMinorInv` already in GrassmannianCells, transported via `pullbackBaseChangeTransport`/`glueData_bridge_*`. Mark hC2 as the hard step.
- `def:gr_universal_quotient_sheaf` (`universalQuotient`): apply `def:scheme_modules_glue` to the charts `free (Fin d)` with transition data `g I J` and cocycle hyps hC1/hC2.
- `def:tautological_quotient`: glue the `chartQuotientMap u^I` via `glueHom`.
- `thm:grassmannian_universal_property` (`represents`): Nitsure §1 local-to-global inverse.
Add `\uses{}` edges so these form a chain ending at `represents`.

Constraints: edit ONLY this chapter. No `\leanok`. SOURCE quote for the Nitsure §1 construction if you cite it (read references/nitsure-hilbert-quot.* first); the cocycle decomposition is Archon-original (no quote needed). `references/**` is authorized if you need the Nitsure source.
