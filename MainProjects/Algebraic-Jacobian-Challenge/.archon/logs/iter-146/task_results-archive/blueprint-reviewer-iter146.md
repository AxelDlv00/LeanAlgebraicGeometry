# Blueprint Review Report

## Slug
iter146

## Iteration
146

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` / `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` proof step (p1): "by hand from the standard-smooth presentation" with no concrete sub-step recipe. The Cartier-direction ker D = B^p claim is named (Stacks Tag 07F4, "Mathlib.RingTheory.Kaehler.CotangentComplex-adjacent lemmas combined with the standard-smooth-chart hypothesis"), but the actual ring-side chain is not decomposed. A prover would have to invent the 3-5 sub-step bridge. Confirmed per directive Focus area 1(a).
- `RigidityKbar.tex` / `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` proof step (p3): appeals to a hypothesis NOT in the lemma signature. The statement assumes only "k field, B a finite-type k-algebra (or standard-smooth-of-relative-dimension n)". The proof's (p3) text reads "Since k is a field and B is the chart-side ring of a smooth proper geometrically irreducible scheme (the standing chart-side hypothesis), range(algebraMap k B) is integrally closed inside B". That additional smooth-proper-geometrically-irreducible chart-of-a-scheme hypothesis is missing from the signature, so either the signature must inflate or the proof must re-derive the integrally-closed property from the standing finite-type / standard-smooth hypothesis. Confirmed per directive Focus area 1(b).
- `AlgebraicJacobian_Cotangent_GrpObj.tex`: the iter-144 chart-algebra pivot disposition paragraph (L10–L17) is structurally inaccurate post the iter-145 EXCISE. It states "this file's remaining sorry-bodied declarations are preserved as auditable record"; in fact zero sorry-bodied bundled-route declarations remain in `Cotangent/GrpObj.lean` (verified by grepping for the five names — all return only iter-145 EXCISE-marker comments at L552–554 and L624). The chapter's body section ("Lean declarations in this file") then enumerates 11 `\item` bullets; 5 of them describe declarations that no longer exist in tree (`relativeDifferentialsPresheaf_basechange_along_proj_two`, `basechange_along_proj_two_inv_derivation`, `basechange_along_proj_two_inv`, `basechange_along_proj_two_inv_app_isIso`, `mulRight_globalises_cotangent`). Each carries a `% NOTE: iter-145 review` correction comment, but the surface prose / disposition paragraph remains misleading. Confirmed per directive Focus area 2.

### Proofs lacking detail

- `RigidityKbar.tex` / `lem:chart_algebra_df_zero_factors_through_constant_on_chart` Step 3: claims the project's `Genus.lean` H^1(C, O_C) = 0 computation is the running model for the cotangent variant via a two-chart Čech / Mayer–Vietoris reuse. `AlgebraicJacobian/Genus.lean` is 45 LOC and only DEFINES the genus; there is no in-tree two-chart MV vanishing computation to reuse. The abstract MV exactness theorem `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` (Cohomology_MayerVietoris.tex:520) does exist, but its application to the structure sheaf on a 2-chart cover has not been wired up; "the same idiom used by Genus.lean" is a misleading reference. The Step 3 prose also blurs two distinct facts (sheaf gluing + zero-on-cover ⇒ zero globally, vs. H^0(C, Omega_{C/k}^{⊕g}) = 0 on a genus-0 curve) — a prover would need explicit guidance on which is actually being invoked.
- `RigidityKbar.tex` / `lem:chart_algebra_df_zero_factors_through_constant_on_chart` Step 3 also asserts "Cover C by a finite collection of affine charts {V_1, V_2} refining to a two-chart cover (such a refinement exists for C quasi-compact over a Noetherian base, by quasi-compactness of C and the standard affine-cover lemma for a smooth proper curve)". The "2-chart affine cover of a smooth proper curve" idiom needs a concrete Mathlib citation or project-side lemma name; "standard affine-cover lemma" without a target is a fuzzy black box.
- `Jacobian.tex` proof of `thm:nonempty_jacobianWitness` Mathlib-infrastructure summary at L370–377: bullet (α) collapses Route A into "Hilbert / Quot scheme infrastructure plus FGA representability" with no explicit naming of the four committed M3 prerequisite items per `analogies/m3-route-a-refresh-iter145.md` (fppf/étale topology; Picard pre-functor; Grothendieck flattening stratification; coherent-of-finite-type). The chapter does articulate the four sub-steps A.1–A.4 earlier at L259–284, so the prerequisites ARE covered in the chapter as a whole; the summary's compression is mildly misleading but not incorrect. Per directive Focus area 3: classified as `complete: partial` borderline / `soon`.

### Lean difficulty quality

- `RigidityKbar.tex` / `lem:GrpObj_cotangent_bridge` `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent}` at L192: declaration does NOT exist in `Cotangent/GrpObj.lean` (verified by grep). The lemma is marked `\notready`, so the unresolved name is a blueprint-only statement, but the `\lean{...}` hint pointing at a non-existent declaration will mislead any prover sent to "look at the existing scaffold".
- `RigidityKbar.tex` / `lem:GrpObj_omega_free` `\lean{AlgebraicGeometry.GrpObj.omega_free}` at L1728: declaration does NOT exist in tree (verified by grep). Tagged `\notready`. Same issue as above.
- `RigidityKbar.tex` / `lem:GrpObj_omega_rank_eq_dim` `\lean{AlgebraicGeometry.GrpObj.omega_rank_eq_dim}` at L1741: declaration does NOT exist in tree (verified by grep). Tagged `\notready`. Same issue as above.
- `Cotangent/ChartAlgebra.lean` Lean targets: per directive Known issue #2 these are deliberate iter-145 `: True := sorry` placeholders. The `\lean{...}` hints (5 of them) name real Lean declarations but the signatures are `: True`; the actual prover-useful signature is on the blueprint side only. This is informational and the planner is aware — iter-146 prover lane will upgrade. Flagged as informational rather than poor-quality.

### Multi-route coverage

The directive states the project has a single committed critical-path route into M2.body-pile (Route C — chart-algebra, COMMITTED iter-144) and one off-critical-path route into M3 (Route A — Picard scheme via FGA, COMMITTED iter-144). Both are represented in the blueprint:

- Route C (chart-algebra for piece (ii)): PASS — covered by `RigidityKbar.tex` § "Iter-144 chart-algebra envelope for piece (ii)" (L99–L114) plus the new iter-145 subsection "Chart-algebra piece (ii) first-class decomposition" (L1773–L1956). Five first-class declaration blocks supply the per-sub-piece content. Lean scaffold `Cotangent/ChartAlgebra.lean` mirrors the five-block layout.
- Route A (M3 / Picard via FGA): PASS — covered by `Jacobian.tex` § "Route A — Picard scheme" (L255–L284) plus the iter-144 disposition (L370–377) and `def:positiveGenusWitness` § "Positive-genus arm" (L417–L442). The four sub-step decomposition A.1–A.4 is present; the bundled iter-144 summary is slightly compressed but adequate.

The historical-only Route B (symmetric powers + Stein) is documented for scholarly context but not gated.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single theorem + supporting prose, well-stated. No issues.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase A steps 2–4 inventory; each declaration has matching `\lean{...}` hint.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Long chapter, well-organised; every block has `\lean{...}` and a proof sketch. The Phase A pipeline is layered cleanly.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All cross-references to `Scheme.HModule'`, `Scheme.AffineCoverMVSquare`, etc. resolve. The MV abstract infrastructure exists at the named-theorem level.
  - One soft observation (not a finding): consumers like `RigidityKbar.tex`'s chart-algebra § Step 3 claim to invoke `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` on Omega_{C/k}^{⊕g}, but the MV theorem here is stated abstractly for any sheaf F. The application chain (which sheaf F, on which scheme C, with which AffineCoverMVSquare data) is the consumer's responsibility to articulate.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Forward smoothness criterion well-decomposed (4-step + nontrivial side condition). Converse rightly out-of-scope. M5/M6/M7/M8 deferred items clearly tagged.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Defines genus only; does not compute H^1 vanishings. Consumers in `RigidityKbar.tex` that cite "Genus.lean's H^1(C, O_C) = 0 computation" are referencing infrastructure that does NOT exist in Genus.lean — see RigidityKbar findings below; not a Genus.tex defect.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Per directive Focus area 3: the Mathlib-infrastructure summary at L370–377 is mildly compressed. Bullet (α) commits Route A but does not explicitly list the four iter-145 prerequisite items (fppf/étale topology; Picard pre-functor; Grothendieck flattening stratification; coherent-of-finite-type) bundled into A1/A2/A3 in `analogies/m3-route-a-refresh-iter145.md`. The earlier Route A subsection (L259–L284) does decompose A.1–A.4 honestly, so the chapter as a whole is mathematically complete; only the summary is misleading-when-read-in-isolation. Recommend a one-line expansion of bullet (α) to name the four prerequisites. Severity: `soon`.
  - The directive's Known issue #3 (stale `\notready` markers at L389/L424) is OUT OF DATE: grep finds zero `\notready` in Jacobian.tex. The iter-145 cleanup already addressed this — informational.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Self-contained scheme-level rigidity helper; clean recursion to `ext_of_isDominant_of_isSeparated'`. Use-in-project section honest about uniqueness-vs-existence.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **Must-fix MAJOR (proof correctness)**: `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` proof step (p3) appeals to a "smooth proper geometrically irreducible chart-of-a-scheme" hypothesis that is not in the lemma signature. The current statement only assumes finite-type / standard-smooth-of-relative-dimension; the integrally-closed-constants conclusion requires the chart-of-scheme hypothesis to be smuggled in. Either the signature must explicitly carry the chart-of-scheme premise (preferred — push the integrally-closed step into a separate lemma) or the proof must give a self-contained ring-theoretic argument from finite-type alone.
  - **Must-fix MAJOR (proof under-spec)**: `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` step (p1) is sketched as "by hand from the standard-smooth presentation" with only Stacks Tag 07F4 + a Mathlib filename. The 3-5 sub-step recipe (use of the standard-smooth chart presentation to derive ker D = B^p) is missing; this is the load-bearing characteristic-p step. Mathlib has no off-the-shelf lemma here, so the proof must articulate the chain explicitly. Without this, the iter-146+ KDM prover lane has no concrete target.
  - **Must-fix MAJOR (proof correctness)**: `lem:chart_algebra_df_zero_factors_through_constant_on_chart` Step 3 invokes a 2-chart Čech / Mayer–Vietoris reuse pattern citing "Genus.lean's H^1(C, O_C) = 0 computation" as the running model. There is no such computation in `Genus.lean` (45 LOC; defines genus only). The cited template doesn't exist, so the Step 3 LOC estimate (∼60–120 LOC dominant cost) is not anchored in any in-tree precedent. Either build the 2-chart MV vanishing on the structure sheaf first (and cite it honestly), or re-derive Step 3 from sheaf-gluing principles without claiming a precedent.
  - **Must-fix MAJOR (broken `\lean{...}`)**: `lem:GrpObj_cotangent_bridge` (L192) references `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent` which does not exist in tree. Tagged `\notready`, but the broken `\lean{...}` hint silently corrupts the dependency graph if a downstream tool follows it.
  - **Must-fix MAJOR (broken `\lean{...}`)**: `lem:GrpObj_omega_free` (L1728) references `AlgebraicGeometry.GrpObj.omega_free` (non-existent). Tagged `\notready`.
  - **Must-fix MAJOR (broken `\lean{...}`)**: `lem:GrpObj_omega_rank_eq_dim` (L1741) references `AlgebraicGeometry.GrpObj.omega_rank_eq_dim` (non-existent). Tagged `\notready`.
  - **Soon (proof under-spec)**: `lem:chart_algebra_df_zero_factors_through_constant_on_chart` Step 3 also asserts "Cover C by a finite collection of affine charts {V_1, V_2} refining to a two-chart cover ... by the standard affine-cover lemma for a smooth proper curve" without a Mathlib citation. The 2-chart-cover-of-smooth-proper-curve idiom is non-trivial (it depends on existence of a rational point or base extension); recommend a concrete lemma reference or a per-cover-size induction step.
  - **Soon**: `lem:chart_algebra_isPushout_of_affine_product` carries `\uses{def:relative_kaehler_presheaf}` but its statement is purely algebra-level (no relative Kähler presheaf appears in either the statement or the proof). Stray `\uses` reference; harmless but dependency-graph noise.
  - **Soon**: blueprint cites `Mathlib.RingTheory.IsPushout` as the file containing the `Algebra.IsPushout` class (L1803), but the iter-145 NOTE in `Cotangent/ChartAlgebra.lean` (L10–L15) reports this file does not exist upstream — the closest anchor is `Mathlib.RingTheory.IsTensorProduct`. Either the file did move or the blueprint name is stale; reconcile when the real ChartAlgebra signatures land iter-146+.
  - **Informational**: iter-145 `\leanok` markers on the new subsection's five statement/proof blocks may be transient — the `sync_leanok` phase between prover and review will normalise them. Per directive Known issue #2, do not report; included here only as context.
  - **Informational**: the `\notready` markers at L211 (`lem:GrpObj_cotangent_bridge`), L1730 (`lem:GrpObj_omega_free`), and L1743 (`lem:GrpObj_omega_rank_eq_dim`) correctly reflect that these declarations are blueprint-only (not in tree). However the prose around them (e.g., L297–307 references the bridge lemma as "currently `\notready`" and the rank-lemma proof Step 3 documents the bridge as "currently deferred under Replacement (B)") is consistent — only the broken `\lean{...}` hints are problematic.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **Must-fix MAJOR (manifest drift)**: iter-144 chart-algebra pivot disposition paragraph at L10–L17 claims "this file's remaining sorry-bodied declarations are preserved as auditable record of the bundled route". Verified by grep: ZERO sorry-bodied bundled-route declarations remain in `AlgebraicJacobian/Cotangent/GrpObj.lean` (the file shows only iter-145 EXCISE-marker comments at L552–554 and L624). The disposition paragraph must be rewritten to reflect actual post-iter-145 Lean state: bundled-route declarations are DELETED, not preserved as sorry-bodied scaffolding.
  - **Must-fix MAJOR (manifest drift)**: five `\item` bullets in § "Lean declarations in this file" describe declarations that no longer exist: `relativeDifferentialsPresheaf_basechange_along_proj_two`, `basechange_along_proj_two_inv_derivation`, `basechange_along_proj_two_inv`, `basechange_along_proj_two_inv_app_isIso`, `mulRight_globalises_cotangent`. Each currently carries a `% NOTE: iter-145 review` correction comment, but the user-facing prose still reads as if the declarations exist. Either delete the five bullets (cleanest), or rewrite each with an `EXCISED iter-145` disposition tag in the running text (per the recommendation queued in `proof-journal/sessions/session_145/recommendations.md` #2). Severity confirmed per directive Focus area 2.
  - **Soon**: six remaining `\item` bullets (`cotangentSpaceAtIdentity`, `cotangentSpaceAtIdentity_eq_extendScalars`, `cotangentSpaceAtIdentity_finrank_eq`, `shearMulRight`, `schemeHomRingCompatibility`, `relativeDifferentialsPresheaf_restrict_along_identity_section`) all resolve to in-tree declarations correctly. These can remain as the chapter's content once the five stale bullets are removed.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three protected declarations cleanly projection-based; remarks separate classical content from formalised path. No issues.

## Cross-chapter notes

- `RigidityKbar.tex` § chart-algebra Step 3 cites "Genus.lean's H^1(C, O_C) = 0 computation" as a running model — `Genus.lean` (and `Genus.tex`) only defines the genus and does not compute any vanishing. This is a forward-dependency: the abstract MV theorem in `Cohomology_MayerVietoris.tex` is present (label `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`), but the in-tree application to the structure sheaf with a 2-chart cover does not yet exist. Recommend either: (a) building a Genus chapter "vanishing of H^1 on a genus-0 curve via 2-chart MV" before the iter-146 prover lane fires on the chart-algebra (β-core) helper, or (b) re-articulating Step 3 so it does not depend on a non-existent precedent.
- `Cotangent/ChartAlgebra.lean` is at the non-standard blueprint slug — its 5 `\lean{...}`-tagged blocks live as a subsection in `RigidityKbar.tex` rather than in an `AlgebraicJacobian_Cotangent_ChartAlgebra.tex` chapter. Per directive Known issue #1 the plan agent is aware. The routing is pedagogically reasonable (the chart-algebra envelope sits next to its consumer `thm:rigidity_over_kbar`), so reporting informationally only.
- The five EXCISED-iter-145 declarations are referenced from both `RigidityKbar.tex` (multiple `\cref`s and `\uses` entries in piece-(i.b) proof blocks, plus the `\lean{...}` hints at L361, L473, L1473, L1558, L1629) and `AlgebraicJacobian_Cotangent_GrpObj.tex` (the 5 stale `\item` bullets). The `RigidityKbar.tex` blocks have iter-144 DESCOPED disposition paragraphs that flag them as auditable-record-only; the `AlgebraicJacobian_Cotangent_GrpObj.tex` pointer chapter does NOT yet have updated prose. The drift is concentrated in the pointer chapter (already classified must-fix above); the `RigidityKbar.tex` blocks still have valid `\lean{...}` hints that point at declarations that are now DELETED, not just sorry-bodied — meaning `lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_basechange_proj_inv_derivation`, `lem:GrpObj_omega_basechange_proj_inv`, `lem:GrpObj_basechange_along_proj_two_inv_app_isIso`, and `lem:GrpObj_mulRight_globalises` all have broken `\lean{...}` hints just like the three flagged above.

After cross-checking the RigidityKbar.tex piece (i.b) blocks against the Lean file, these blocks also have broken `\lean{...}` hints to add to the must-fix list:
- `lem:GrpObj_omega_basechange_proj` (L473) — `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}` — EXCISED iter-145.
- `lem:GrpObj_omega_basechange_proj_inv_derivation` (L1473) — EXCISED.
- `lem:GrpObj_omega_basechange_proj_inv` (L1558) — EXCISED.
- `lem:GrpObj_basechange_along_proj_two_inv_app_isIso` (L1629) — EXCISED.
- `lem:GrpObj_mulRight_globalises` (L361) — EXCISED.

Each is currently un-marked (no `\notready`) and the surrounding NOTE blocks describe iter-144 DESCOPED disposition. The blueprint prose presents them as if the named declarations still exist in tree; in fact they were deleted iter-145.

## Strategy-modifying findings (if any)

None. The two open routes (chart-algebra for M2.body-pile; Route A for M3 / positive-genus) remain coherent with `STRATEGY.md`'s iter-144 commitments; the iter-146 prover lane firing on `Cotangent/ChartAlgebra.lean` `algebra_isPushout_of_affine_product` is well-targeted modulo the under-spec / hidden-hypothesis findings above. No definition contradicts its references in a way that requires a strategy modification.

## Severity summary

- **must-fix-this-iter** —
  - `RigidityKbar.tex`: (a) `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` step (p1) under-specified char-p decomposition (load-bearing for iter-146+ KDM ring-side prover lane); (b) same lemma step (p3) appeals to "chart of smooth proper geom-irr scheme" hypothesis NOT in the signature (signature-vs-proof mismatch); (c) `lem:chart_algebra_df_zero_factors_through_constant_on_chart` Step 3 invokes "Genus.lean H^1 = 0 computation" that does not exist; (d–k) eight broken `\lean{...}` hints to non-existent or EXCISED declarations (`lem:GrpObj_cotangent_bridge`, `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`, `lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_basechange_proj_inv_derivation`, `lem:GrpObj_omega_basechange_proj_inv`, `lem:GrpObj_basechange_along_proj_two_inv_app_isIso`, `lem:GrpObj_mulRight_globalises`). Chapter is `complete: partial` AND `correct: partial`.
  - `AlgebraicJacobian_Cotangent_GrpObj.tex`: iter-144 disposition paragraph + 5 stale `\item` bullets describing declarations no longer in tree. Chapter is `complete: partial` AND `correct: partial`.

  Per the HARD GATE: any `.lean` file F whose blueprint chapter has `complete: partial` OR `correct: partial` (OR whose blueprint depends on a broken `\uses{}` label) must be deferred from this iter's prover objectives, and a blueprint-writing subagent must be dispatched to address the must-fix items. This applies to:
  - `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` — blueprint chapter `RigidityKbar.tex` (under iter-145 slug-mapping convention) has correctness issues in the chart-algebra subsection (load-bearing for the iter-146 prover lane on `algebra_isPushout_of_affine_product`). DEFER iter-146 prover lane on ChartAlgebra.lean until the writer pass on RigidityKbar.tex § chart-algebra resolves at least findings (a)+(b)+(c) above.
  - `AlgebraicJacobian/Cotangent/GrpObj.lean` — blueprint pointer chapter has manifest drift. The chapter is purely pointer prose with no active prover targets pointing AT it this iter, but the HARD GATE still triggers: blueprint-writer dispatch for `AlgebraicJacobian_Cotangent_GrpObj.tex` this iter.

- **soon** —
  - `Jacobian.tex` L370–377 summary compression of Route A prerequisites (one-line expansion to enumerate the four A1/A2/A3 items).
  - `RigidityKbar.tex` § chart-algebra Step 3 "2-chart-cover of a smooth proper curve" reference needs a concrete Mathlib citation or project-side lemma name.
  - `RigidityKbar.tex` `lem:chart_algebra_isPushout_of_affine_product` stray `\uses{def:relative_kaehler_presheaf}` (the algebra-level pushout statement does not consume the Kähler presheaf).
  - `RigidityKbar.tex` chart-algebra envelope cites `Mathlib.RingTheory.IsPushout` as the home of `Algebra.IsPushout`; the iter-145 NOTE in `Cotangent/ChartAlgebra.lean` reports the closest anchor is `Mathlib.RingTheory.IsTensorProduct`. Reconcile when the real iter-146+ signatures land.

- **informational** —
  - Directive Known issue #3 (stale `\notready` at Jacobian.tex L389/L424) is outdated: grep finds zero `\notready` in Jacobian.tex.
  - `Cotangent/ChartAlgebra.lean` ↔ `RigidityKbar.tex` non-standard slug mapping (directive Known issue #1) — the iter-145 routing of chart-algebra-piece-(ii) blocks into a subsection of `RigidityKbar.tex` instead of an own-chapter is pedagogically clean and not a defect.
  - `ChartAlgebra.lean` five Lean targets are `: True := sorry` placeholders by design (directive Known issue #2 + iter-146 prover lane upgrades signatures).
  - The `\notready` markers at RigidityKbar.tex L211, L1730, L1743 correctly reflect blueprint-only status of the three named declarations.

Overall verdict: two chapters (`RigidityKbar.tex`, `AlgebraicJacobian_Cotangent_GrpObj.tex`) require blueprint-writer dispatch this iter; the iter-146 prover lane on `Cotangent/ChartAlgebra.lean` should be deferred until the chart-algebra § correctness / hidden-hypothesis / broken-`\lean{...}` issues are resolved.
