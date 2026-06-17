# Blueprint Reviewer Directive

## Slug
iter024

## Strategy snapshot

**Goal.** Close the `sorry`-bearing nodes of the Čech-independent leg of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA §4): FBC (flat base change of `f_*` at i=0),
GF (generic flatness), QUOT (Hilbert polynomial / Quot functor / Grassmannian
representability). Zero project sorry in the closure, zero project axioms, kernel-only axioms.
Names/labels match the parent for merge-back.

**## Phases & estimations**

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 2–4 | ~80–200 | tilde dictionaries; `conjugateEquiv_counit_symm`, `Adjunction.comp_counit_app` | gstar 5-lemma chain: Seam C DONE axiom-clean, Seam A/B partial; `inner_eCancel` now re-broken one-cancellation-per-lemma (2nd effort-breaker) |
| FBC-B — globalization, H⁰-equalizer | NEXT | 2–5 | ~120–300 | `Mathlib.RingTheory.Flat.Equalizer`; finite affine cover + sheaf condition for `SheafOfModules` | flat-equalizer half Mathlib-backed; residual = H⁰-as-equalizer packaging |
| GF-geo — `genericFlatness` | ACTIVE | 2–4 | ~120–300 | algebraic core (done); `Module.flat_of_isLocalized_maximal`; `LocallyOfFiniteType.finiteType_appLE`; G1/G3 project-built | G1 (qcoh+finite-type ⟹ Γ(F,W) finite) blocks the witness; G3 flat-locality assembly. G1 depends on the qcoh affine-local identification `F|_W ≅ Ñ` which is NOT yet a Lean decl |
| QUOT-defs — Quot/Grassmannian defs + predicates | ACTIVE | 4–7 | ~220–560 | `Functor.IsRepresentable`; `Scheme.Modules.pullback`; QCoh→tilde sub-build | P2 rank-`r` local-freeness next |
| SNAP-S1/S3 — section-module input + `Φ_s` extraction | NEXT | 3–6 | ~150–400 | `SheafOfModules` tensor powers; `existsUnique_hilbertPoly` | GATED: f.g. input may carry irreducible Serre `m≫0` content |
| QUOT-repr — `thm:grassmannian_representable` | BLOCKED | 6–12 | ~400–1000+ | Grassmannian-of-quotients as a scheme; RelativeSpec → `RepresentableBy` | deepest target; GR-cells DONE |

## Routes
Single route per target (a fan of independent leaves merging upstream). FBC-A and GF-geo are
the live frontier; QUOT files import only Mathlib and are authorable in parallel.
- **FBC**: affine lemma directly on global sections (Stacks 02KH(2)); section identity is a
  domain_read / codomain_read / gstar_transpose triangle; gstar_transpose is a 5-lemma chain
  (Seam A inner value `Γ_R(θ_in)=ρ` via `inner_unitReduce → inner_eCancel → inner_value_eq`;
  Seam B generator close; Seam C counit transport — DONE). `inner_eCancel` is now split into
  three one-cancellation atoms.
- **GF**: algebraic core DONE; geometric `genericFlatness` wraps it via finite affine cover +
  G1 (finite section module) + G3 (flat-locality).
- **QUOT**: graded-Hilbert-function encoding; rationality engine DONE (Route 2); SNAP-S1 gated
  on Serre canonicity; QUOT-defs predicates + Grassmannian decomposition.

## References
- `references/stacks-properties.tex` (Tag 01PB): qcoh finite-type module finite on affines —
  backs GF G1 `lem:gf_qcoh_fintype_finite_sections`.
- `references/stacks-coherent.tex` (Tag 02KH): flat base change of R^i f_* — backs FBC.
- `references/nitsure-hilbert-quot.md/.pdf` §4: generic flatness — backs GF.
- `references/hilbert-serre.md` (Tag 00K1): graded Hilbert–Serre — backs QUOT S2 (done).

## Focus areas
- **`Cohomology_FlatBaseChange.tex`** — the newly split Seam-A chain: verify the three
  `inner_eCancel` atom lemmas (`_eUnit`, `_pushforwardComp`, `_pullbackComp`), the `inner_eCancel`
  assembly, and `inner_value_eq` have correct `\uses{}`, sound proof sketches, and well-formed
  `\lean{}` targets. These feed an ACTIVE FBC prover lane THIS iter — the HARD GATE on this
  chapter gates that dispatch.
- **`Picard_FlatteningStratification.tex`** — the new G1/G3 geometric-bridge lemmas. Verify G1's
  Stacks 01PB citation, G1's `\uses{lem:qcoh_section_localization_basicOpen}` (note: that target's
  `\lean{}` pin `isLocalizedModule_basicOpen` does NOT yet exist as a Lean decl — confirm the
  G1 block is honest about this being a project-built dependency, not a fill-sorry). This chapter
  feeds an ACTIVE GF mathlib-build lane THIS iter.

## Known issues (do not re-report)
- The 5 FBC chain lemmas were created over the last two iters; some are `unmatched_lean` /
  partial by design (tex precedes lean). The two `inner_eCancel` intermediates without a Lean
  decl yet are intentional.
- `\leanok` GF-chapter resolution under sync has been flaky (recurring tooling issue, not a
  blueprint defect).
- `isLocalizedModule_basicOpen` (`lem:qcoh_section_localization_basicOpen`) is a ready-to-prove
  frontier node whose Lean decl does not yet exist — known scaffold target.
