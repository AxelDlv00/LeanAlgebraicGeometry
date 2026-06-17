# Lean ↔ Blueprint Check Report

## Slug
differentials-review124

## Iteration
124

## Files audited
- Lean: `AlgebraicJacobian/Differentials.lean`
- Blueprint: `blueprint/src/chapters/Differentials.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf}` (chapter: def:relative_kaehler_presheaf)
- **Lean target exists**: yes (Differentials.lean:51)
- **Signature matches**: yes — `(f : X ⟶ S) : X.PresheafOfModules` matches the prose ("presheaf of $\struct{X}$-modules on $X$")
- **Proof follows sketch**: N/A (definition body)
- **notes**: body uses `pullbackPushforwardAdjunction.homEquiv.symm` to transpose `f.c : S.presheaf ⟶ f_*X.presheaf` into the φ' the `relativeDifferentials'` constructor consumes, matching the prose's "canonical adjunction-transpose"

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler}` (chapter: lem:relative_kaehler_presheaf_obj)
- **Lean target exists**: yes (Differentials.lean:60)
- **Signature matches**: yes — the statement says the section module equals `CommRingCat.KaehlerDifferential` of the appropriate ring map at `V`, matching the chapter's $\Omega_{X/S}(V) = \Omega_{\struct{X}(V) / (f^{-1}_{\mathrm{psh}}\struct{S})(V)}$
- **Proof follows sketch**: yes — body is `rfl`, matching the chapter's stated "by definition / by `rfl` after unfolding"
- **notes**: clean Lean ↔ blueprint match

### `\lean{AlgebraicGeometry.Scheme.smooth_locally_free_omega}` (chapter: thm:smooth_locally_free_omega)
- **Lean target exists**: yes (Differentials.lean:552)
- **Signature matches**: yes — `[SmoothOfRelativeDimension n f]` (the non-deprecated form, as Remark `rem:smooth_class_naming` pins) followed by the existential over `(U, V, e, hxV, hU, hV)` and the `Module.Free` + `Module.rank = n` conjunction matches the prose verbatim
- **Proof follows sketch**: yes — Step 1 invokes `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension`, then `algebraize` + `IsStandardSmoothOfRelativeDimension.isStandardSmooth` (Step 2) feeds the two `first | exact ...` cases (Steps 3 and 4). The `Nonempty V` hypothesis discharged by `⟨⟨x, hxV⟩⟩` covers Step 4.5 (`component_nontrivial` is implicit in the Mathlib `[Nonempty V]` → `[Nontrivial Γ(X, V)]` instance chain)
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE}` (chapter: thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE)
- **Lean target exists**: yes (Differentials.lean:463)
- **Signature matches**: yes — `LinearEquiv` over `Γ(X, V)` between presheaf section module and `CommRingCat.KaehlerDifferential (Scheme.Hom.appLE f U V e)`, matching prose's $\Omega_{X/S}(V) \simeq_B \Omega_{B/A}$
- **Proof follows sketch**: yes — Step 2 (`appLE_isLocalization`) + Step 3 (scalar tower from `appLE_colimRingHom_comp_φV`) + Step 4 (`kaehler_quotient_localization_iso.symm`) match M1.e in the chapter
- **notes**: depends on `appLE_isLocalization` (which has a residual sorry — see below)

### `\lean{AlgebraicGeometry.IsAffineOpen.appLE_isLocalization}` (chapter: lem:appLE_isLocalization)
- **Lean target exists**: yes (Differentials.lean:282)
- **Signature matches**: yes — `IsLocalization (appLE_unitSubmonoid f hU hV e) A_colim` under the `appLE_colimAlgebra` algebra structure, matching the prose "$A_{\mathrm{colim}}$ is the localization of $A$ at $M$"
- **Proof follows sketch**: **partial** — see severity summary below. The Lean body's Step 1 (`IsLocalization.lift` → `forward`) and Step 4 closer (`IsLocalization.isLocalization_of_algEquiv`) match the chapter. But the chapter sketches Steps 2 + 3 as "build backward map abstractly via cocone universal property + basic-open cover; verify composites are identities via `IsLocalization.ringHom_ext`", whereas the Lean body now packages Steps 2 + 3 jointly as `Function.Bijective ⇑forwardAlg` via `AlgEquiv.ofBijective forwardAlg sorry` (L398). The residual single `sorry` is the bijectivity claim. Mathematically equivalent reformulations, but the chapter prose has not been updated to reflect the new packaging.
- **notes**: the new in-body `forwardAlg : Localization M →ₐ[Γ(S, U)] A_colim` (L345-354) uses `RingHom.congr_fun h_fwd_comp` to close `commutes'`, consistent with the chapter's M1.a `appLE_colimAlgebra := (appLE_colimRingHom f e).hom.toAlgebra` (definitional). The residual sorry's goal at L398 is `Function.Bijective ⇑forwardAlg` as expected.

