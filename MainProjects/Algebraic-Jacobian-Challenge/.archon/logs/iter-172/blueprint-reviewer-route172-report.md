# Blueprint Review Report

## Slug
route172

## Iteration
172

## Top-level summaries

### Incomplete parts

- `AbelianVarietyRigidity.tex` / new substantive sub-lemma `mvPolyToHomogeneousLocalizationAway_surjective` — Lean L372 of `AlgebraicJacobian/Genus0BaseObjects.lean` is a substantive `sorry` (project-side, not Mathlib) that the iter-171 `aux_left` cancel-surjective rewrite chains through. It is **not pinned** by any `\lean{...}` block in the chapter; only a free-text reference inside the `% NOTE (iter-171 refresh)` block at L1094 mentions it. The `blueprint-writer surjective-pin` directive landed THIS iter (L1093 of `logs/iter-172/blueprint-writer-surjective-pin-directive.md`) but no `*-report.md` is on disk yet; the chapter as currently on disk still lacks the pin.
- `blueprint/src/chapters/Picard_RelativeSpec.tex` — **chapter file does not exist on disk** (checked: `ls` returns `No such file or directory`; `content.tex` does not `\input` it). `blueprint-writer route-a1-retry2` was dispatched at 13:55 this iter (directive at `logs/iter-172/blueprint-writer-route-a1-retry2-directive.md`); the retry-2 report has not yet landed. Gated on writer landing this iter.

### Lean difficulty quality

- `AbelianVarietyRigidity.tex` / `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective}` (when the writer adds it) — heads-up to the writer: this lemma is `private` in `AlgebraicJacobian/Genus0BaseObjects.lean` (L372). Pinning a `private` lemma is supported by the blueprint-doctor's `\lean{...}` lookup, but the prover lane treating G0BO must remain inside the file. The directive correctly anticipates this (the substantive `sorry` is internal to G0BO); no action by reviewer, just note for the writer's pin.

### Multi-route coverage

- Route C — Milne §I.3 genus-0 rigidity (committed, char-free): **PASS** — covered by `AbelianVarietyRigidity.tex` headline `thm:rigidity_genus0_curve_to_AV`; chain `thm:rigidity_lemma` → `lem:hom_additivity_over_product` → `prop:morphism_P1_to_AV_constant` → `prop:genusZero_curve_iso_P1` → headline is present and the iter-164 𝔾ₘ-scaling shortcut is faithfully represented (`rmk:base_case_fourth_route`, `def:gaTranslationP1`, `lem:gmScaling_fixes_zero`).
- Route A — Picard scheme via FGA (committed for positive-genus object): **PARTIAL** — `Jacobian.tex` § "Route A" decomposes A.1–A.4 at section level with per-sub-phase LOC/iter budgets; but no per-file sub-chapters exist for A.1.b/A.1.c, A.2, A.3, A.4. `Picard_RelativeSpec.tex` (A.1.a) is in-flight via writer this iter. STRATEGY.md user-hint-3 explicitly requests further per-file decomposition.
- RR bridge (Hartshorne IV.1.3.5 four-sub-phase route): **PARTIAL** — RR.1 `RiemannRoch_WeilDivisor.tex` is present and HARD GATE CLEARS; RR.2/RR.3/RR.4 have no chapters.
- Fallback route (a) — differential/Serre-duality: **PASS** — covered by `RigidityKbar.tex` as off-critical-path artifact, gated named gap.

### Citation discipline

- `RiemannRoch_WeilDivisor.tex` — all 9 pinned declarations carry `% SOURCE:` (with `(read from references/hartshorne-algebraic-geometry.pdf, PDF page N)` parenthetical, file VERIFIED to exist), `% SOURCE QUOTE:` verbatim from Hartshorne II.6, and visible `\textit{Source: Hartshorne, II.6, ...}`. The `% SOURCE QUOTE PROOF:` for `thm:principal_deg_zero` (L332–338) is verbatim Hartshorne. Stacks tags (02RW, 02ME, 0BE0, 0BE3) are correctly marked as "tag-level pointer, not verbatim-quoted" in the chapter preamble (L8–11) — no fabrication risk. **CLEAN.**
- `AbelianVarietyRigidity.tex` — `lem:hom_additivity_over_product`, `lem:av_regular_map_is_hom`, `lem:rational_map_to_av_extends`, `lem:hom_Ga_to_av_trivial`, `lem:hom_from_Ga_trivial`, `prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1` all carry the four-part Milne / Hartshorne citation discipline (`% SOURCE:` with file parenthetical + `% SOURCE QUOTE:` verbatim + visible `\textit{Source: ...}`). `thm:rigidity_lemma` carries the Mumford Ch.II §4 verbatim quote. No paraphrasing detected. **CLEAN.**
- Note on `lem:hom_Ga_to_av_trivial` (L1252–54): the chapter declares "this host lacks a PDF renderer (pdftoppm) so the quotes were NOT re-rendered from references/abelian-varieties.pdf this session; they are reproduced from the verified in-tree copy" — this is a self-flagged honest reproduction from a prior verified pass, not fabrication, and is acceptable.

## Unstarted-phase blueprint proposals

The STRATEGY.md `## Phases & estimations` table lists seven phases with zero blueprint coverage (apart from A.1.a in-flight via `Picard_RelativeSpec.tex` retry-2). Per the descriptor, each gets a concrete outline below. All are must-act-this-iter — silently leaving them unwritten costs deferred parallelism the project cannot afford given the ~33–54 iter Route A budget.

### Proposed chapter: `blueprint/src/chapters/Picard_LineBundlePullback.tex`

