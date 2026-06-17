# Blueprint Review Report

## Slug
ts215fp

## Iteration
215

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_restrict_iso` proof: the proof body contains the
  claim "This lemma is therefore **not** on the critical path for the relative Picard group law" (Step 3
  prose). Under the now-PRIMARY locally-trivial route this is a self-contradiction: the PRIMARY proof of
  `lem:islocallyinjective_whisker_of_W` explicitly says `lem:tensorobj_restrict_iso` "moves **onto** the
  critical path", and `sec:tensorobj_consistency_check` lists it as a critical-path dependency. A prover
  reading the proof of `tensorobj_restrict_iso` will think they can skip it, then be confused by the
  PRIMARY whisker proof that depends on it. Fix: remove or invert the "not on the critical path" clause
  from `lem:tensorobj_restrict_iso`'s Step 3 prose.

- `Albanese_AuslanderBuchsbaum.tex`, `Albanese_CodimOneExtension.tex`, `Albanese_Thm32RationalMapExtension.tex`,
  `Albanese_CoheightBridge.tex`: bare `~REF` / `Section~REF` placeholders appear in setup prose and
  section headers, indicating labels were not resolved after writing. These are HELD-lane chapters; the
  placeholder issue doesn't block any active prover dispatch but the chapters are technically partial.

- `RiemannRoch_RRFormula.tex`, `RiemannRoch_OCofP.tex`, `RiemannRoch_OcOfD.tex`,
  `RiemannRoch_H1Vanishing.tex`: all PAUSED under USER ROUTE C PAUSE; bare `~REF` cross-references
  present. Partial because the referenced labels are not filled in.

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_restrict_iso`: Step 3 of the proof is explicitly
  marked "off the critical path" and left open (the presheaf-level pullback comparison). The proof
  sketch for Steps 1–2 is clear. Step 3 is a tracked sorry; the prover can use the declaration as a
  sorry dependency. The only additional detail needed is clarifying that it IS a primary-path dependency
  (see the Incomplete Parts finding above).

### Multi-route coverage

- Route PRIMARY (locally-trivial-first, à la `Module.Invertible`): **PASS** — fully covered in
  `Picard_TensorObjSubstrate.tex` (`sec:tensorobj_route_e` Two-tier strategy paragraph, PRIMARY proof
  in `lem:islocallyinjective_whisker_of_W`, PRIMARY construction in `lem:tensorobj_isoclass_commgroup`).
