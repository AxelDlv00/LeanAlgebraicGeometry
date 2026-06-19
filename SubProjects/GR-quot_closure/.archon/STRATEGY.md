# Strategy

## Goal

Close the `sorry`-bearing nodes of the **Grassmannian-quotient representability** cone (the
Čech-independent / H⁰ leg of the parent's `thm:fga_pic_representability` cone; Nitsure §1/§5,
FGA Explained Ch. 5), then merge back into *Quot-Foundations*:

- **GR-quot core** — `def:grassmannian_scheme`, `thm:grassmannian_representable`,
  `lem:tautologicalQuotient_epi`: the rank-`d` Grassmannian as a scheme glued from affine
  charts via the `GL_d` cocycle, representing the rank-`d`-quotient functor. χ-free (the
  Hilbert condition is constant rank `d`).
- **SNAP-S0** — `def:sectionsCast`, `lem:sectionsCast_refl`, `lem:gradedMonoid_eq_of_cast`,
  `lem:sectionMul_coherent` (+ graded assembly): the H⁰ section graded ring `Γ_*(X,L)`,
  Čech-independent. **Shared with the sibling `FBC-B_SNAP-chain`** — keep as sorry here or
  import the sibling's proofs (user hint).
- **χ-blocked** — `def:quot_functor`, `def:hilbert_polynomial`: in-cone via the blueprint
  `\uses` wiring, but χ-semantic (need higher cohomology this leg lacks). Sourced from the
  cohomology leg at merge; kept as `sorry` here.

End-state: zero project `sorry` in the closable part of the 287-node cone, zero project axioms,
kernel-only axioms. Names/labels/paths are the parent's so finished work merges back cleanly.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| GR-quot / repr — tautological quotient + representability | ACTIVE | 2–5 | ~300–700 | effective descent for `SheafOfModules`; `Functor.RepresentableBy` | Residue = `tautologicalQuotient_epi` (last GR sorry); `represents` DONE |
| SNAP-S0 — section graded ring | ACTIVE‖ / shared | 2–4 | ~150–350 | `Module.Invertible.tensorProductComm_eq_refl`; `DirectSum.G(Comm)Semiring` | General ring = NON-comm `GSemiring` (assoc+units, ∀L); comm is the invertible-only upgrade (`IsInvertible`). Residue: assoc 4-lemma chain (`tensorObjAssoc_eta_factor` hard) + invertibility-gated comm. SHARED with sibling |
| χ-blocked nodes | DEFERRED | — | — | higher-cohomology engine (absent here) | `hilbert_polynomial`/`quot_functor` filled from cohomology leg at merge |

## Completed (inherited from the parent, in kept files)

| Phase | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|
| GR-cells/glue/sep/proper | ~1310 | `GrassmannianCells.lean`, `GlueDescent.lean` | charts, cocycle, `Grassmannian.scheme`, `isSeparated`, `isProper`, keystone `isIso_glueRestrictionHom` (0-sorry) | `IsLocalization.Away.lift`; `ValuativeCriterion`; cocycle telescopes via rotMid; effective descent NOT stalks | `Matrix.det_updateColumn` absent; `Spec.map_comp` rw fails on Scheme-cat diamond |
| GR-quot inverse + represents | ~? | `GrassmannianQuot.lean` | `grPointOfRankQuotient` (Nitsure §5 inverse), `represents` (DONE) | equivalence-transport; joint reflection across chart cover | value-ModuleCat diamond: never positional rw |
| SNAP-S2 Hilbert–Serre engine | ~1470 | `QuotScheme.lean`, `GradedHilbertSerre.lean` | `IsRatHilb.ofDiffEq`; `gradedModule_hilbertSeries_rational` (00K1) | Route-2 ambient-subquotient pairs sidestep quotient gradings | bundled `IsInternal` over quotient carrier = hard `isDefEq` dead end |
| QUOT P1+gap1+gap2 | ~990 | `QuotScheme.lean` | schematic/proper support; `isIso_fromTildeΓ`; `isLocalizedModule_basicOpen` | equivalence-transport beats `IsContinuous`; open-imm pullback-unit IS Final | general-U `_of_cover` unprovable (basic-open only) |
| SNAP-S0 tensor crux + chain | ~? | `SectionGradedRing.lean` | `isIso_sheafification_whiskerRight_unit`; `tensorObjAssoc`; `tensorPowAdd` (axiom-clean) | `W.whiskerRight`@`ModuleCat (ULift ℤ)` + coequalizer descent (NOT stalks) | instance synth flaky in long `≪≫` — pass `@asIso _ _ _ _ f h` |