**Covers**: `AlgebraicJacobian/Picard/LineBundlePullback.lean` (planned, per STRATEGY.md L81)
**Strategy phase**: Route A.1.b — line-bundle pullback on `C ×_k T`
**Why now**: blueprint-side parallel-startable per STRATEGY row 1 ("first prover lane opens once a sub-chapter clears HARD GATE"). With A.1.a (RelativeSpec) writer in flight, A.1.b is the next prover-ready entry; writing this chapter THIS iter unblocks the iter-173 file-skeleton Lane B continuation without further delay.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:linebundle_pullback_along_proj}` — Pullback of a line bundle along the second projection `C × T → T` (the `π^* Pic T` summand of the relative Picard functor). `\lean{AlgebraicGeometry.Picard.linebundle_pullback_pi}` [expected]. Source: Hartshorne III.4 / Stacks 01CN.
2. `\definition` `\label{def:linebundle_isomorphism_class}` — The set of isomorphism classes of line bundles on `C_T`. `\lean{AlgebraicGeometry.Picard.LineBundleClass}` [expected]. Source: standard (Mathlib has `CommRing.Pic` but no scheme-level analogue — Archon-original for schemes).
3. `\definition` `\label{def:relative_pic_set}` — `Pic^♯_{C/k}(T) := Pic(C_T) / π^* Pic(T)` as the SET-valued relative Picard functor. `\lean{AlgebraicGeometry.Picard.relPicSet}` [expected]. Source: Hartshorne III.4 / Kleiman §2.
4. `\lemma` `\label{lem:relpic_set_natural}` — Functoriality of `T ↦ Pic^♯_{C/k}(T)` in `T`. `\lean{AlgebraicGeometry.Picard.relPicSet_functorial}` [expected]. Source: Kleiman §2.
5. `\lemma` `\label{lem:pullback_pi_kernel}` — The kernel of `Pic(C_T) → Pic^♯_{C/k}(T)` is exactly `π^* Pic(T)`. `\lean{AlgebraicGeometry.Picard.pullback_pi_kernel}` [expected]. Source: Kleiman §2.

**`\uses` skeleton**:
- `def:relative_pic_set` uses `def:linebundle_pullback_along_proj`, `def:linebundle_isomorphism_class`
- `lem:relpic_set_natural` uses `def:relative_pic_set`
- `lem:pullback_pi_kernel` uses `def:relative_pic_set`, `def:linebundle_pullback_along_proj`

**Main theorem proof strategy**: The chapter is foundational (definitions + functoriality), no headline theorem. The substantive content is establishing the quotient structure of `Pic^♯_{C/k}(T)` as a set with natural functoriality. Mathlib infrastructure: `Mathlib.AlgebraicGeometry.Pullbacks` for the base-change `C ×_k T`; the project's own `Mathlib.AlgebraicGeometry.Modules.Pullback` for module-level pullback. The `Pic(C_T)` data type is constructed as a quotient of locally-free-rank-1 `Mathlib.CategoryTheory.Sheaf` instances.

**References for writer**:
- `references/kleiman-picard-src/kleiman-picard.tex`, §2 (the relative Picard functor) — primary source, already cited by `Jacobian.tex` L29 verbatim block.
- `references/hartshorne-algebraic-geometry.pdf`, III.4 (definition of `Pic`) — anchors the quotient definition.
- Mathlib snapshot `b80f227`: `Mathlib/CategoryTheory/Sites/Pullback.lean` (the present `\to` infrastructure cited at `Jacobian.tex` L409).

**Subphase choices exposed**:
- Set-valued vs group-valued formulation: STRATEGY phase row 1 says "set-valued formulation suffices for representability" (per `Jacobian.tex` L325); Kleiman's §2 carries the group-functor refinement. **Recommendation: set-valued for this sub-chapter, defer the group-functor refinement to A.1.c (`Picard_RelPicFunctor.tex`)**.
- Mathlib `CommRing.Pic` reuse vs Archon-original: STRATEGY says no scheme-level analogue exists. **Recommendation: Archon-original; chapter prose should call this out, citing `analogies/rrbridge-survey.md` precedent.**

### Proposed chapter: `blueprint/src/chapters/Picard_RelPicFunctor.tex`

**Covers**: `AlgebraicJacobian/Picard/RelPicFunctor.lean` (planned, per STRATEGY.md L81)
**Strategy phase**: Route A.1.c — Relative Picard functor (group-valued, with étale sheafification)
**Why now**: completes the A.1 trilogy (A.1.a RelativeSpec + A.1.b LineBundlePullback + this); blueprint-decomposable in parallel with A.2/A.3/A.4 writers, no prover gating.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:relpic_group_functor}` — The relative Picard *group*-valued functor `Pic^♯_{C/k}` (refinement of `def:relative_pic_set` from `Picard_LineBundlePullback.tex` with the canonical group structure). `\lean{AlgebraicGeometry.Picard.relPicFunctor}` [expected]. Source: Kleiman §2.
2. `\theorem` `\label{thm:relpic_etale_sheaf}` — Étale-sheafification of `Pic^♯_{C/k}` exists when `k` is not algebraically closed (Mathlib étale-sheafification machinery, verified present in `Jacobian.tex` L372). `\lean{AlgebraicGeometry.Picard.relPicSheafified}` [expected]. Source: Kleiman §2 + Mathlib `Mathlib/CategoryTheory/Sites/Sheafification.lean` family.
3. `\lemma` `\label{lem:relpic_sheaf_equals_functor_under_rational_point}` — When `C(k) ≠ ∅`, the étale-sheafification equals the un-sheafified functor (no Galois descent needed). `\lean{AlgebraicGeometry.Picard.relPicSheafified_unsheafified}` [expected]. Source: Kleiman §2 (Galois-descent triviality under rational-point hypothesis).
4. `\definition` `\label{def:pic_degree_map}` — Degree map `Pic^♯_{C/k} → ℤ` defined via the locally-constant pushforward of the determinant. `\lean{AlgebraicGeometry.Picard.degreeMap}` [expected]. Source: Hartshorne IV.1 / Stacks 0BE0.
5. `\lemma` `\label{lem:pic_degree_locally_constant}` — The degree map is locally constant in the moduli parameter `T`. `\lean{AlgebraicGeometry.Picard.degreeMap_locallyConstant}` [expected]. Source: Stacks 02KH (cohomology-and-base-change).

