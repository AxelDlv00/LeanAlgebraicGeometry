# Blueprint Review Report

## Slug
iter004

## Iteration
004

## Top-level summaries

### Incomplete parts

- `Picard_QuotScheme.tex` / `thm:grassmannian_representable`: proof sketch explicitly marked "deferred open question" — the RepresentableBy gap is not resolved, leaving no prover-actionable route in the proof block. Prover cannot formalize the representability step without further guidance.
- `Picard_QuotScheme.tex` / `def:quot_functor`: the Lean predicate encoding for "schematic support proper over T" and "rank-d local-freeness" is missing. PROGRESS.md explicitly flags that a mathlib-analogist pass + blueprint-writer predicate-block addition is needed before the QUOT track becomes provable.

### Proofs lacking detail

- `Picard_QuotScheme.tex` / `thm:grassmannian_representable` (proof, RepresentableBy step): the proof says "recovers the representing object through the RepresentableBy Yoneda form 'as in the RelativeSpec chapter'" but immediately acknowledges `thm:relative_spec_univ` only delivers `IsAffineHom`, not a `RepresentableBy` witness. No alternative proof route (RepresentableBy-free Grassmannian argument) is supplied; the block ends with "deferred open question." A prover reading this would have no guidance for the critical last step.

### Lean difficulty quality

- `Picard_FlatBaseChange.tex` / `lem:flat_preserves_equalizer_mathlib`: stated name `LinearMap.tensorEqLocusEquiv`. The NOTE says it is "underlain by `Module.Flat.ker_lTensor_eq` and `Module.Flat.eqLocus_lTensor_eq`" — the _combined_ lemma name may not exist under the stated spelling. This affects FBC-B (`thm:flat_base_change_pushforward`) which is queued, not this iter's active work. Pre-verify before dispatching the FBC-B prover.