## Routes

**GR-quot route.** Glue `SheafOfModules` over `Scheme.GlueData` → effective-descent iso
`isIso_glueRestrictionHom` (DONE keystone) → Nitsure §5 inverse `grPointOfRankQuotient` (DONE) →
`represents` (DONE) → residue `tautologicalQuotient_epi` (last sorry, unblocked). Faithful Lean
image of Nitsure §5 cell-gluing + `GL_d` cocycle; inverse/representability is Archon-original
(Nitsure leaves it as §5 exercise).

**SNAP-S0 route.** Crux `IsIso(sheafification.map(η_P ▷ Q))`, associator, `tensorPowAdd`,
right-unit (`sectionsMul_mul_one`) all CLOSED axiom-clean. **iter-011 RE-ANCHOR (decisive):** the
section ring `⊕ₘΓ(L^{⊗m})` is the FREE TENSOR ALGEBRA on Γ(L) — `sectionsMul_mul_comm` is FALSE for
general `L` (triple-verified; counterexample `L=𝒪²`). Per Stacks §17.25, `Γ_*` is defined for
INVERTIBLE sheaves; commutativity holds iff `L` invertible (`β_{L,L}=𝟙`). So the general deliverable
is a NON-commutative `DirectSum.GSemiring` (assoc + units only); `GCommSemiring` is the upgrade under a
project-local `IsInvertible L` (locally-free-rank-1, Stacks 01CR), its proof gated on
`braiding_eq_id_of_invertible` (Mathlib `Module.Invertible.tensorProductComm_eq_refl`, local-to-global).
Remaining closable work: the assoc 4-lemma chain (`sectionsMul_whiskerRight/Left_unit`,
`presheafAssociator_top_apply`, `tensorObjAssoc_eta_factor`) → `tensorObjAssoc_hom_sectionsMul` →
`tensorPowAdd_assoc` (canonical pentagon) → `sectionsMul_mul_assoc`. comm proof is invertibility-gated
future work (no consumer yet — `GCommSemiring` assembly unbuilt). Full `MonoidalCategory(SheafOfModules)`
NOT needed; stalkwise routes DEAD. **Shared with sibling — prefer importing finished proofs.**

**χ-blocked route — none here.** `quot_functor`/`hilbert_polynomial` need the χ
(Euler-characteristic) engine; this i=0 leg does not build it. They remain `sorry` and are
filled from the cohomology leg at merge.

## Open strategic questions

- **SNAP coordination with `FBC-B_SNAP-chain`.** Decide per-iteration whether to prove SNAP here
  or import the sibling's finished proofs (Lean names identical). See manifest `overlaps` and
  `.archon/USER_HINTS.md`.
- **χ encoding consistency.** The blueprint `def:hilbert_polynomial` ENCODING comment claims an
  H⁰ encoding that contradicts the χ Lean decl. The Lean source governs; flag for the parent to
  reconcile the comment, but do NOT change the Lean to H⁰ in this leg.
- **`Grassmannian.representable` statement strength.** The `\lean{}` pin currently under-delivers
  the prose (omits smoothness/properness/rel-dim/tautological-quotient/Plücker); strengthen or
  split the label before claiming the full theorem.

## Mathlib gaps & new material

- GR-quot: effective descent for `SheafOfModules` over `Scheme.GlueData` (project-built).
- SNAP-S0: H⁰ section graded ring `Γ_*(X,L)` (project-built, `TensorPower.Basic` idiom: free tensor
  algebra ⇒ general `GSemiring`, `GCommSemiring` under invertibility).
- SNAP-S0: `IsInvertible (L : X.Modules)` (locally-free-rank-1, Stacks 01CR) + `β_{L,L}=𝟙` for
  invertible `L` (`braiding_eq_id_of_invertible`, via `Module.Invertible.tensorProductComm_eq_refl`).
- `Grassmannian` (rank-`d` locally-free quotients) + representability as `IsRepresentable`.
