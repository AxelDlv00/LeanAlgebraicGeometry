# Blueprint Review Report

## Slug
iter198

## Iteration
198

## Top-level summaries

### Incomplete parts

- `Picard_RelPicFunctor.tex` / `thm:rel_pic_etale_sheaf_group_structure`: No `\lean{...}` pin and no `\leanok` on proof block. Block absent from "Lean encoding" section entirely — the prover has no named declaration target for the group-structure preservation theorem on the étale sheafification. This is the 6th of 6 sorries the chapter gates.
- `RiemannRoch_WeilDivisor.tex`: The specific Lean target `rationalMap_order_finite_support` (L249; Stacks 02RV / Hartshorne Lemma 6.1 finite-support) has no standalone `\lean{...}` blueprint pin. Finite-support content is embedded inside `def:principal_divisor` but not given a dedicated declaration block for the prover to target L249 directly.
- `Albanese_AuslanderBuchsbaum.tex`: The inductive-step helper `auslander_buchsbaum_formula_succ_pd` (L1131) has no standalone blueprint block. Content exists in `thm:auslander_buchsbaum`'s proof sketch, but the prover must infer the specific Lean formulation from the parent theorem.

### Proofs lacking detail

- `Albanese_AlbaneseUP.tex` / `lem:symmetric_product_to_jacobian`: birationality of `f^(g)` relies on "Riemann-Roch and the standing hypothesis g > 0" to conclude the generic fibre is a single point (h^0(D) = 1 generically). This step requires `thm:riemannRoch_genus_zero` (Route C, PAUSED), making the birationality claim downstream of Route C. The blueprint does not flag this dependency explicitly. A prover cannot close this sorry without Route C.
- `Albanese_CodimOneExtension.tex` / `lem:smooth_to_regular_local_ring` (Stage 6): Proof correctly flags the Stacks 00OE + 02JK Mathlib gap. The Stages 5a/5b helpers are axiom-clean, but Stage 6 remains an acknowledged typed sorry. Recipe is clear; not a blueprint defect but a Mathlib gap.

### Lean difficulty quality

- `Picard_RelPicFunctor.tex` / `def:rel_pic_etale_sheafification`: The "Verification flag" in the Lean encoding section notes that "the exact Mathlib declaration name and input-shape of the étale-Grothendieck-topology instance on Sch/k are not pinned in this chapter." Without a confirmed Mathlib API name, the prover for `etSheaf` must discover the API empirically.
- `Albanese_AlbaneseUP.tex` / `def:symmetric_power_curve`: "Mathlib has no formalised g-th symmetric power of a scheme." The declaration is expected to carry `\notready` marker; the blueprint correctly warns about this. But the downstream birationality and descent sub-lemmas all depend on this unbuilt object, making the entire A.4.d prover lane practically gated on `SymmetricPower`.

### Multi-route coverage

- Route A: COVERED across dedicated chapters.
- Route C (Riemann–Roch chain): PAUSED per standing directive. All Route C chapters (RiemannRoch_WeilDivisor, RRFormula, OCofP, OcOfD, RationalCurveIso, H1Vanishing, AbelianVarietyRigidity genus-0 path, BareScheme/ChartIso/GmScaling/RigidityKbar) remain in blueprint with no stale narrative that needs to be neutered — they are passively documented and correctly flagged as paused or off-critical-path. No chapter action required.

### Citation discipline

- `Picard_RelPicFunctor.tex` — All `% SOURCE: ... (read from references/kleiman-picard-src/kleiman-picard.tex, L...)` citations verified: `references/kleiman-picard-src/kleiman-picard.tex` exists on disk. ✓
- `Albanese_CodimOneExtension.tex` — `references/stacks-algebra.tex` (Stacks 00TT, 00OE, 02JK citations) and `references/abelian-varieties.pdf` (Milne §I.3) both exist on disk. ✓
- `Albanese_AuslanderBuchsbaum.tex` — `references/stacks-algebra.tex` (Stacks 00LF, 00LP, 00LE, 090V) exists. ✓
- `RiemannRoch_WeilDivisor.tex` — `references/hartshorne-algebraic-geometry.pdf` exists; no `(read from ...)` parenthetical on the top-level `% SOURCE:` comment in the chapter header (it points to the PDF directly, not to a `.md` pointer file). This is technically a citation-discipline finding: the header `% SOURCE:` does not use a local `.md` file parenthetical. However, all inline declaration block citations do use parentheticals correctly. The header citation is informational only (not part of a declaration block), so this is **informational** rather than a hard fail.
- `Albanese_Thm32RationalMapExtension.tex` — `references/abelian-varieties.pdf` exists. ✓
- No `% SOURCE:` line naming a local file that does not exist on disk found in any of the 5 gate chapters.