**`\uses` skeleton**:
- `thm:relpic_etale_sheaf` uses `def:relpic_group_functor`
- `lem:relpic_sheaf_equals_functor_under_rational_point` uses `thm:relpic_etale_sheaf`
- `def:pic_degree_map` uses `def:relpic_group_functor`
- `lem:pic_degree_locally_constant` uses `def:pic_degree_map`

**Main theorem proof strategy**: The two substantive theorems are `thm:relpic_etale_sheaf` (a thin re-export of Mathlib's general sheafification once the value category and Grothendieck topology are pinned correctly — universe-pinning work mirroring `Cohomology_StructureSheafAb.tex` Theorem 1.1) and `lem:pic_degree_locally_constant` (which derives local constancy from Stacks 02KH cohomology-and-base-change for the locally-free rank-1 push-forward).

**References for writer**:
- `references/kleiman-picard-src/kleiman-picard.tex`, §2 + §3 (functor + sheafification) — primary source.
- `references/stacks-coherent.md` → §02KH (cohomology-and-base-change, the load-bearing Stacks tag for the degree-map local-constancy).
- Mathlib snapshot `b80f227`: `Mathlib/CategoryTheory/Sites/Sheafification.lean` and `Mathlib/AlgebraicGeometry/Sites/Etale.lean` (verified present, cited at `Jacobian.tex` L372–374).

**Subphase choices exposed**:
- Sheafify in fppf vs étale topology: Kleiman §2 sheafifies in fppf; `Jacobian.tex` L327 says étale suffices when `C` has a `k`-rational point. **Recommendation: étale-sheafification, with a remark referring to the fppf version for the no-rational-point case.**

### Proposed chapter: `blueprint/src/chapters/Picard_FGA_Representability.tex`

**Covers**: `AlgebraicJacobian/Picard/FGARepresentability.lean` (planned, NEW; STRATEGY row 2)
**Strategy phase**: Route A.2 — FGA representability of `Pic_{C/k}` via Hilbert/Quot
**Why now**: A.2 is the dominant Route A block (`~2200–3000` LOC / 15–25 iters per STRATEGY), the riskiest sub-build, and "project-fatal if it stalls" (STRATEGY L23). Its **flattening-stratification sub-build is independently startable** per STRATEGY L23; that sub-build is the only Route A.2 entry parallel-startable with the current iter-172 lanes. Writing the blueprint now decouples the planner from a single prover dependency.

This phase is large enough that one chapter is insufficient. **Propose splitting into TWO chapters**:

#### Sub-chapter 1: `Picard_FGA_FlatteningStratification.tex`

**Key declarations** (in dependency order):
1. `\definition` `\label{def:flattening_stratification}` — Flattening stratification of a coherent sheaf on a Noetherian scheme. `\lean{AlgebraicGeometry.Quot.flatteningStratification}` [expected]. Source: Nitsure §4 (`references/nitsure-hilbert-quot.md`).
2. `\theorem` `\label{thm:generic_flatness}` — Generic flatness: a coherent sheaf on a Noetherian integral scheme is flat over the base on a dense open. `\lean{AlgebraicGeometry.Quot.generic_flatness}` [expected]. Source: Nitsure §4 / Stacks 052A.
3. `\theorem` `\label{thm:flattening_stratification_exists}` — Flattening stratification exists: there is a locally closed stratification trivialising the Hilbert polynomial. `\lean{AlgebraicGeometry.Quot.flatteningStratification_exists}` [expected]. Source: Nitsure §4.

**Main theorem proof strategy**: Generic flatness (`thm:generic_flatness`) by Noetherian induction: pass to the generic point, where the sheaf becomes a finite vector space over the function field; descend to a dense open by spreading-out. Flattening stratification (`thm:flattening_stratification_exists`) by iterating generic flatness on the complement, producing the locally-closed stratification by Hilbert polynomial.

**References for writer**:
- `references/nitsure-hilbert-quot.md` → `references/nitsure-hilbert-quot.pdf`, §4 — primary source, already cited at `Jacobian.tex` L342, L368.
- Stacks tag 052A (`references/stacks-coherent.md` — verify presence).
- Mathlib snapshot `b80f227`: `Mathlib/RingTheory/Flat/Basic.lean` (present); `Mathlib/AlgebraicGeometry/Morphisms/Flat.lean` (present, used by C.2.f at `Jacobian.tex` L502).

#### Sub-chapter 2: `Picard_FGA_QuotConstruction.tex`

**Key declarations** (in dependency order):
1. `\definition` `\label{def:quot_functor}` — The Quot functor `Quot_{ℰ/X/S}^{P}` parametrising flat quotients of a coherent sheaf with Hilbert polynomial `P`. `\lean{AlgebraicGeometry.Quot.QuotFunctor}` [expected]. Source: Nitsure §5.
2. `\theorem` `\label{thm:quot_representable}` — The Quot functor is representable by a projective `S`-scheme. `\lean{AlgebraicGeometry.Quot.QuotFunctor.representable}` [expected]. Source: Nitsure §5 (the construction proper).
3. `\definition` `\label{def:hilbert_functor}` — Hilbert functor `Hilb_{X/S}^{P}` as `Quot_{O_X/X/S}^{P}`. `\lean{AlgebraicGeometry.Hilb.HilbertFunctor}` [expected]. Source: Nitsure §5 + Grothendieck FGA 221.
4. `\theorem` `\label{thm:hilb_representable}` — Hilbert functor is representable (corollary of Quot via `ℰ = O_X`). `\lean{AlgebraicGeometry.Hilb.representable}` [expected]. Source: Nitsure §5.
5. `\theorem` `\label{thm:fga_pic_representable}` — `Pic_{C/k}` is representable when `C` is a smooth proper geometrically connected curve. `\lean{AlgebraicGeometry.Picard.fga_representable}` [expected]. Source: Grothendieck FGA 232; `references/kleiman-picard-src/kleiman-picard.tex` §4.

**`\uses` skeleton across both sub-chapters**:
- `thm:flattening_stratification_exists` uses `thm:generic_flatness`, `def:flattening_stratification`
- `thm:quot_representable` uses `thm:flattening_stratification_exists`, `def:quot_functor`
- `def:hilbert_functor` uses `def:quot_functor`
- `thm:hilb_representable` uses `thm:quot_representable`, `def:hilbert_functor`
- `thm:fga_pic_representable` uses `thm:hilb_representable`, `lem:pic_degree_locally_constant` (from A.1.c)

**Main theorem proof strategy for `thm:quot_representable`**: Nitsure §5 constructs `Quot` as a closed subscheme of a Grassmannian via the universal-quotient construction: a flat quotient of high enough Castelnuovo–Mumford regularity is determined by its image in a fixed Grassmannian; the flatness + Hilbert polynomial conditions cut out a closed subscheme. The proof needs (i) cohomology-and-base-change (Stacks 02KH) to control regularity uniformly in the family parameter, and (ii) Grassmannian construction (Mathlib snapshot has the projective space, the Grassmannian needs in-tree build).

**References for writer**:
- `references/nitsure-hilbert-quot.md` / `.pdf`, §5 — primary; the construction proper.
- `references/kleiman-picard-src/kleiman-picard.tex` §4 — for the `Pic` representability conclusion.
- `references/stacks-coherent.md` → 02KH (cohomology-and-base-change), 092X (Grassmannian).
- Note: writer must verify Mathlib has no `HilbertScheme`/`QuotScheme` already; STRATEGY L23 + `Jacobian.tex` L410–412 explicitly mark both as absent.

**Subphase choices exposed (cross-cutting)**:
- Quot via Castelnuovo–Mumford regularity (Nitsure) vs Quot via formal deformation theory (Artin): Nitsure is concrete and aligned with the in-tree references. **Recommendation: Nitsure §5.**

### Proposed chapter: `blueprint/src/chapters/Picard_Pic0_IdentityComponent.tex`

**Covers**: `AlgebraicJacobian/Picard/Pic0IdentityComponent.lean` (planned)
**Strategy phase**: Route A.3 — `Pic⁰` identity component + degree map
**Why now**: blueprint-side parallel-startable (STRATEGY L24: "prover-side gated on A.2 but blueprint-decomposable in parallel"); writing it now exposes the A.3 declarations the planner needs to schedule.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:identity_component_group_scheme}` — Identity component `G⁰` of a group scheme `G` locally of finite type over a field. `\lean{AlgebraicGeometry.GroupScheme.identityComponent}` [expected]. Source: SGA 3 / Kleiman §3 Lemma `agps` (already quoted verbatim at `Jacobian.tex` L207–212).
2. `\theorem` `\label{thm:identity_component_open_closed}` — `G⁰ ⊆ G` is an open-closed group subscheme of finite type. `\lean{AlgebraicGeometry.GroupScheme.identityComponent_isOpenClosedImmersion}` [expected]. Source: Kleiman §3 Lemma `agps` (verbatim quote at `Jacobian.tex` L207–212).
3. `\theorem` `\label{thm:identity_component_geometrically_irreducible}` — `G⁰` is geometrically irreducible. `\lean{AlgebraicGeometry.GroupScheme.identityComponent_geomIrred}` [expected]. Source: Kleiman §3 Lemma `agps`.
4. `\definition` `\label{def:pic0}` — `Pic⁰_{C/k} := (Pic_{C/k})⁰`. `\lean{AlgebraicGeometry.Picard.Pic0}` [expected]. Source: Kleiman §5 Proposition `pic0` (verbatim quote at `Jacobian.tex` L213–219).
5. `\theorem` `\label{thm:pic0_smooth_proper}` — `Pic⁰_{C/k}` is smooth, proper, geometrically irreducible of dimension `g(C)`. `\lean{AlgebraicGeometry.Picard.Pic0.smooth_proper_dim_g}` [expected]. Source: Kleiman §5 Cor `cor:sm` + Cor `cor:ch0` + Prp `prp:P0` (verbatim quotes at `Jacobian.tex` L150–164, L182–189).
6. `\definition` `\label{def:locally_constant_pushforward_degree}` — Locally-constant pushforward yielding the degree map `Pic_{C/k} → ℤ_k`. `\lean{AlgebraicGeometry.Picard.degreeLocallyConstant}` [expected]. Source: Stacks 02KH / Hartshorne III.12.

**`\uses` skeleton**:
- `thm:identity_component_open_closed` uses `def:identity_component_group_scheme`
- `thm:identity_component_geometrically_irreducible` uses `def:identity_component_group_scheme`
- `def:pic0` uses `def:identity_component_group_scheme`, `thm:fga_pic_representable` (A.2)
- `thm:pic0_smooth_proper` uses `def:pic0`, `thm:identity_component_geometrically_irreducible`, `thm:identity_component_open_closed`
- `def:locally_constant_pushforward_degree` uses `def:pic0`, `thm:fga_pic_representable`

**Main theorem proof strategy**: `thm:identity_component_open_closed` follows from `Mathlib/AlgebraicGeometry/Group/Smooth.lean` (verified present, cited STRATEGY L24) once the identity-component construction is built (Mathlib gap `GroupScheme.IdentityComponent`). `thm:pic0_smooth_proper` chains: smoothness of `Pic⁰` from `Mathlib/AlgebraicGeometry/Group/Smooth.lean` (a smooth group scheme has smooth identity component — needs the tangent-space deformation theory cited at `Jacobian.tex` L173); properness from the closedness of `Pic⁰` inside the proper `Pic` (Kleiman Prp `prp:P0`); dimension `g(C)` from the cohomology of the structure sheaf (already developed in `Cohomology_*.tex`).

**References for writer**:
- `references/kleiman-picard-src/kleiman-picard.tex` §3 (Lemma `agps`), §5 (Prp `pic0`, Cor `cor:sm`, Cor `cor:ch0`, Prp `prp:P0`) — already quoted verbatim in `Jacobian.tex`; the writer should re-quote in this chapter's blocks rather than relying on cross-chapter inheritance.
- `references/stacks-coherent.md` → 02KH (cohomology-and-base-change for the locally-constant pushforward).
- Mathlib `Mathlib/AlgebraicGeometry/Group/{Smooth,Abelian}.lean` (verified present, cited STRATEGY L24).

**Subphase choices exposed**:
- Locally-constant pushforward via SGA 4 vs via `Mathlib/CategoryTheory/Sites/LocallyInjective` style: SGA 4 is the textbook; the Mathlib idiom needs research. **Recommendation: name SGA 4 in prose; flag the Mathlib idiom choice as a writer-side TODO for the file-skeleton lane.**

### Proposed chapter: `blueprint/src/chapters/Picard_AlbaneseUP.tex`

**Covers**: `AlgebraicJacobian/Picard/AlbaneseUP.lean` (planned)
**Strategy phase**: Route A.4 — Albanese universal property of `Pic⁰`
**Why now**: A.4 carries the **open strategic question** flagged in STRATEGY row 4 about the Thm 3.2 dependency (Picard-functoriality bypass vs Auslander–Buchsbaum); writing this blueprint NOW exposes the strategic choice in concrete declaration form, so the planner can resolve the bypass question without further latency.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:albanese_morphism_construction}` — Abel–Jacobi morphism `α_P : C → Pic⁰_{C/k}`, `Q ↦ [O_C(Q - P)]`. `\lean{AlgebraicGeometry.Picard.AbelJacobi.alpha}` [expected]. Source: Milne III.6 / Hartshorne III.4.
2. `\theorem` `\label{thm:albanese_universal_via_picard_functoriality}` — **Picard-functoriality bypass route**: Albanese UP of `Pic⁰` proved via Picard-functor naturality + seesaw, **without** Thm 3.2. `\lean{AlgebraicGeometry.Picard.Pic0.albaneseUP}` [expected]. Source: Milne III.6 Proposition 6.1/6.4.
3. `\theorem` `\label{thm:albanese_universal_via_thm32}` — **Backup route**: Albanese UP via Milne Thm 3.2 (rational-map extension) + the in-tree-proven Cor 1.2/Cor 1.5. Only consumed if `thm:albanese_universal_via_picard_functoriality` is found to need Thm 3.2 transitively. `\lean{AlgebraicGeometry.Picard.Pic0.albaneseUP_via_thm32}` [expected]. Source: Milne III.6.
4. `\lemma` `\label{lem:seesaw_principle}` — Seesaw / square principle for `Pic⁰`. `\lean{AlgebraicGeometry.Picard.Pic0.seesaw}` [expected]. Source: Milne III §3, Mumford "Abelian Varieties" §II.5.