### `\lean{AlgebraicGeometry.IsAffineOpen.appLE_unitSubmonoid}` (chapter: inline reference at L136 in proof of `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE`)
- **Lean target exists**: yes (Differentials.lean:78)
- **Signature matches**: yes — `Submonoid Γ(S, U)` with carrier `{g | IsUnit ((Scheme.Hom.appLE f U V e).hom g)}`, matching prose's $M := \{g \in A : (f.\mathrm{appLE}\,U\,V\,e).\mathrm{hom}(g) \in B^{\times}\}$
- **Proof follows sketch**: yes — `one_mem'` via `isUnit_one`, `mul_mem'` via `IsUnit.mul` exactly mirror the chapter's "$1 \in M$ ... $gh \in M$"
- **notes**: clean; no dedicated `\begin{lemma}` block (inline reference only — known follow-up per directive)

### `\lean{AlgebraicGeometry.IsAffineOpen.isUnit_appLE_unitSubmonoid_in_colim}` (chapter: inline reference at L167 in proof of `lem:appLE_isLocalization` Step 0)
- **Lean target exists**: yes (Differentials.lean:164)
- **Signature matches**: yes — claims `IsUnit ((algebraMap Γ(S, U) A_colim) g)` for each `g ∈ M`, matching prose's Step 0 conclusion
- **Proof follows sketch**: yes — (a) derive `V ≤ f ⁻¹ᵁ (S.basicOpen g)` via `Scheme.basicOpen_appLE` + `Scheme.basicOpen_of_isUnit`; (b)-(c) build cocone leg at `S.basicOpen g` and prove `appLE_colimRingHom = rstr ≫ cleg` via unit naturality; (d) `IsAffineOpen.isLocalization_basicOpen` + `IsLocalization.Away.algebraMap_isUnit`; (e) `IsUnit.map cleg.hom`. This is the chapter's Step 0 strategy verbatim.
- **notes**: clean; no dedicated `\begin{lemma}` block (inline reference only — known follow-up per directive)

### `\lean{AlgebraicGeometry.IsAffineOpen.appLE_colimRingHom_comp_φV}` (chapter: inline reference at L151 in proof of `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE` M1.e step)
- **Lean target exists**: yes (Differentials.lean:116)
- **Signature matches**: yes — claims `appLE_colimRingHom f e ≫ φV = Scheme.Hom.appLE f U V e`, matching prose's "$(A \to A_{\mathrm{colim}} \to B) = f.\mathrm{appLE}\,U\,V\,e$"
- **Proof follows sketch**: yes — unit-triangle identity (`adj.homEquiv.apply_symm_apply`) combined with naturality of φ' at `(homOfLE e).op`, exactly the chapter's "cocone-leg triangle identity"
- **notes**: clean; no dedicated `\begin{lemma}` block (inline reference only — known follow-up per directive)