---

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Picard_CarrierSoundnessProbe.tex`

**Covers**: `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` (carrier-probe declarations only)
**Strategy phase**: Carrier-soundness probe (see STRATEGY.md § Open strategic questions)
**Why now**: The 6 typeclass `⟨sorry⟩` instance constructors in `FGAPicRepresentability.lean` (lines 149, 176, 236, 294, 409, 465) are structurally gating all of A.1.c, A.2.c, and A.3.0–vi in the meantime; the probe's abort criterion determines whether the entire typeclass-abstraction strategy is sound before further prover work is invested. Writing this chapter now documents the probe's 6 declarations, their expected axiom sets, and the abort criterion so the plan agent can dispatch a prover lane to run `lean_verify` on each consumer.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:hasPicSharp}` — The `HasPicSharp` typeclass bundling the carrier `picSharp : Over (Spec (.of k)) → Type` as a sorry instance. `\lean{AlgebraicGeometry.Scheme.HasPicSharp}` [expected]. Source: STRATEGY.md § Carrier-soundness probe.
2. `\definition` `\label{def:hasDivFunctor}` — `HasDivFunctor` typeclass. `\lean{AlgebraicGeometry.Scheme.HasDivFunctor}` [expected]. Source: STRATEGY.md.
3. `\definition` `\label{def:hasPicScheme}` — `HasPicScheme` typeclass. `\lean{AlgebraicGeometry.Scheme.HasPicScheme}` [expected]. Source: STRATEGY.md.
4. `\definition` `\label{def:hasAbelMap}` — `HasAbelMap` typeclass. `\lean{AlgebraicGeometry.Scheme.HasAbelMap}` [expected]. Source: STRATEGY.md.
5. `\definition` `\label{def:picSharpRepresentable}` — `PicSharpRepresentable` typeclass. `\lean{AlgebraicGeometry.Scheme.PicSharpRepresentable}` [expected]. Source: STRATEGY.md.
6. `\definition` `\label{def:picSchemeGroupObject}` — `PicSchemeGroupObject` typeclass. `\lean{AlgebraicGeometry.Scheme.PicSchemeGroupObject}` [expected]. Source: STRATEGY.md.
7. `\theorem` `\label{thm:carrier_probe_axiom_check}` — For each of the 6 `⟨sorry⟩` instance constructors: `#print axioms` returns `{propext, Classical.choice, Quot.sound, sorryAx}` (FAIL) or `{propext, Classical.choice, Quot.sound}` (PASS). The PASS condition is that downstream consumers that derive `[HasPicScheme C]` do NOT propagate `sorryAx`. `\lean{AlgebraicGeometry.Scheme.PicScheme.probe_axiomCheck}` [expected]. Source: STRATEGY.md § Carrier-soundness probe / abort criterion.

**`\uses` skeleton**:
- `thm:carrier_probe_axiom_check` uses all 6 `def:has*` / `def:pic*` definitions
- Each `def:has*` is a root

**Main theorem proof strategy**: The 6 `⟨sorry⟩` constructors are run through `lean_verify` (Archon MCP tool). Each non-`⟨sorry⟩` consumer (any declaration that derives `[HasPicScheme C]` then calls `picScheme C`) is checked: if `#print axioms` shows `sorryAx`, the probe FAILS and the carrier-abstraction strategy must be abandoned (git revert). If all consumers return the kernel triple, the probe PASSES and A.1.c–A.2.c prover work under typeclass abstraction is sound.