**`\uses` skeleton**:
- `def:albanese_morphism_construction` uses `def:pic0`, `def:linebundle_pullback_along_proj` (from A.1.b)
- `thm:albanese_universal_via_picard_functoriality` uses `def:albanese_morphism_construction`, `lem:seesaw_principle`, `lem:hom_additivity_over_product` (from AVR, in-tree axiom-clean)
- `thm:albanese_universal_via_thm32` uses `def:albanese_morphism_construction`, `lem:rational_map_to_av_extends` (from AVR), `lem:av_regular_map_is_hom` (from AVR)

**Main theorem proof strategy**: Two routes presented in parallel. **Route (i) — Picard-functoriality bypass.** Given `f : C → A` with `f(P) = 0`, pull back the Poincaré line bundle on `Pic⁰(C) × C` along `f × id` to get a line bundle on `A × C`, then re-interpret as a morphism `A^∨ → Pic⁰(C)`, then dualise. The seesaw principle controls the trivialisation along `{P} × A`. Crucially, this uses Picard-functoriality on **morphisms of representable functors**, not rational-map extension. **Route (ii) — Thm 3.2 backup.** Standard Milne III.6 argument: rational-map extension produces the inverse `g : Pic⁰(C) → A`. Uses `lem:rational_map_to_av_extends` (Milne Thm 3.2, currently a named gap in `AbelianVarietyRigidity.tex`) + the (proven) Cor 1.2 / Cor 1.5.