- Route FALLBACK (route-e, `LocalizedMonoidal` + `(J.W).IsMonoidal`, arbitrary F, d.1/d.2): **PASS** —
  fully documented in `sec:tensorobj_route_e`, `lem:stalk_linear_map`, and the FALLBACK blocks of
  `lem:islocallyinjective_whisker_of_W` and `lem:tensorobj_isoclass_commgroup`.

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - MUST-FIX: `lem:tensorobj_restrict_iso` proof (Step 3 last sentence) says "This lemma is therefore
    **not** on the critical path for the relative Picard group law." This directly contradicts the
    PRIMARY route proof of `lem:islocallyinjective_whisker_of_W` (which says it "moves **onto** the
    critical path") and `sec:tensorobj_consistency_check` (which lists it as a primary residual).
    Remove/update the "not on the critical path" clause. One targeted sentence change.
  - COSMETIC (not must-fix, deferrable): `lem:tensorobj_assoc_iso` `% NOTE` calls its `IsLocallyTrivial`
    hypotheses "vestigial — they are received to match the current Lean pin but are NOT proof ingredients
    (the API-derived associator is natural in arbitrary objects) and may be dropped once lem:jw_ismonoidal
    lands." Under the now-PRIMARY locally-trivial route these hypotheses ARE load-bearing: the PRIMARY
    proof of `lem:islocallyinjective_whisker_of_W` restricts F to the locally-trivial case precisely
    because `lem:tensorobj_assoc_iso` (the sole consumer) carries those hypotheses. The NOTE is correct
    for route-(e) only. The inconsistency is prose-level and does not prevent the prover from using the
    lemma as-is — the statement is correct and the Lean pin matches. Deferrable to a later pass.
  - PRIMARY route completeness: the proof sketch for `lem:islocallyinjective_whisker_of_W` PRIMARY
    route (locally trivial F, trivializing cover, tensorobj_restrict_iso + left unitor → g|_V ∈ J.W →
    locally injective) is clear and specific. Avoids d.2 as claimed; this is NOT the iter-213
    section-level Tor₁ dead end (that route tensored section maps injective-only; here g|_V is
    J-locally-bijective, no flatness needed).
  - PRIMARY route correctness: the `Module.Invertible`-style direct group construction in
    `lem:tensorobj_isoclass_commgroup` is mathematically valid; it mirrors Mathlib's `CommRing.Pic`
    exactly as described. The reduction to Nonempty propositions correctly dispenses with pentagon/triangle
    coherence.
  - PRIMARY route critical-path dependencies: `lem:tensorobj_restrict_iso` (sorry'd, needed for
    PRIMARY whisker) and `lem:tensorobj_inverse_invertible` (sorry'd, needed for the inverse in
    `lem:tensorobj_isoclass_commgroup`). Both have proof sketches adequate for prover use as sorry
    dependencies. STRATEGY.md correctly lists these as primary residuals.
  - Citation discipline: all `% SOURCE:` blocks cite local reference files that exist on disk
    (`references/kleiman-picard-src/kleiman-picard.tex`, `references/stacks-modules.tex`) or read
    directly from `.lake/packages/mathlib/` source files. Verbatim `% SOURCE QUOTE:` text is present
    and in original language. No fabrication detected.

### Gate verdict for `Picard_TensorObjSubstrate.tex`
**Gate: NOT cleared this iter.** One must-fix (the stale "not on the critical path" annotation in
`lem:tensorobj_restrict_iso`'s proof) prevents `complete: true`. The fix is a single targeted sentence
removal/update. Recommended action: same-iter fast path — dispatch a blueprint-clean/writer for this one
annotation, then re-run this review scoped to the chapter. If that scoped re-review returns complete +
correct with no must-fix, dispatch the prover.

---

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD lane. Blueprint covers abelian-group structure and étale sheafification with adequate proof
    sketches. `lem:rel_pic_sharp_groupoid` (`\leanok`) and the consumer
    `thm:rel_pic_addcommgroup_via_tensorobj` structure are present and correctly reference
    `chap:Picard_TensorObjSubstrate`. The Lean placeholder issue (`PicSharp := const PUnit`,
    `functorial := 0`) is a Lean-side problem, not a blueprint problem; the blueprint correctly
    describes the intended construction. Partial because it depends on the TensorObjSubstrate gate
    before a prover can be dispatched.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (priority-2). Blueprint covers the FGA assembly (Abel map, existence theorem, group-scheme
    refinement) with adequate proof sketches. `lem:line_bundle_quot_correspondence` (`\leanok`). Partial
    because it depends on A.1.c + A.2.b gates; the blueprint itself is writer-complete.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (part of A.2.c-engine). Blueprint covers Hilbert polynomial and Quot functor construction.
    `def:hilbert_polynomial` (`\leanok`). Partial due to gating on A.2.a flattening.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD. Blueprint covers the Nitsure §4 flattening-stratification theorem with adequate content.
    `def:coherent_sheaf_flat` (`\leanok`). Partial due to no prover dispatch while engine is held.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (A.3, gated A.2.c). Blueprint covers abstract identity component + Pic⁰ characterisation.
    `def:identity_component_group_scheme` (`\leanok`). Partial due to gating.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (A.3). Blueprint covers tangent-space iso, smoothness, properness, AV-structure.
    `thm:pic0_tangent_space_iso` (`\leanok`). Partial due to gating on A.2.c.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.
(Consolidated chapter covers AbelianVarietyRigidity.lean + Genus0BaseObjects/* + RigidityLemma.lean.
Genus-0 Gm-scaling primary route fully documented. PAUSED under Route-C pause but blueprint is complete
for the committed genus-0 arm.)

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (A.4.d, gated A.2.c). Blueprint covers the Albanese UP via the symmetric-power / Milne
    Prop. 6.1 route. Partial due to gating.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (A.4.b). Blueprint has setup section and lists the five required declaration types but the
    actual declaration blocks reference labels via bare `~REF` placeholders — the declaration blocks
    themselves may not be present in the first 60 lines; deeper content not read. If the full chapter
    has complete declaration blocks, this is partial only due to gating. Bare `~REF` indicates
    unresolved cross-references.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (A.4.a, risk-dominant). Has setup and description of `thm:codim_one_extension` and
    `lem:milne_codim1_indeterminacy`. Some bare `~REF` in section headers (not yet resolved).
    Partial due to gating.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (A.4.c). `thm:rational_map_to_av_extends` (`\leanok`) with source quote from Milne.
    Partial due to gating on 4.a + 4.b.

### blueprint/src/chapters/Albanese_CoheightBridge.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (project-bespoke, independently parallelisable when de-gated). Setup is clear; description
    of the four Mathlib API pieces is concrete. Partial due to missing prover dispatch.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route-(a) fallback, cotangent route PAUSED. `thm:rigidity_over_kbar` (`\leanok`, sorry body).
    The chapter correctly characterises the two gaps (i) + (ii) and the named-gap disposition.
    Partial because the sorry body is acknowledged as unresolved pending cotangent-triviality + Serre
    duality; the project-side PRIMARY route (chap:AbelianVarietyRigidity) supersedes this.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (gated by user-blocked `[IsNoetherian X]`/`[CompactSpace X]` signature). Blueprint content
    is adequate for when the gate opens. Partial due to held status.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - PAUSED (Route C). Bare `~REF` cross-references in the chapter body. Partial due to pause and
    unresolved cross-references.

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - PAUSED (Route C). Bare `~REF` cross-references. Partial due to pause.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - PAUSED (Route C). Bare `~REF` cross-references. Partial due to pause.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - PAUSED (Route C). First 60 lines describe strategy and scope clearly; deeper declaration blocks
    not read. Partial due to pause.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - PAUSED (Route C). Blueprint covers RR.4 classification with citation discipline. Partial due to
    pause and `\uses{}` at chapter level (outside any lemma block) which is non-standard but harmless.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - The main chapter: `def:IsAlbanese`, `def:Jacobian`, `thm:nonempty_jacobianWitness` scaffold.
    `def:IsAlbanese` (`\leanok`). Partial because the full positive-genus arm (Route A) is
    unformalized pending the TensorObjSubstrate → RelPicFunctor → A.2.c chain.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
(Pointer chapter; zero sorry-bodied declarations per the blueprint text. Content delegates to RigidityKbar.tex.)

## Cross-chapter notes

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_restrict_iso` "off the critical path" claim versus
  `lem:islocallyinjective_whisker_of_W` and `sec:tensorobj_consistency_check` "on the critical path"
  claim — intra-chapter contradiction, see above. No cross-chapter impact beyond the single chapter.

- `PROGRESS.md` current objectives (iter-214) still describe the prover as working on route-(e) d.1/d.2
  (`isLocallyInjective_whiskerLeft_of_W` via stalkwise argument) and list `tensorObj_restrict_iso` as
  an "off-path sorry (stay as-is)." STRATEGY.md and the updated blueprint now designate `tensorObj_restrict_iso`
  as a PRIMARY route residual. The PROGRESS.md objectives need updating to reflect the new PRIMARY route
  and the updated critical-path status of `tensorObj_restrict_iso` + `exists_tensorObj_inverse`.
  (This is a PROGRESS.md editorial note for the plan agent, not a blueprint finding.)

## Severity summary

**must-fix-this-iter:**

1. `Picard_TensorObjSubstrate.tex` — `lem:tensorobj_restrict_iso` proof contains stale "not on the
   critical path" claim that directly contradicts the PRIMARY route proof of
   `lem:islocallyinjective_whisker_of_W` and `sec:tensorobj_consistency_check`. Chapter is
   `complete: partial` due to this self-contradiction. Targeted fix: remove/update one sentence in the
   Step 3 prose of `lem:tensorobj_restrict_iso`'s proof.

2. **[HELD-LANE BATCH — no active prover blocked]** All held/paused chapters below are `complete: partial`
   because their provers have not been dispatched and some have bare `~REF` placeholders. These do not
   block any current prover dispatch but are logged per the rules. Each corresponds to a managed hold
   with an explicit rationale in PROGRESS.md:
   - `Picard_RelPicFunctor.tex` (HELD: depends on TensorObjSubstrate gate)
   - `Picard_FGAPicRepresentability.tex` (HELD: depends on A.1.c + Quot engine)
   - `Picard_QuotScheme.tex` (HELD: A.2.c-engine hold)
   - `Picard_FlatteningStratification.tex` (HELD: A.2.c-engine hold)
   - `Picard_IdentityComponent.tex` (HELD: gated A.2.c)
   - `Picard_Pic0AbelianVariety.tex` (HELD: gated A.2.c)
   - `Albanese_AlbaneseUP.tex` (HELD: gated A.2.c)
   - `Albanese_AuslanderBuchsbaum.tex` (HELD: A.4.b; bare `~REF` needs resolution when de-gated)
   - `Albanese_CodimOneExtension.tex` (HELD: A.4.a; bare `~REF` needs resolution)
   - `Albanese_Thm32RationalMapExtension.tex` (HELD: A.4.c)
   - `Albanese_CoheightBridge.tex` (HELD: independently parallelisable when de-gated)
   - `RigidityKbar.tex` (named gap; sorry body acknowledged)
   - `RiemannRoch_WeilDivisor.tex` (HELD: user-blocked signature)
   - `RiemannRoch_RRFormula.tex` (PAUSED: Route C)
   - `RiemannRoch_OCofP.tex` (PAUSED: Route C)
   - `RiemannRoch_OcOfD.tex` (PAUSED: Route C)
   - `RiemannRoch_H1Vanishing.tex` (PAUSED: Route C)
   - `RiemannRoch_RationalCurveIso.tex` (PAUSED: Route C)
   - `Jacobian.tex` (partial: Route A incomplete)

**soon:**

- `Albanese_AuslanderBuchsbaum.tex`, `Albanese_CodimOneExtension.tex`, `RiemannRoch_RRFormula.tex`,
  `RiemannRoch_OCofP.tex`, `RiemannRoch_OcOfD.tex`: bare `~REF` cross-reference placeholders need
  resolution when these chapters are de-gated/de-paused. Not blocking now.

**informational:**

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_assoc_iso` NOTE: "vestigial" framing for
  `IsLocallyTrivial` hypotheses is correct for route-(e) only; under the PRIMARY route those
  hypotheses are load-bearing for the whisker proof. Cosmetic annotation, deferrable to a later pass.

Overall verdict: `Picard_TensorObjSubstrate.tex` is `correct: true` and contains adequate PRIMARY route
proof sketches, but is `complete: partial` due to one self-contradiction (`lem:tensorobj_restrict_iso`
"off critical path" vs. the rest of the chapter saying "on critical path"). The gate does not clear
this iter; one targeted sentence fix followed by a scoped fast-path re-review should clear it. All
other must-fix findings are held/paused lanes with managed rationale in PROGRESS.md and do not block
any current prover dispatch.