**References for writer**:
- STRATEGY.md §"Carrier-soundness probe — abort criterion" — defines the 6 declarations and the exact pass/fail condition
- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` — existing file with the 6 sorried instances; writer should read it before writing the chapter

**Subphase choices exposed**:
- PASS vs. FAIL abort: if the probe FAILS, the chapter is the last record before a git revert of `carrier-soundness-fgapic`; if PASS, the chapter gates A.1.c prover dispatch. No decomposition choice needed; the chapter is intentionally thin (just the probe declarations + axiom-check theorem).

---

### Proposed chapter: `blueprint/src/chapters/Picard_PicDSubstrate.tex`

**Covers**: New Lean file `AlgebraicJacobian/Picard/PicDSubstrate.lean` (to be created)
**Strategy phase**: A.4.d.0 — Pic^d substrate; gated on A.2.c + A.3.vii + RR
**Why now**: The Albanese universal property chapter (AlbaneseUP.tex) uses the symmetric-power route, but STRATEGY.md also records a Cartier-route via `𝓛 ↦ Div(𝓛)` on `C × Pic^d`. Documenting the Cartier-route approach now exposes the subphase choice — symmetric-power vs. Cartier-divisor — and enables the plan agent to decide which route to pursue for A.4.d without burning a prover iter on the wrong substrate.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:picDScheme}` — The `Pic^d_{C/k}` scheme as the `d`-th connected component of `Pic_{C/k}` (the translate of `Pic^0` by any degree-`d` divisor). `\lean{AlgebraicGeometry.Scheme.PicDScheme}` [expected]. Source: `references/kleiman-picard.md` §9.5 + `references/abelian-varieties.md` §III.1.
2. `\definition` `\label{def:universalEffDivisor}` — The universal effective divisor `𝒟_d ⊆ C × Pic^d_{C/k}` as a closed subscheme over `Pic^d_{C/k}`, flat of degree `d`. `\lean{AlgebraicGeometry.Scheme.universalEffectiveDivisor}` [expected]. Source: `references/kleiman-picard.md` §3 (Div functor + Abel map).
3. `\definition` `\label{def:abelMapDeg}` — The degree-`d` Abel map `A_d : C^{(d)} → Pic^d_{C/k}`, `D ↦ [O_C(D)]`. `\lean{AlgebraicGeometry.Scheme.abelMapDeg}` [expected]. Source: `references/kleiman-picard.md` §3 Def.~dfn:Abel; `references/abelian-varieties.md` §III.5.
4. `\lemma` `\label{lem:picD_translate_pic0}` — `Pic^d_{C/k}` is isomorphic to `Pic^0_{C/k}` as a scheme (non-canonically; requires a degree-`d` divisor class). `\lean{AlgebraicGeometry.Scheme.PicDScheme.isoToPic0}` [expected]. Source: `references/abelian-varieties.md` §III.1 "translate".
5. `\theorem` `\label{thm:cartierRoute_lineBundleDiv}` — The Cartier-route statement: for `ℒ ∈ Pic^d(T)` and a choice of degree-`d` Cartier divisor representing it on `C × T`, the map `ℒ ↦ Div(ℒ)` identifies `Pic^d_{C/k}(T)`-points with degree-`d` effective Cartier divisors modulo rational equivalence. `\lean{AlgebraicGeometry.Scheme.PicDScheme.cartierRouteEquiv}` [expected]. Source: `references/kleiman-picard.md` §3; `references/fga-explained.md` §9.5.

**`\uses` skeleton**:
- `thm:cartierRoute_lineBundleDiv` uses `def:picDScheme`, `def:universalEffDivisor`, `def:abelMapDeg`, `lem:picD_translate_pic0`
- `def:abelMapDeg` uses `def:picDScheme`, `def:universalEffDivisor`
- `lem:picD_translate_pic0` uses `def:picDScheme` + `def:pic_zero_subscheme` (from Picard_IdentityComponent.tex)
- `def:universalEffDivisor` uses `def:picDScheme`

**Main theorem proof strategy**: `def:picDScheme` is direct from the connected-component decomposition of `Pic_{C/k}` already established in `Picard_IdentityComponent.tex`. `def:universalEffDivisor` is the key new construction: it is a flat closed subscheme of `C × Pic^d_{C/k}` that must be built from the tautological line bundle on `C × Pic^d_{C/k}`. The Cartier-route theorem (`thm:cartierRoute_lineBundleDiv`) then identifies Pic^d-points with degree-d effective Cartier divisors via the Abel map, which is the concrete bridge needed for A.4.d.