**References for writer**:
- `references/abelian-varieties.pdf` (Milne), §I.3 Thm 3.2/Cor 1.5, §III.6 Prp 6.1/6.4 — already partially cited in `AbelianVarietyRigidity.tex`.
- `references/kleiman-picard-src/kleiman-picard.tex`, Remark `rmk:Alb` (verbatim quoted at `Jacobian.tex` L30–37) and §5/§6 for the seesaw + Picard-functoriality content.
- `Mumford, Abelian Varieties` (paywalled, not bundled): the seesaw principle is in `references/mumford-abelian-varieties.pdf` (already in tree, used by AVR). Writer should pull the seesaw § from there.

**Subphase choices exposed**:
- Picard-functoriality bypass vs Thm-3.2 route: **the open strategic question of STRATEGY L25 + "Open strategic questions"**. STRATEGY says: "the Thm 3.2 bypass claim is the load-bearing uncertainty". **Recommendation: write BOTH route theorems in the chapter as parallel declarations**, with a `\remark` block calling out the choice and a per-route prose paragraph. The planner can then decide which proves first; the loser is demoted to a remark.

### Proposed chapter: `blueprint/src/chapters/RiemannRoch_RRFormula.tex`

**Covers**: `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (planned)
**Strategy phase**: RR.2 — Riemann–Roch dimension formula on a smooth proper curve
**Why now**: RR.2 is serial after RR.1 (prover-side); but the **blueprint** is parallel-startable now that RR.1 has cleared the HARD GATE. Writing it concurrently with the RR.1 prover lane saves the next iter's writer dispatch latency.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:O_C_of_D}` — Line bundle `O_C(D)` associated to a Weil divisor `D`. `\lean{AlgebraicGeometry.Scheme.WeilDivisor.lineBundle}` [expected]. Source: Hartshorne II.6 Proposition 6.13.
2. `\definition` `\label{def:l_D}` — `ℓ(D) := \dim_k H^0(C, O_C(D))`. `\lean{AlgebraicGeometry.RiemannRoch.l}` [expected]. Source: Hartshorne IV.1.
3. `\theorem` `\label{thm:rr_genus0}` — Genus-0 RR: on a smooth proper geometrically irreducible curve `C/k̄` with `g(C) = 0`, for every divisor `D` of `\deg D ≥ 0`, `ℓ(D) = \deg D + 1`. `\lean{AlgebraicGeometry.RiemannRoch.l_eq_deg_plus_one_genus_zero}` [expected]. Source: Hartshorne IV.1 + Example IV.1.3.5.