### `\lean{AlgebraicGeometry.Scheme.kaehler_localization_subsingleton}` (chapter: lem:kaehler_localization_subsingleton)
- **Lean target exists**: yes (Differentials.lean:408)
- **Signature matches**: yes — `Subsingleton (Ω[L⁄A])` under `[IsLocalization M L]`, matching prose
- **Proof follows sketch**: yes — two-line re-export `FormallyUnramified.of_isLocalization` → `FormallyUnramified.subsingleton_kaehlerDifferential`, exactly the chapter's "thin re-export"
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.kaehler_quotient_localization_iso}` (chapter: lem:kaehler_quotient_localization_iso)
- **Lean target exists**: yes (Differentials.lean:424)
- **Signature matches**: yes — `Ω[B⁄A] ≃ₗ[B] Ω[B⁄L]` under the chapter's hypothesis chain, matching prose
- **Proof follows sketch**: yes — `LinearEquiv.ofBijective (KaehlerDifferential.map A L B B) ⟨injectivity, surjectivity⟩` with injectivity via `exact_mapBaseChange_map` + `Subsingleton (TensorProduct L B (Ω[L⁄A]))` and surjectivity via `KaehlerDifferential.map_surjective`. Matches the chapter's "second fundamental exact sequence ⇒ left zero ⇒ right iso"
- **notes**: clean

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` at line 398: body contains `AlgEquiv.ofBijective forwardAlg sorry`. The blueprint (Lemma `lem:appLE_isLocalization` and proof at L162-188) claims this is a substantive lemma with `\leanok` on the proof block. The sorry is the bijectivity of `forwardAlg : Localization M →ₐ[Γ(S, U)] A_colim` and packages the chapter's Steps 2 + 3 (backward map + composite-identity verification) into a single `Function.Bijective` claim. **This is a known open work item explicitly disclosed in the body's L332-L397 comment block** (two Mathlib pieces: filtered-colim element representation + basic-open cofinality), and the chapter ALSO acknowledges in L165 that "Mathlib snapshot b80f227 has no off-the-shelf 'colim of localizations is localization at the union submonoid' lemma" — so the project-local intent to leave this as a sorry while M1 is in progress is documented on both sides. Note however that the proof-block `\leanok` marker at L164 will become stale (sync_leanok handles this automatically).

### Excuse-comments

None found. The body's commentary block at L332-L397 is honest about the residual sorry being a Steps 2 + 3 packaging and explicitly names the Mathlib gap; this is appropriate disclosure, not an excuse-comment.

### Axioms / `Classical.choice` on non-trivial claims

None.

## Unreferenced declarations (informational)

- `AlgebraicGeometry.IsAffineOpen.appLE_colimRingHom` (Differentials.lean:97) — the ring map `Γ(S, U) → A_colim` itself. Referenced in chapter prose (L159) but no dedicated `\lean{...}` hint or `\begin{lemma}` block. Helper-shaped (load-bearing for the algebra structure) but substantive enough that a dedicated chapter block would help; planner-flagged "soon" item per the directive.
- `AlgebraicGeometry.IsAffineOpen.appLE_colimAlgebra` (Differentials.lean:106) — the `Algebra Γ(S, U) A_colim` instance derived from `appLE_colimRingHom.hom.toAlgebra`. The chapter prose mentions it at L175 ("project-local `appLE_colimAlgebra` on $A_{\mathrm{colim}}$") but no `\lean{...}` hint. Reducible helper, defequal to the ring-hom-induced algebra structure; not a must-fix.
- The three other inline-only references (`appLE_unitSubmonoid`, `isUnit_appLE_unitSubmonoid_in_colim`, `appLE_colimRingHom_comp_φV`) DO have `\lean{...}` hints embedded in proof bodies, just not their own dedicated `\begin{lemma}` blocks; per the directive, the "promote to dedicated lemma blocks" follow-up is a "soon" item, not must-fix.

## Blueprint adequacy for this file