**References for writer**:
- `references/kleiman-picard.md` → `references/kleiman-picard-src/kleiman-picard.tex` §3 (Div functor, Abel map, dfn:Abel) — primary source
- `references/abelian-varieties.md` → `references/abelian-varieties.pdf` §III.1 (degree-d components, translate isomorphism), §III.5 (Theorem 5.1, Abel map birationality) — supporting source
- `references/fga-explained.md` → `references/fga-explained.pdf` §9.5 (Pic^d, degree components) — supplementary

**Subphase choices exposed**:
- Symmetric-power route (already in AlbaneseUP.tex) vs. Cartier-divisor route (this chapter): the symmetric-power route requires `SymmetricPower` of a scheme (no Mathlib analogue; major sub-build needed). The Cartier-divisor route uses `Pic^d_{C/k}` and the universal effective divisor, which are gated on FGA representability (A.2.c) and RR (for the degree map). The plan agent should decide: if RR (Route C) stays paused, the symmetric-power route is also gated (birationality of `f^(g)` uses RR in `lem:symmetric_product_to_jacobian`). The Cartier route is equally gated. Recommendation: write this chapter to document the Cartier route as an alternative, even if both routes remain gated, to enable future parallelism when RR re-engages.

---

### Proposed chapter: `blueprint/src/chapters/Albanese_TangentSpaceSubstrate.tex`

**Covers**: New Lean file `AlgebraicJacobian/Albanese/TangentSpaceSubstrate.lean` (to be created)
**Strategy phase**: A.3.0 — tangent-space substrate; priority-3 (parallel)
**Why now**: The A.3.iii tangent-space iso (`T_e Pic^0 ≅ H^1(C, O_C)`) in Pic0AbelianVariety.tex consumes a scheme-level tangent space that must be constructed from first principles. Currently `Picard_Pic0AbelianVariety.tex`'s `thm:pic0_tangent_space_iso` proof references "the truncated exponential sequence and the étale-sheaf comparison theorem" without a formalised substrate. Writing the substrate chapter now decouples A.3.0 from A.3.iii and enables a parallel prover lane.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:tangentSpaceGroupScheme}` — The Zariski tangent space `T_e G` of a k-group scheme G at its identity section as the k-module `G(k[ε]/(ε²))_e` (k_ε-points reducing to e). `\lean{AlgebraicGeometry.GroupScheme.tangentSpace}` [expected]. Source: `references/kleiman-picard.md` §5 Thm.~thm:tgtsp (setup paragraph); EGA IV 16 (dual numbers).
2. `\lemma` `\label{lem:tangentSpace_kModule}` — `T_e G` carries a canonical k-module structure from the k-linear structure of k[ε]/(ε²). `\lean{AlgebraicGeometry.GroupScheme.tangentSpace_kModule}` [expected]. Source: Archon-original.
3. `\definition` `\label{def:truncatedExpSeq}` — The truncated exponential sequence `0 → O_X → O_{X_ε}^× → O_X^× → 1` for X a k-scheme and X_ε := X ⊗_k k_ε, with first map `b ↦ 1 + bε`. `\lean{AlgebraicGeometry.Scheme.truncatedExpSequence}` [expected]. Source: `references/kleiman-picard.md` §5 proof of Thm.~thm:tgtsp, L3271–L3300.
4. `\lemma` `\label{lem:truncatedExpSeq_splitExact}` — The truncated exponential sequence splits (via `a ↦ a + 0·ε`) yielding a split exact sequence on cohomology: `0 → H^1(X, O_X) → H^1(X, O_{X_ε}^×) → H^1(X, O_X^×) → 1`. `\lean{AlgebraicGeometry.Scheme.truncatedExpSeq_splitExact}` [expected]. Source: `references/kleiman-picard.md` §5 L3358–L3367.
5. `\theorem` `\label{thm:tangentSpace_iso_H1}` — For `G = Pic_{C/k}` representing `Pic_{(C/k)et}`, there is a canonical k-linear iso `T_0 Pic_{C/k} ≅ H^1(C, O_C)`. `\lean{AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso_substrate}` [expected]. Source: `references/kleiman-picard.md` §5 Thm.~thm:tgtsp; `references/hartshorne-algebraic-geometry.md` §IV.1.1.