## Per-chapter

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **HARD GATE: CLEARS.** Both new iter-004 sub-lemma chains and the two thin helpers are sound.
  - `lem:base_change_mate_regroupEquiv`: pure tensor algebra — `(R'⊗_R A)⊗_A M ≅ R'⊗_R M` assembled as `comm ∘ cancelBaseChange ∘ comm`. The tensor-order convention note (Lean uses `A⊗[R]R'` vs prose `R'⊗_R A`) is documented and faithful. Generator computation `(r'⊗1)⊗m ↦ r'⊗m` is correct. No flatness hypothesis. Sound for independent formalization.
  - `lem:base_change_mate_generator_trace_eq`: the conjugated section-level map = `regroup⁻¹`. The 3-step generator trace (unit → `f_*` reindex → `(g^*⊣g_*)` transpose) is explicit and correct. Each step uses named lemmas; no guessing required by a prover. Sound.
  - `lem:base_change_mate_generator_trace` (IsIso corollary): trivially follows from `_trace_eq` + `regroupEquiv` being a `LinearEquiv`. Parent assembly (`lem:pushforward_base_change_mate_cancelBaseChange`) \uses-chain is correct.
  - `lem:pullbackIsoEquivalenceOfIso` and `lem:pullback_isEquivalence_of_iso`: thin coverage blocks. Both have adequate proof sketches (pseudofunctor coherences for the equivalence; unit = natural iso). Both are unmatched_lean (Lean declarations with those names don't exist yet — prover must scaffold). Blueprint entries are sound.
  - **Soon (minor)**: the proof-level `\uses{}` of `lem:base_change_mate_codomain_read` omits `lem:pullback_isEquivalence_of_iso`. The statement-level `\uses{}` includes it, so the DAG edge exists and no dispatch-order risk arises. Inconsistency only.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **HARD GATE: CLEARS.** L3 decomposition, L4 re-encoding, and L5 prose correction are all mathematically sound.
  - **L3 decomposition** (`lem:gf_splice_shortExact_localized_exact/free_transport/split`): the three sub-lemmas correctly extract the three algebraic steps of the Nitsure §4 splicing proof. L3a (localisation exact via `LocalizedModule.map_exact`) is standard and clearly stated. L3b (free transport across a product factorisation `f=f'f''`) is well-specified and the proof is complete. L3c (free ends → split SES → free middle) is correct: free = projective → splits. Assembly proof of parent `lem:gf_splice_shortExact` correctly applies them in order; the assembly is faithful to the Nitsure §4 verbatim quote which is correctly carried.
  - **L4 re-encoding** (`lem:gf_noether_clear_denominators`): the AlgHom target is faithful to Nitsure §4 — `φ: A_g[X₁,…,Xₙ] →ₐ B_g` with `Injective φ` encoding algebraic independence and `Module.Finite MvPoly B_g` over `φ.toAlgebra` encoding module-finiteness. The `% LEAN SIGNATURE` block is complete and explains the rationale for the AlgHom encoding over the earlier anonymous-instance form. Adequate for prover re-sign.
  - **L5 prose correction** (`lem:gf_free_moduleFinite`): A-finiteness of M is correctly stated as derived (via `Module.Finite.trans` from B-finiteness of M and A-finiteness of B), not assumed. The proof sketch is self-consistent.
  - All three new L3 sub-lemmas are unmatched_lean and lack \leanok — expected (new this iter, awaiting prover scaffolding). Parent `lem:gf_splice_shortExact` is \leanok (pre-iter-004 Lean body is monolithic; prover will refactor to use the sub-lemma chain).

### blueprint/src/chapters/Picard_GrassmannianCells.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:grassmannian_representable` proof sketch: the NOTE block explicitly marks the RepresentableBy step as "deferred open question." The five-step Nitsure construction (charts, transitions, cocycle, separatedness, properness, universal quotient, Plücker embedding) is fully detailed, but the representability conclusion — that the constructed scheme represents `Grass(V,d)` — has no prover-actionable closing argument. Route (a) requires strengthening `thm:relative_spec_univ` to deliver a `RepresentableBy` witness; route (b) requires a direct chart-wise classifying-morphism argument. Neither is supplied.
  - `def:quot_functor`: mathematical definition correct, but the Lean predicate encoding for "F coherent with schematic support proper over T" (the pair `[F.IsQuasicoherent]` + `[F.IsFiniteType]` used in `thm:generic_flatness` is absent here) is not stated. PROGRESS.md flags this as requiring a mathlib-analogist pass. Without encoding notes, a prover cannot properly formalize the Quot functor type.
  - Hilbert polynomial sub-chain (`def:sectionGradedRing`, `def:sectionGradedModule`, `lem:sectionGradedModule_fg`, `lem:gradedHilbertSerre_rational`, `thm:hilbertPoly_of_sectionModule`): all present, proof sketches adequate, citations properly sourced from Nitsure §1. ✓
  - **Note**: chapter is gated behind FBC/GF completion; partial status does not block current active prover lanes.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Blueprint mathematics is correct throughout.
  - **Lean difficulty quality (informational)**: the NOTE blocks on `thm:relative_spec_univ` and `thm:relative_spec_affine_base` document that the current Lean implementations are weaker than the blueprint prose (delivering `IsAffineHom` / `IsAffine` rather than the full Yoneda-bijection form). The blueprint prose IS the target; the Lean is behind. Tracked; prover should know the Lean signature is currently weaker.

## Dependency & isolation findings

leandag build: **0 unknown_uses** (no broken `\uses{}`), **0 isolated nodes**, 0 conflicts.

Unmatched `\lean{}` (24 nodes): all expected — 8 are `\mathlibok` blocks referencing Mathlib declarations not in project Lean files; 16 are blueprint nodes for declarations not yet scaffolded in Lean (GrassmannianCells, QuotScheme, graded Hilbert chain, and the 6 new iter-004 declarations). No fabrication concerns.

## Severity summary

**HARD GATE for active prover lanes:**
- `Cohomology_FlatBaseChange.tex`: **complete: true + correct: true — GATE PASSES for FBC lane**
- `Picard_FlatteningStratification.tex`: **complete: true + correct: true — GATE PASSES for GF lane**

---

**must-fix-this-iter findings:**

1. `Picard_QuotScheme.tex` — **complete: partial** — dispatch blueprint-writer with directive targeting:
   (a) `thm:grassmannian_representable` proof sketch: supply a prover-actionable RepresentableBy closing argument (either strengthen the `thm:relative_spec_univ` dependency to `RepresentableBy`, or write a RepresentableBy-free direct chart-wise argument). Remove or resolve the "deferred open question" note.
   (b) `def:quot_functor`: add Lean predicate encoding notes specifying the Lean types for "schematic support proper over T" (likely `[F.IsQuasicoherent]` + `[F.IsFiniteType]`) and "rank-d local-freeness for SheafOfModules," matching the pattern already in place for `thm:generic_flatness`. This unblocks the QUOT track.
   — This must-fix does **not** block FBC or GF prover dispatch (QuotScheme.lean is not in current objectives).

**soon findings:**

2. `Cohomology_FlatBaseChange.tex` / `lem:base_change_mate_codomain_read` proof block: `\uses{}` omits `lem:pullback_isEquivalence_of_iso`. Statement-level `\uses{}` has it; DAG edge exists; no dispatch-order risk. Wire-up the proof-level `\uses{}` for consistency.
3. `Cohomology_FlatBaseChange.tex` / `lem:flat_preserves_equalizer_mathlib`: verify that `LinearMap.tensorEqLocusEquiv` is the correct Mathlib spelling before the FBC-B prover is dispatched (the underlying `Module.Flat.eqLocus_lTensor_eq` exists; the combined wrapper name is unconfirmed).

**informational:**

4. `Picard_RelativeSpec.tex`: Lean implementations of `thm:relative_spec_univ` and `thm:relative_spec_affine_base` are currently weaker than blueprint prose (tracked in NOTE blocks). No action needed until the iter-174+ refinement pass.
5. leandag: 2 nodes show "needs \leanok" — these are declarations proved in Lean without a corresponding blueprint `\leanok` marker; sync_leanok will resolve automatically.

---

**Overall verdict**: `Cohomology_FlatBaseChange.tex` and `Picard_FlatteningStratification.tex` both clear the HARD GATE (`complete: true + correct: true`, no must-fix touching either chapter) — FBC and GF provers may be dispatched. One non-blocking must-fix: `Picard_QuotScheme.tex` is `complete: partial` (RepresentableBy proof sketch incomplete; Quot functor predicate encoding absent); dispatch blueprint-writer for that chapter before the QUOT track activates.
