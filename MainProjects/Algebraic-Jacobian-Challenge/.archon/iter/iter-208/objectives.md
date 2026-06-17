# Iter-208 objectives — per-lane detail + reference anchors

## Lane TS — `Picard/TensorObjSubstrate.lean` (A.1.c.SubT) — `[prover-mode: prove]`

**Target (ordered):**

1. Build the bounded sectionwise-unfolding helper for `PresheafOfModules.pullback φ`
   along the open immersion `f` (the structure-sheaf morphism `φ`): on each open
   `V`, `(pullback φ.hom).obj P` ≅ base change of `P`'s sections along the ring
   iso `f.appIso`. (~30–60 LOC; precedent `analogies/kaehler-tensorequiv-presheafpullback.md`
   Decision 5.)
2. Close `tensorObj_restrict_iso` (L330/367): keep Steps 1–2
   (`restrictFunctorIsoPullback`, `sheafificationCompPullback`); discharge the
   presheaf residual with `PresheafOfModules.isoMk` +
   `ModuleCat.restrictScalarsEquivalenceOfRingEquiv` (sections agree by
   `restrict_obj` `rfl`, scalar rings identified by `f.appIso`); iso-check via
   `Scheme.Modules.Hom.isIso_iff_isIso_app` if a morphism-then-iso shape is used.
3. Cascade: `tensorObj_assoc_iso`, `tensorObj_unit_iso`, `tensorObj_comm_iso`
   (existence-of-iso on a common trivialising cover), `exists_tensorObj_inverse`
   (L406), `addCommGroup_via_tensorObj` (L446).

**Decl inventory (analogist tsroute208, present at `b80f227`):**
`Scheme.Modules.restrict_obj`/`restrict_map` (rfl, Sheaf.lean:328/331),
`Scheme.Hom.appIso` (OpenImmersion.lean:190),
`ModuleCat.restrictScalarsEquivalenceOfRingEquiv` (ChangeOfRings.lean:285),
`Scheme.Modules.Hom.isIso_iff_isIso_app` (Sheaf.lean:132),
`PresheafOfModules.isoMk` (Presheaf.lean:118),
`Scheme.Modules.restrictFunctorIsoPullback` (Sheaf.lean:371),
`SheafOfModules.sheafificationCompPullback` (PullbackContinuous.lean:117).
**Absent (the single bounded gap):** sectionwise unfolding of
`PresheafOfModules.pullback` along an open immersion (no presheaf analogue of
`restrictFunctorIsoPullback`).

**Dead-ends (do NOT retry):** the abstract-adjoint mate-δ /
`leftAdjointOplaxMonoidal` route (4 iters dead, reduces to absent
`(pullback φ).Monoidal`); adding `IsLocallyTrivial M N` hypotheses (analogist:
over-constrains; gluing local SheafOfModules isos has no Mathlib primitive and is
heavier than Route A).

**Reference anchors:** Route A is substrate plumbing (tensor commutes with open
restriction), Archon-bespoke from Mathlib primitives — no external math source.
The surrounding group-law strategy: Kleiman "Picard scheme" §4–§5;
`CommRing.Pic = Units (Skeleton …)` idiom.

**HARD BAR:** close `tensorObj_restrict_iso` axiom-clean. If the helper is
genuinely unbuildable sectionwise, hand off a precise decomposition (this is the
pre-committed reversal signal → TS pauses, option c).

## Excision (no prover) — Route-1 Albanese cone

`Albanese/{CodimOneExtension, Thm32RationalMapExtension, AuslanderBuchsbaum,
CoheightBridge}.lean` — dead substrate per strategy-auditor albroute208.
**Reference anchors:** Kleiman `rmk:Alb` (arXiv:math/0504020 lines 3960–3988),
`rmk:Jac` autoduality (lines 3990–4016, citing EGK Thm 2.1); Milne "Abelian
Varieties" Thm 3.1 (p.16 — codim-≥2 via normality+valuative criterion,
Hartshorne II.4.7), Thm 6.6 + Lemmas 6.7–6.9 (pp.105–107 — autoduality via theta
divisor, RR-free). Physical file removal deferred to a refactor pass.