**`\uses` skeleton**:
- `thm:tangentSpace_iso_H1` uses `def:tangentSpaceGroupScheme`, `lem:tangentSpace_kModule`, `def:truncatedExpSeq`, `lem:truncatedExpSeq_splitExact`
- `lem:truncatedExpSeq_splitExact` uses `def:truncatedExpSeq`

**Main theorem proof strategy**: The key step is identifying `T_0 Pic_{C/k}` with the kernel of `H^1(X, O_{X_ε}^×) → H^1(X, O_X^×)` via the dual-numbers tangent description, then using the split exact sequence to identify that kernel with `H^1(X, O_X)`. The comparison map `v: H^1(X, O_X) → T_0 Pic_{C/k}` is constructed from the commutative diagram (Kleiman §5 Exercise ex:Alr) and shown to be an iso after base change to algebraically closed k̄.

**References for writer**:
- `references/kleiman-picard.md` → `references/kleiman-picard-src/kleiman-picard.tex` L3265–L3408 (thm:tgtsp full proof) — primary
- `references/abelian-varieties.md` → §III.6.3 (tangent space of Jacobian = H^1) — supplementary

**Subphase choices exposed**:
- Dual-numbers approach vs. cotangent-complex approach: the dual-numbers approach (this outline) works for group schemes over a field and matches Kleiman §5; the cotangent-complex approach would require A.3.0's substrate to use Mathlib's `Algebra.H1Cotangent`, which is heavier. Recommendation: dual-numbers approach is correct here.

---

## Per-chapter

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `auslander_buchsbaum_formula_succ_pd` (L1131 prover target) has no standalone `\lean{...}` blueprint block; content lives in `thm:auslander_buchsbaum` proof's inductive-step paragraphs. Prover must infer the specific declaration shape. (soon)
  - Stacks 00NQ gap (load-bearing for `exists_isSMulRegular_quotient_isRegularLocal_succ`) is honestly documented; closure path via (a) in-project ~300 LOC or (b) Koszul bypass. (informational)
  - HARD GATE verdict: **CLEAR** — blueprint is complete and correct; missing `succ_pd` pin is Lean-difficulty quality, not a content gap; prover can work from `thm:auslander_buchsbaum`'s explicit inductive step.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `rationalMap_order_finite_support` (L249 prover target; Stacks 02RV / Hartshorne Lemma 6.1) has no standalone `\lean{...}` pin; finite-support content embedded in `def:principal_divisor` SOURCE QUOTE. Prover must derive the L249 target from that block. (soon)
  - §1 (Codim-1 cycle group) and §2 (Order of a rational function at a prime divisor) fully cover the A.4.a substrate needed. The layered-typeclass standing hypothesis encoding is detailed and correct.
  - `lem:degree_positivePart_principal_eq_finrank` body remains a typed sorry (iter-191+ Hartshorne II.6.9 substrate); blueprint correctly documents this with the iter-194 refactor v2 NOTE. (informational)
  - HARD GATE verdict: **CLEAR** — §1–§2 cover the general substrate; `def:principal_divisor` covers the finite-support basis for L249.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **MUST-FIX**: `thm:rel_pic_etale_sheaf_group_structure` has no `\lean{...}` pin and does not appear in the "Lean encoding" section. This is the 6th of 6 prover-gate sorries and it lacks both a declaration name and a `\leanok` proof block. The prover cannot close this sorry without knowing which Lean declaration to target.
  - The Lean encoding section's "Verification flag" on `etSheaf` notes that the étale-Grothendieck-topology Mathlib API is not confirmed; this should also be resolved by a writer dispatch. (must-fix, same dispatch)
  - HARD GATE verdict: **DEFER** — writer must add `\lean{AlgebraicGeometry.Scheme.PicSharp.etSheafGroupStructure}` (or confirmed Mathlib name) pin to `thm:rel_pic_etale_sheaf_group_structure`, add proof sketch (plus-construction preserves abelian-group target; Mathlib `CategoryTheory.Sheafification`), and confirm the étale topology API name.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `lem:smooth_to_regular_local_ring` (Stacks 00TT) carries acknowledged typed sorry gated on Stacks 00OE + 02JK Mathlib gaps. Blueprint proof sketch is explicit: Stages 5a/5b axiom-clean; Stage 6 = 00OE + 02JK bridges, iter-200+ target. (informational)
  - `thm:codim_one_extension` (Milne Thm 3.1): proof body has no `\leanok` but sketch is complete (two-step: valuative criterion + depth-≥2 extension). (informational; expected sorry)
  - `lem:milne_codim1_indeterminacy` (Milne Lemma 3.3): proof body no `\leanok` but sketch complete (four sub-steps; Weil-divisor apparatus on X×X). (informational; expected sorry)
  - `thm:weil_divisor_obstruction` has no `\lean{...}` pin (deliberately detached iter-179 per NOTE). `lem:mem_domain_partial_map_reshuffle` is the honest fallback.
  - HARD GATE verdict: **CLEAR** — all 3 target sorries have full, correct proof sketches. The `lem:smooth_to_regular_local_ring` Mathlib gap is documented with clear closure path. A prover can close `thm:codim_one_extension` and `lem:milne_codim1_indeterminacy` now while Stage 6 waits for Mathlib upstreaming.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex
- **complete**: true
- **correct**: true
- **notes**:
  - HARD GATE verdict: **CLEAR** — Single theorem `thm:rational_map_to_av_extends` (`\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}`). Proof is a clean three-step combination of CodimOneExtension outputs. All `\uses{}` cross-refs resolve to existing labels.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:nonempty_jacobianWitness` proof is an acknowledged deep gap (all Route A sub-steps A.1–A.4 missing from Mathlib; sorry body). Blueprint correctly documents this. (informational)
  - The genus-0 arm references `prop:rigidity_genus0_curve_to_AV` from AbelianVarietyRigidity.tex, which is the committed path. ✓

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `thm:rigidity_over_kbar` is a named gap (sorry body); correctly flagged as fallback route (a), not the committed genus-0 path. (informational)
  - Route (a) gaps (i)+(ii) [cotangent triviality + Serre duality H^0(C,Ω)=0] remain unresolved; route (b) [dual-AV via Pic^0(ℙ¹)=0] is documented as a candidate. (informational)
  - This chapter is NOT on the active critical path (genus-0 goes through AbelianVarietyRigidity.tex's characteristic-free route). No action required.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes (pointer chapter only).

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - Several `\lean{...}` pins have corresponding NOTEs noting the Lean type is weaker than prose (`affine_base_iff` carries `IsAffine` not the canonical iso; `base_change` body is an existential not the canonical iso). These are acknowledged; bodies are now axiom-clean per iter-185. (informational)

### blueprint/src/chapters/Picard_LineBundlePullback.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `def:line_bundle_on_product` carrier (`OnProduct`) is a subtype with `IsLocallyTrivial` predicate (iter-187); the NOTE says the full quotient by `pi_T^* Pic(T)` in `thm:relative_pic_quotient_well_defined` is deferred to iter-187+. The body of `thm:relative_pic_quotient_well_defined` currently only identifies iso-classes (Setoid) without quotienting by the pullback subgroup. This is a partial completeness issue for A.1.b but is not gating any iter-198 prover lane. (soon)
  - `lem:IsLocallyTrivial_pullback` has 1 narrow named sorry on chart-iso composition. (informational)

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - All declaration bodies expected to carry sorries (FGA representability is not proved in Lean). Blueprint is an honest specification; proof bodies reference EGA material not in Mathlib. (informational)
  - `lem:smooth_proper_quotient` (Altman–Kleiman effective-equivalence-relation descent) explicitly notes it may need to be sorried. (informational)
  - Not on active prover lanes this iter (gated on RR / carrier probe).

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - Base-change substrate (`pullback_tildeIso`, `pushforward_isQuasicoherent`, `pullback_app_isoTensor_sigma`) carries named typed sorries with clear iter-189+ closure targets. (informational)
  - The 6-stage Beck-Chevalley intertwining decomposition is fully documented; not gating iter-198 lanes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `lem:geometricallyConnected_of_connected_of_section` (Stacks 037Q) proof has no `\leanok`; body carries a typed sorry pending Mathlib's `constantSheaf` Full/Faithful instances or Route B fallback (iter-197+ target). (soon)
  - Not gating iter-198 lanes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `thm:pic0_tangent_space_iso` proof relies on Kleiman §5 Exercise ex:Alr (étale-sheaf representability comparison) which requires the FGA Picard scheme (A.2.c) and the base-change commutation (A.1.c). The proof sketch is correct but deeply gated on Route A sub-phases. (informational)
  - `thm:pic0_proper` proof (Chevalley–Rosenlicht structure theorem) references Conrad "A modern proof" — not in references/. Flag: retrieval needed if a prover works this theorem. (soon)

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **Route C dependency**: `lem:symmetric_product_to_jacobian` birationality claim uses `h^0(D) = 1` generically on `Sym^g C`, which follows from `\ell(D) - h^1(D) = 1` (Riemann-Roch at degree g). Route C (Riemann-Roch) is PAUSED. This makes the birationality claim gated on Route C. The blueprint does not explicitly flag this Route C dependency in the birationality proof sketch. (must-fix: add NOTE flagging Route C dependency in `lem:symmetric_product_to_jacobian` proof)
  - `def:symmetric_power_curve` is noted as having no Mathlib analogue. The \textbf{Mathlib status} section documents this; the chapter recommends a `\notready` marker. (informational)
  - Not gating iter-198 prover lanes (this chapter is A.4.d, priority-5).

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The two carrier classes (`HasCechToHModuleIso`, `HasAffineCechAcyclicCover`) are honestly documented as currently unproduced. The conditional genus-carrier theorem is in place. (informational)

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: partial (Route C / PAUSED)
- **correct**: partial
- **notes**:
  - Route C chapter, PAUSED. `lem:H1_skyscraperSheaf_finrank_eq_zero` body gated on H1Vanishing substrate. `lem:euler_char_shortExact_add` gated on Module-kbar-flavoured LES carrier. These are documented. (informational — no prover dispatch this iter)

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: partial (Route C / PAUSED)
- **correct**: partial
- **notes**:
  - Route C chapter, PAUSED. Sub-claim infrastructure (a)/(b)/(c) documented with iter-196/197 recipes. (informational)

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: partial (Route C / PAUSED)
- **correct**: true
- **notes**:
  - Route C chapter, PAUSED. Four declarations (`sheafOf`, `sheafOf_zero`, `sheafOf_singlePoint`, `sheafOf_ses_single_add`) well-specified. Not dispatched this iter.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: partial (Route C / PAUSED)
- **correct**: partial
- **notes**:
  - Route C chapter, PAUSED. iter-196 substrate helpers (a)-(d) for `iso_of_degree_one` documented. `lem:degree_one_morphism_iso` body carries sorries pending IsNormalScheme substrate. (informational)

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex
- **complete**: true (Route C / PAUSED)
- **correct**: partial
- **notes**:
  - Route C chapter, PAUSED. `lem:isFlasque_injective` has j_! gap (no Mathlib extension-by-zero functor); iter-197 closure routes A/B documented. `lem:isFlasque_constant_irreducible` non-empty branch gated on constantSheaf Full/Faithful. (informational)

---

## Cross-chapter notes

- `Albanese_AlbaneseUP.tex` / `lem:symmetric_product_to_jacobian` uses birationality of `f^(g): Sym^g C → J` via Riemann-Roch (h^0(D)=1 generically, degree g), but `RiemannRoch_RRFormula.tex` is Route C / PAUSED. The AlbaneseUP chapter never names this Route C dependency. Until Route C re-engages, this proof step cannot be closed. The AlbaneseUP chapter should carry a NOTE flagging this.

- `Picard_IdentityComponent.tex` / `def:divisor_degree_pic` uses `def:hilbert_polynomial` from `Picard_QuotScheme.tex`. The \uses reference is correctly listed in the consistency check.

- `Picard_Pic0AbelianVariety.tex` / `thm:pic0_tangent_space_iso` references `def:pic_zero_subscheme` (from IdentityComponent.tex) and `thm:identity_component_base_change_commutes` — both resolve correctly.

- `RiemannRoch_WeilDivisor.tex` / `lem:degree_positivePart_principal_eq_finrank` is referenced from `RiemannRoch_RationalCurveIso.tex` / `lem:degree_via_pole_divisor`. Cross-chapter dependency is correctly declared.

---

## Strategy-modifying findings (if any)

- The `lem:symmetric_product_to_jacobian` birationality proof in `Albanese_AlbaneseUP.tex` secretly depends on Route C (Riemann-Roch at degree g). If Route A's A.4.d is to remain fully independent of Route C, either (a) an alternative birationality argument not using Riemann-Roch must be identified, or (b) A.4.d must be acknowledged as gated on Route C re-engagement. STRATEGY.md does not record this dependency. The plan agent should audit whether any Route A phase has a hidden Route C dependency and update STRATEGY.md if so. This is a potential STRATEGY.md amendment, not a blueprint-only fix.

---

## Severity summary

### must-fix-this-iter

1. **Picard_RelPicFunctor.tex** — HARD GATE FAILS: `thm:rel_pic_etale_sheaf_group_structure` missing `\lean{...}` pin and proof sketch. Dispatch blueprint-writer for `Picard_RelPicFunctor.tex` with directive: add `\lean{...}` pin for the group-structure-preservation theorem, confirm Mathlib API for `CategoryTheory.Sheafification` at `AddCommGroup` target, add proof sketch; also confirm étale-Grothendieck-topology API name for `PicSharp.etSheaf`.

2. **unstarted-phase proposal: carrier-soundness probe** — dispatch blueprint-writer for `Picard_CarrierSoundnessProbe.tex` or record deferral rationale in iter-198 plan.md.

3. **unstarted-phase proposal: A.4.d.0 Cartier-route Pic^d** — dispatch blueprint-writer for `Picard_PicDSubstrate.tex` or record deferral rationale in iter-198 plan.md.

4. **unstarted-phase proposal: A.3.0 tangent-space substrate** — dispatch blueprint-writer for `Albanese_TangentSpaceSubstrate.tex` or record deferral rationale in iter-198 plan.md.

### soon

5. `RiemannRoch_WeilDivisor.tex` — add standalone `\begin{lemma}...\lean{AlgebraicGeometry.Scheme.rationalMap_order_finite_support}` block (Hartshorne Lemma 6.1 / Stacks 02RV) so the L249 prover target is explicitly pinned. The blueprint content is present but the declaration needs its own block.

6. `Albanese_AuslanderBuchsbaum.tex` — add `\begin{lemma}...\lean{RingTheory.Module.auslander_buchsbaum_formula_succ_pd}` block pinning the n=k+1 inductive step as a standalone declaration so L1131 has a direct blueprint target.

7. `Picard_LineBundlePullback.tex` / `thm:relative_pic_quotient_well_defined` — body currently only iso-identifies modules, not the full quotient by `pi_T^* Pic(T)`; upgrade in iter-187+ writer dispatch.

8. `Picard_Pic0AbelianVariety.tex` — retrieval needed: `thm:pic0_proper` proof cites Conrad "A modern proof of Chevalley's theorem" — no local file. Dispatch reference-retriever before this theorem's prover lane.

9. `Albanese_AlbaneseUP.tex` / `lem:symmetric_product_to_jacobian` — add NOTE flagging hidden Route C (Riemann-Roch) dependency in birationality proof.

### informational

10. `Albanese_CodimOneExtension.tex` / `lem:smooth_to_regular_local_ring` — Stacks 00OE + 02JK gap is iter-200+ target; blueprint is correct as-is.

11. All Route C chapters — PAUSED; no narrative changes needed in blueprint.

12. `Picard_IdentityComponent.tex` / `lem:geometricallyConnected_of_connected_of_section` — Route A/B closure documented for iter-197+.

13. `Albanese_AuslanderBuchsbaum.tex` / `exists_isSMulRegular_quotient_isRegularLocal_succ` — Stacks 00NQ gap; iter-200+ target.

**Overall verdict**: 3 phases have no blueprint coverage — proposals provided for immediate writer dispatch; HARD GATE defers RelPicFunctor.lean (missing `\lean{...}` pin on group-structure theorem); 4 other gate chapters CLEAR with minor soon-severity notes. 2 Route A chapters (AuslanderBuchsbaum, WeilDivisor) have incomplete Lean-difficulty-quality pins for their specific L-number targets but are otherwise CLEAR.