**`\uses` skeleton**:
- `def:l_D` uses `def:O_C_of_D`
- `thm:rr_genus0` uses `def:l_D`, `def:divisor_degree` (from RR.1), `def:genus`

**Main theorem proof strategy**: The genus-0 specialisation avoids full Riemann–Roch. From `g(C) = \dim_k H^1(C, O_C) = 0` and Serre duality (which would give `H^1(C, O_C(D)) = H^0(C, K - D)^∨ = 0` for `\deg D ≥ 0`), the Euler characteristic `χ(O_C(D)) = ℓ(D) - 0 = ℓ(D)`, and `χ(O_C(D)) = \deg D + 1 - g = \deg D + 1`. **Crucial blueprint-side question for the writer**: this proof uses Serre duality (a deferred named gap per `RigidityKbar.tex` piece (iv), 3000–8000 LOC). The genus-0 case may admit a Serre-duality-free direct computation via the cohomology of `O_{\mathbb P^1}(n)` — verify in `references/hartshorne-algebraic-geometry.pdf` Example I.7.2 + IV.1.3.5. **Mark as TODO for the writer: confirm whether the genus-0 RR can be derived without invoking the full Serre duality.**

**References for writer**:
- `references/hartshorne-algebraic-geometry.pdf`, II.6 (`O_C(D)` construction), IV.1 (RR formula + Example IV.1.3.5).
- Hartshorne I.7 Example I.7.2 (`H^0(\mathbb P^1, O(n))` and `H^1(\mathbb P^1, O(n))` — Serre-duality-free).
- `Cohomology_StructureSheafModuleK.tex` (project-side `H^i` infrastructure).

**Subphase choices exposed**:
- Full RR theorem vs genus-0 specialisation: **Recommendation: state both, prove only the genus-0 specialisation in this chapter; the full RR is RR.2-extended (not currently planned).**

### Proposed chapter: `blueprint/src/chapters/RiemannRoch_OcOfD.tex`

