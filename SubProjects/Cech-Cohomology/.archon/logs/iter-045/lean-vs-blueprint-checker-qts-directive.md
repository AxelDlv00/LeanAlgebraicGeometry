# Lean ↔ blueprint check — QcohTildeSections.lean (iter-045)

Verify bidirectionally:

- Lean file: `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint chapter: `/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

Context for this file: the chapter blueprints the Stacks 01I8 keystone "section-localization"
route. The relevant blocks are `lem:tile_image_opens_identities`, `lem:modulesRestrictBasicOpen_smul_eq`,
`lem:tile_section_ring_identity`, `lem:tile_scalar_compat`, `lem:tile_section_comparison`,
`lem:tile_section_localization`.

This iter the prover added 5 new Lean declarations that have NO blueprint blocks yet:
`modulesRestrictBasicOpen_smul_eq'`, `appIso_inv_res` (private), `appIso_inv_res_assoc`
(private), `tile_section_ring_identity'`, `tile_scalar_compat'` (these are general-open `V`
companions of the existing `V=⊤` blocks, plus two `Scheme.Hom.appIso_inv_naturality` wrappers).

Check and report:
1. Lean → blueprint: are the 5 new decls faithful to the math the chapter describes? Do they
   over-claim or are they placeholder/fake statements?
2. blueprint → Lean: `lem:tile_section_localization` carries `\lean{AlgebraicGeometry.tile_section_localization}`
   but that Lean declaration does NOT exist (the prover left it absent with an in-file comment
   block — it is BLOCKED on Lean-engineering walls). Flag this `\lean{}` pin pointing at a
   non-existent declaration.
3. Is the chapter's Step-4 sketch for `lem:tile_section_localization` adequate to guide a
   follow-up assembly, or does it under/over-specify the residual obstruction (the W1–W3
   instance-plumbing walls the prover hit)?
4. Does `lem:tile_scalar_compat`'s Step-4 caveat (line ~4791, "covers V=⊤ only") need a note
   that the V=D(f̄) case is now formalized as `tile_scalar_compat'`?

Report any must-fix-this-iter findings, Lean-side red flags, and blueprint-side inadequacies.