- **Coverage**: 10/12 Lean declarations have a `\lean{...}` reference in the chapter (5 via dedicated blocks, 3 via inline-in-proof hints, 2 via prose mention only). Unreferenced via `\lean{...}`: 2 (`appLE_colimRingHom`, `appLE_colimAlgebra`) — both substantive helpers that prose acknowledges.
- **Proof-sketch depth**: **under-specified for `lem:appLE_isLocalization`** in one specific way. The chapter sketches Steps 2 + 3 in the "build backward map abstractly + verify composites" framing, but the actual mathematical obstruction (filtered-colim element representation in the lan-defined colim + basic-open cofinality `every W ⊇ fV contains some D(g) with g ∈ M`) is NOT named at the level of the Mathlib API needed. The Lean body's L332-L397 comment is more specific about the Mathlib gap than the chapter prose at L165-L195. A future prover restarting from chapter prose alone would not know where exactly Mathlib runs out. The chapter does generically acknowledge "Mathlib snapshot b80f227 has no off-the-shelf 'colim of localizations is localization at the union submonoid' lemma" but does not isolate the (a)/(b) pieces the Lean body identifies. **All other chapter sketches are adequate.**
- **Hint precision**: precise. Every `\lean{...}` hint pins the right Mathlib/project-local declaration; no loose hints found.
- **Generality**: matches need. The chapter's M1.a `appLE_unitSubmonoid` and M1.b `appLE_isLocalization` framings are at the right level of generality (general `(U, V, e)` with affine hypotheses, not pinned to a specific chart).
- **Recommended chapter-side actions**:
  - **Realignment for the new bijectivity-reduction route in M1.b proof prose** (L162-188): the chapter still sketches "build backward map + verify composites via `IsLocalization.ringHom_ext`", whereas the Lean body now uses "promote `forward` to `forwardAlg : ... →ₐ[A] ...` and reduce to `Function.Bijective ⇑forwardAlg` via `AlgEquiv.ofBijective`". Both routes are mathematically valid but the chapter and Lean should match. Suggested update: add a paragraph in the M1.b proof acknowledging that the Lean now packages Steps 2 + 3 jointly as bijectivity of `forwardAlg`, and what the bijectivity argument requires (the two specific Mathlib pieces the Lean body comment isolates). This is mild drift; "soon" not "must-fix".
  - **Promote `appLE_unitSubmonoid`, `isUnit_appLE_unitSubmonoid_in_colim`, `appLE_colimRingHom_comp_φV`, `appLE_colimRingHom`, `appLE_colimAlgebra` to dedicated `\begin{lemma}` / `\begin{definition}` blocks** with their own `\lean{...}` hints. Currently they live as inline references inside the parent lemma's proof body, which is acceptable but not ideal for a chapter that wants to act as a roadmap. Per directive, this is the "soon" item already flagged by blueprint-reviewer-iter124, not must-fix.

## Severity summary

- **must-fix-this-iter**: none.
  - The sole `sorry` at L398 is explicitly disclosed on BOTH sides (Lean body comment L332-L397 AND chapter prose acknowledging the Mathlib gap at L165). The chapter's `\leanok` on the proof block of `lem:appLE_isLocalization` is stale, but `\leanok` is managed deterministically by the `sync_leanok` phase — agents must NOT touch it.
  - All other declarations match prose; no excuse-comments; no axiom abuse.

- **major**: none.

- **minor**:
  - Proof-sketch realignment for `lem:appLE_isLocalization` (L162-188): chapter sketches "abstract backward map + composite-identity" route, Lean now uses "bijectivity of `forwardAlg`" packaging. Mathematically equivalent; chapter prose should add one paragraph noting the actual Lean route.
  - `appLE_colimRingHom`, `appLE_colimAlgebra`: chapter prose mentions them but no `\lean{...}` hint; promote to dedicated blocks (already known "soon" item).
  - The three inline `\lean{...}` references (`appLE_unitSubmonoid`, `isUnit_appLE_unitSubmonoid_in_colim`, `appLE_colimRingHom_comp_φV`) could be promoted to dedicated `\begin{lemma}` blocks (already known "soon" item per blueprint-reviewer-iter124 finding).

**Overall verdict**: Lean and blueprint are well aligned; the residual single `sorry` in `appLE_isLocalization` is the M1.b open work item explicitly disclosed on both sides, and the only minor drift is that the chapter's M1.b proof sketch still describes the "build backward map abstractly" route while the Lean body now reduces to bijectivity of a forward AlgHom — mathematically equivalent reformulations, addressable with a one-paragraph blueprint update.