**Covers**: `AlgebraicJacobian/RiemannRoch/OcOfD.lean` (planned, matches `Jacobian.tex` L420 stub name `RiemannRoch_OcOfD.tex`)
**Strategy phase**: RR.3 — Construction of `O_C(D)` and its global sections
**Why now**: RR.3 is serial after RR.2 prover-side, but blueprint decomposable now.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:O_C_of_D_construction}` — Concrete construction of `O_C(D)` as a sub-sheaf of the rational-function sheaf. `\lean{AlgebraicGeometry.Scheme.WeilDivisor.lineBundle_of_divisor}` [expected]. Source: Hartshorne II.6 Proposition 6.13.
2. `\theorem` `\label{thm:O_C_of_D_iso_linear_equivalent}` — `O_C(D) ≅ O_C(D')` if `D ∼ D'` (linearly equivalent divisors give isomorphic line bundles). `\lean{AlgebraicGeometry.Scheme.WeilDivisor.lineBundle_linearEquiv}` [expected]. Source: Hartshorne II.6.
3. `\theorem` `\label{thm:H0_O_C_of_P_dim_two}` — `\dim_k H^0(C, O_C(P)) = 2` on a smooth proper genus-0 curve with `k̄`-point `P`. `\lean{AlgebraicGeometry.RiemannRoch.h0_O_C_of_P_genus_zero}` [expected]. Source: Hartshorne Example IV.1.3.5.
4. `\theorem` `\label{thm:nonconstant_function_from_h0}` — From `\dim H^0(C, O_C(P)) = 2` extract a non-constant rational function `f : C → \mathbb P^1` with simple pole at `P`. `\lean{AlgebraicGeometry.RiemannRoch.nonconstant_function}` [expected]. Source: Hartshorne II.6.10.1.

**`\uses` skeleton**:
- `thm:O_C_of_D_iso_linear_equivalent` uses `def:O_C_of_D_construction`, `def:linear_equivalence` (RR.1)
- `thm:H0_O_C_of_P_dim_two` uses `def:O_C_of_D_construction`, `thm:rr_genus0` (RR.2)
- `thm:nonconstant_function_from_h0` uses `thm:H0_O_C_of_P_dim_two`

**Main theorem proof strategy**: `def:O_C_of_D_construction` follows Hartshorne II.6: `O_C(D)(U) := \{f ∈ K(C)^× : \div(f) + D|_U ≥ 0\} ∪ \{0\}`. `thm:H0_O_C_of_P_dim_two` is the application of RR (`thm:rr_genus0`) at `D = P`, `\deg D = 1`, giving `ℓ(D) = 2`. `thm:nonconstant_function_from_h0` picks a basis `\{1, f\}` of `H^0(C, O_C(P))` and reads off `f` as non-constant.

**References for writer**:
- `references/hartshorne-algebraic-geometry.pdf`, II.6 (`O_C(D)` definition + linear-equivalence iso), II.6.10.1 (the `P ∼ Q ⟹` rationality bridge), IV.1.3.5 (the genus-0 specialisation).

### Proposed chapter: `blueprint/src/chapters/RiemannRoch_RationalIsoP1.tex`

**Covers**: `AlgebraicJacobian/RiemannRoch/RationalIsoP1.lean` (planned, matches stub name `RiemannRoch_RationalIsoP1.tex` per `Jacobian.tex` L428)
**Strategy phase**: RR.4 — The classification headline `genusZero_curve_iso_P1`
**Why now**: RR.4 is the headline of the RR bridge consumed by `prop:genusZero_curve_iso_P1` in `AbelianVarietyRigidity.tex` (L1585, currently a deferred named gap per `rmk:genusZero_iso_subbuild` L1623). Writing this blueprint now exposes the final assembly step.

**Key declarations** (in dependency order):
1. `\theorem` `\label{thm:degree_one_morphism_to_P1_is_iso}` — A degree-1 morphism between smooth proper curves over an algebraically closed field is an isomorphism. `\lean{AlgebraicGeometry.Curve.degree_one_morphism_isIso}` [expected]. Source: Hartshorne II.6.8.
2. `\theorem` `\label{thm:rational_curve_iso_P1}` — A complete nonsingular rational curve over `k̄` is isomorphic to `\mathbb P^1`. `\lean{AlgebraicGeometry.Curve.rational_iso_P1}` [expected]. Source: Hartshorne I.6.12.
3. `\theorem` `\label{thm:genusZero_curve_iso_P1_RR}` — **Headline**: a smooth proper geometrically irreducible curve `C/k̄` with `g(C) = 0` is isomorphic to `\mathbb P^1_{k̄}`. `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` [expected — already pinned in AVR L1585]. Source: Hartshorne Example IV.1.3.5.

**`\uses` skeleton**:
- `thm:degree_one_morphism_to_P1_is_iso` uses `def:divisor_degree` (RR.1)
- `thm:rational_curve_iso_P1` uses `thm:degree_one_morphism_to_P1_is_iso`
- `thm:genusZero_curve_iso_P1_RR` uses `thm:nonconstant_function_from_h0` (RR.3), `thm:rational_curve_iso_P1`

**Main theorem proof strategy**: Hartshorne IV.1.3.5 argument verbatim. From `thm:nonconstant_function_from_h0` (RR.3) extract `f : C → \mathbb P^1` of degree 1 (degree = `\deg(\div(f)_\infty) = \deg P = 1`). Apply `thm:degree_one_morphism_to_P1_is_iso`: degree-1 means `f` is generically injective; combined with smoothness + properness + same-dimension target, `f` is an isomorphism. The final identification gives `C \cong \mathbb P^1_{k̄}`.

**References for writer**:
- `references/hartshorne-algebraic-geometry.pdf`, I.6.12 (rational curve classification), II.6.8 (degree-1 ⟹ iso), Example IV.1.3.5 (the headline).
- The relevant verbatim quote of IV.1.3.5 is **already present** in `AbelianVarietyRigidity.tex` L1587–1596 (the `prop:genusZero_curve_iso_P1` block); the writer should re-state the quote in this chapter's `thm:genusZero_curve_iso_P1_RR` block.

**Subphase choices exposed**: None — the chain is canonical.

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - missing — `\lean{...}` pin for `AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective` (new substantive `sorry` at G0BO L372 that `lem:proj_chart_ring_iso_aux_left` cancel-surjective rewrite depends on). The `blueprint-writer surjective-pin` directive was dispatched 13:54 this iter; no `*-report.md` yet on disk. Until the writer lands, the chapter cannot claim full coverage of the G0BO file's substantive `sorry`-pile.
  - iter-171 NOTE refresh at `def:gaTranslationP1` (L1153–63, `gmScalingP1` body skeleton landed) — matches current Lean state (`AlgebraicJacobian/Genus0BaseObjects.lean` L1140-ish, `gmScalingP1` has a concrete body via `Over.homMk + Scheme.Cover.glueMorphisms`, three internal scaffold sorries `gmScalingP1_chart{,_agreement,_over_coherence}`). **CORRECT.**
  - iter-171 NOTE refresh at `lem:gmScaling_fixes_zero` (L1216–25, gated on `gmScalingP1_chart` body) — matches current Lean state. **CORRECT.**
  - iter-171 NOTE at `def:proj_chart_ring_iso` (L1091–1100) — still stale per the iter-171 lean-vs-blueprint-checker minor finding (says "sorry residual has MOVED" — but the surjective-pin directive's Task 2 was to refresh this, and that writer has not landed). Will be cleared when the writer lands.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes (HARD GATE CLEARS for `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` file-skeleton).

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: false
- **correct**: n/a — file does not exist on disk
- **notes**:
  - missing — `ls` confirms file absent; `content.tex` does not `\input` it. `blueprint-writer route-a1-retry2` was dispatched at 13:55 this iter (directive at `logs/iter-172/blueprint-writer-route-a1-retry2-directive.md`, 5243 bytes); the retry-2 report has not landed by the time of this audit (only `progress-critic-route172-report.md` is in the iter directory). **Gated on writer landing this iter.** If the retry-2 writer succeeds, a same-iter fast-path scoped re-review will clear the HARD GATE; if it fails (twice in a row would be the second failure), the `AlgebraicJacobian/Picard/RelativeSpec.lean` Lane B prover lane stays deferred.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes. (Section-level Route A.1–A.4 decomposition with per-sub-phase LOC budgets is solid as a strategic anchor, but does NOT replace per-file sub-chapters for prover work — those are the unstarted-phase proposals above.)

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes. Status: a deferred named gap, off-critical-path, retained as the fallback-(a) artifact. The iter-155 disposition + iter-154 KDM live route are documented exhaustively. The proof body in the Lean tree is `sorry`; consumed only as documentation, not as a prover-lane gate.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes. (Pointer chapter to RigidityKbar.tex piece (i); intentionally minimal.)

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

## Cross-chapter notes

- `Jacobian.tex` (L484, route (c) of C.2.d) still describes the genus-0 base case via the **𝔾ₐ/𝔾ₘ incompatibility argument** (additive defect map on `\mathbb G_a × \mathbb G_a` extended via Thm 3.2). This is the **demoted Milne-faithful alternative** per the iter-164 strategy decision; the **committed** primary route in `AbelianVarietyRigidity.tex` is the 𝔾ₘ-scaling shortcut (`rmk:base_case_fourth_route`, `prop:morphism_P1_to_AV_constant`). The two descriptions disagree about which route is "committed". `AbelianVarietyRigidity.tex` is the authoritative chapter for the genus-0 keystone; `Jacobian.tex` L484 should be refreshed to match (low priority — purely informational, the headline `thm:rigidity_genus0_curve_to_AV` is correctly pointed at). Soft drift, not must-fix.
- `AbelJacobi.tex` (L82, "Classical description" remark) still phrases the genus-0 case via `\cref{thm:rigidity_over_kbar}` (the CharZero fallback-(a) artifact in `RigidityKbar.tex`) rather than the committed char-free `\cref{thm:rigidity_genus0_curve_to_AV}` of `AbelianVarietyRigidity.tex`. This is a remark, not a load-bearing proof step (the Lean closure uses `IsAlbanese.exists_unique_ofCurve_comp` projection, not the classical description), so it doesn't break any prover lane. Refresh recommended next iter; not must-fix.

## Severity summary

**must-fix-this-iter** (3 items):
- `AbelianVarietyRigidity.tex` — missing `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective}` pin (chapter `complete: partial`). **Already being addressed**: `blueprint-writer surjective-pin` dispatched 13:54 this iter. On landing, scoped re-review clears the HARD GATE for the G0BO prover lane.
- `Picard_RelativeSpec.tex` — file missing from disk (chapter `complete: false`). **Already being addressed**: `blueprint-writer route-a1-retry2` dispatched 13:55 this iter. On landing, scoped re-review clears the HARD GATE for the `Picard/RelativeSpec.lean` Lane B prover lane. **If the retry-2 fails (this would be the writer's second failure), Lane B deferral propagates to iter-173+ and the planner needs a different writer strategy.**
- unstarted-phase proposal: **7 proposals provided** (Picard_LineBundlePullback.tex, Picard_RelPicFunctor.tex, Picard_FGA_FlatteningStratification.tex + Picard_FGA_QuotConstruction.tex, Picard_Pic0_IdentityComponent.tex, Picard_AlbaneseUP.tex, RiemannRoch_RRFormula.tex, RiemannRoch_OcOfD.tex, RiemannRoch_RationalIsoP1.tex) — dispatch blueprint-writer for each proposed chapter or record deferral. Highest leverage given the dominant ~33–54 iter Route A budget. **Recommended priority**: A.4 first (the open Thm-3.2 strategic question needs concrete declaration form before the planner can resolve it), then A.2 FlatteningStratification (the lone parallel-startable A.2 entry), then A.3, then RR.2–4 and A.1.b/A.1.c in parallel as writer capacity allows.

**soon** (no items)

**informational** (2 items, see Cross-chapter notes):
- `Jacobian.tex` L484 / route (c) description still uses the demoted Milne-faithful 𝔾ₐ chain — refresh to the committed 𝔾ₘ-scaling shortcut.
- `AbelJacobi.tex` L82 / "Classical description" still cites `thm:rigidity_over_kbar` (fallback-a) — refresh to `thm:rigidity_genus0_curve_to_AV` (committed).

**Overall verdict**: The blueprint is in solid shape for the three iter-172 active prover lanes — RR.1 HARD GATE clears, AVR HARD GATE clears modulo the in-flight surjective-pin writer (fast-path eligible), Picard_RelativeSpec.tex gated on in-flight retry-2 writer. **7 unstarted phases (A.1.b, A.1.c, A.2 split into 2, A.3, A.4, RR.2, RR.3, RR.4) have no blueprint coverage; proposals provided for immediate writer dispatch.** The cost of letting these accumulate across iters is ~33–54 iter Route A latency the project cannot afford.
