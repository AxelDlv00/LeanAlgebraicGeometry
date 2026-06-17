# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
242

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes (line 76)
- **Signature matches**: yes — type `(pullback g).obj((pushforward f).obj F) ⟶ (pushforward f').obj((pullback g').obj F)` matches the prose "g^*(f_* F) ⟶ f'_*((g')^* F)"; takes `comm : g' ≫ f = f' ≫ g` (not `IsPullback`), consistent with the blueprint's definition-block (the map is defined for any commutative square, not just cartesian)
- **Proof follows sketch**: yes — builds the map as the `(pullbackPushforwardAdjunction g).homEquiv` transpose of the unit-composed chain, exactly as the blueprint describes
- **notes**: clean, no sorry

---

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (chapter: `lem:modules_isIso_iff_stalk`)
- **Lean target exists**: yes (line 99)
- **Signature matches**: yes — `IsIso φ ↔ ∀ x, IsIso((stalkFunctor Ab x).map((toPresheaf X).map φ))`
- **Proof follows sketch**: yes — forward via `Functor.map_isIso`; backward packages as `TopCat.Sheaf`, applies `isIso_of_stalkFunctor_map_iso`, reflects via `CategoryTheory.isIso_iff_of_reflects_iso`
- **notes**: `\leanok` on statement and proof — correct

---

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (chapter: `lem:modules_isIso_of_isBasis`)
- **Lean target exists**: yes (line 125)
- **Signature matches**: yes — takes a family `B : ι → X.Opens` with `IsBasis (Set.range B)` and `h : ∀ i, IsIso(φ.app(B i))`
- **Proof follows sketch**: yes — reduces to stalkwise bijectivity, uses `stalkFunctor_map_injective_of_isBasis` for injectivity, `germ_exist_of_isBasis` for surjectivity
- **notes**: `\leanok` on statement and proof — correct

---

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (chapter: `lem:modules_isIso_iff_affineOpens`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — `IsIso φ ↔ ∀ U : X.affineOpens, IsIso(φ.app U)`
- **Proof follows sketch**: yes — forward is `inferInstance`; backward invokes `isIso_of_isIso_app_of_isBasis` with the affine-opens basis
- **notes**: `\leanok` on statement and proof — correct

---

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (chapter: `lem:globalSectionsIso_hom_comp_specMap_appTop`)
- **Lean target exists**: yes (line 265)
- **Signature matches**: yes — states `(globalSectionsIso R).hom ≫ (Spec.map φ).appTop = φ ≫ (globalSectionsIso R').hom`, which is exactly the commutative square in the blueprint
- **Proof follows sketch**: yes — reduces to `Scheme.ΓSpecIso_inv_naturality`
- **notes**: `\leanok` on statement and proof — correct

---

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (chapter: `lem:gammaPushforwardIso`)
- **Lean target exists**: yes (line 285)
- **Signature matches**: yes — `(moduleSpecΓFunctor R).obj((pushforward(Spec.map φ)).obj N) ≅ (restrictScalars φ.hom).obj((moduleSpecΓFunctor R').obj N)` which is `Γ_R((Spec φ)_* N) ≅ restr_φ(Γ_{R'} N)`
- **Proof follows sketch**: yes — route (b) element-free, two `restrictScalarsComp'App` collapses plus `restrictScalarsCongr` from `globalSectionsIso_hom_comp_specMap_appTop`
- **notes**: `\leanok` on statement and proof — correct

---

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (chapter: `lem:gammaPushforwardTildeIso`)
- **Lean target exists**: yes (line 310)
- **Signature matches**: yes — `Γ_R((Spec φ)_* M̃) ≅ (restrictScalars φ.hom).obj M`; specialises `gammaPushforwardIso` and composes with `tilde.toTildeΓNatIso.app M`
- **Proof follows sketch**: yes
- **notes**: `\leanok` on statement and proof — correct

---

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (chapter: `lem:gammaPushforwardIsoAt`)
- **Lean target exists**: yes (line 328)
- **Signature matches**: yes — sections of pushforward `N` over `U : (Spec R).Opens` are isomorphic to `restr_φ` of sections of `N` over the preimage `(Opens.map(Spec.map φ).base).obj U`
- **Proof follows sketch**: yes — same two-`restrictScalarsComp'App` construction as `gammaPushforwardIso` but evaluated at `U` instead of `⊤`; naturality-in-open established by `ext x; rfl` in `gammaPushforwardNatIso`
- **notes**: `\leanok` on statement and proof — correct; the open-naturality remark in the blueprint proof is accurate

---

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (chapter: `lem:tildeRestriction_isLocalizedModule`)
- **Lean target exists**: yes (line 480)
- **Signature matches**: yes — `IsLocalizedModule(powers b)` of the structure-sheaf restriction `Γ(M̃,⊤) → Γ(M̃,D(b))` as an `R'`-linear map
- **Proof follows sketch**: yes — uses `tilde.toOpen M ⊤` bijective (localization at `powers 1`), triangle identity `tilde.toOpen_res`, `LinearEquiv.eq_comp_toLinearMap_symm`, then `IsLocalizedModule.of_linearEquiv_right`
- **notes**: `\leanok` on statement and proof — correct

---

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (chapter: `lem:powers_restrictScalars`)
- **Lean target exists**: yes (line 452)
- **Signature matches**: yes — for `f : M →ₗ[A] N` with `[IsLocalizedModule(algebraMapSubmonoid A S) f]` and `[IsScalarTower R A M/N]`, proves `IsLocalizedModule S (f.restrictScalars R)`; this is the exact converse stated in the blueprint
- **Proof follows sketch**: yes — three conditions checked directly: `map_units` via scalar-tower, `surj` by unpacking `algMap`, `exists_of_eq` similarly
- **notes**: `\leanok` on statement and proof — correct

---

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (chapter: `lem:fromTildeGamma_app_isIso_of_localized`)
- **Lean target exists**: yes (line 364)
- **Signature matches**: yes — `[IsLocalizedModule(powers a) ρ] → IsIso(Hom.app N.fromTildeΓ (basicOpen a))` where `ρ` is the section restriction map
- **Proof follows sketch**: yes — establishes triangle `L ∘ₗ j = ρ`, uses `IsLocalizedModule.ext` to identify `L` with the canonical equivalence between the two localizations
- **notes**: `\leanok` on statement and proof — correct

---

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (chapter: `lem:pushforward_spec_tilde_iso_conditional`)
- **Lean target exists**: yes (line 428)
- **Signature matches**: yes — takes `hloc : ∀ a, IsLocalizedModule(powers a) ρ_a` and produces `(pushforward(Spec.map φ)).obj(tilde M) ≅ tilde((restrictScalars φ.hom).obj M)`
- **Proof follows sketch**: yes — `isIso_of_isIso_app_of_isBasis` over basic opens, each step via `fromTildeΓ_app_isIso_of_isLocalizedModule`; final iso via `(asIso fromTildeΓ _).symm ≪≫ tilde.mapIso(gammaPushforwardTildeIso φ M)`
- **notes**: `\leanok` on statement and proof — correct

---

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (chapter: `lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: yes (line 535)
- **Signature matches**: yes — `(pushforward(Spec.map φ)).obj(tilde M) ≅ tilde((restrictScalars φ.hom).obj M)` with no hypothesis
- **Proof follows sketch**: yes — applies `pushforward_spec_tilde_iso_of_isLocalizedModule`; discharges `hloc a` via `algebraize`, `gammaPushforwardIsoAt` for `e₁, e₂`, naturality square by `ext x; rfl`, then `IsLocalizedModule.powers_restrictScalars` + two `of_linearEquiv` transports. This is exactly the three-movement proof (movements 1–3) in the blueprint proof body
- **Lean verify result**: axiom-clean — only `propext`, `Classical.choice`, `Quot.sound`
- **notes**: `\leanok` on statement and proof — correct; no sorry

---

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (chapter: `lem:pullback_spec_tilde_iso`) ← **newly landed this iter**
- **Lean target exists**: yes (line 686)
- **Signature matches**: yes — takes `φ : R ⟶ R'` and `M : ModuleCat.{u} R` (an **R-module**); returns `(pullback(Spec.map φ)).obj(tilde M) ≅ tilde((extendScalars φ.hom).obj M)`. Blueprint states "(Spec φ)^* M̃ ≅ (R' ⊗_R M)~" for M an R-module. `extendScalars φ.hom M = R' ⊗_R M` by definition. **Signature matches** ✓
- **Proof follows sketch**: yes — uses uniqueness-of-left-adjoints via `conjugateIsoEquiv adjL adjR` where `adjL = tilde.adjunction.comp(pullbackPushforwardAdjunction)` and `adjR = extendRestrictScalarsAdj.comp(tilde.adjunction(R'))`, with `gammaPushforwardNatIso` identifying the right adjoints. The blueprint describes this as "Adjunction.natIsoOfRightAdjointNatIso" but the Lean uses `conjugateIsoEquiv` — these are the same mathematical fact (conjugation of adjoints under a nat iso of right adjoints). Content matches.
- **Lean verify result**: axiom-clean — only `propext`, `Classical.choice`, `Quot.sound`
- **notes**: `\leanok` on statement and proof — correct; no sorry; the directive's requested signature check passes without issue. Minor comment-code discrepancy: the Lean docstring at line 682 says "`Adjunction.natIsoOfRightAdjointNatIso` yields an isomorphism" but the code uses `conjugateIsoEquiv` — a minor naming mismatch in the Lean docstring (not a blueprint issue)

---

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (line 701)
- **Signature matches**: yes — `(h : IsPullback g' f' f g) → [IsAffineHom f] → [F.IsQuasicoherent] → IsIso(pushforwardBaseChangeMap f g f' g' h.w F)`. Blueprint: "for f affine and the square cartesian, the base-change map is an isomorphism." Matches.
- **Proof follows sketch**: N/A (known sorry per directive)
- **notes**: `\leanok` on statement only (proof `\leanok` absent — correct). The Lean sorry comment (lines 712–742) documents two remaining obligations; **see Blueprint Adequacy section** for the stale NOTE issue

---

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)
- **Lean target exists**: yes (line 751)
- **Signature matches**: yes — `(h : IsPullback g' f' f g) → [Flat g] → [QuasiCompact f] → [QuasiSeparated f] → [F.IsQuasicoherent] → IsIso(pushforwardBaseChangeMap f g f' g' h.w F)`. Matches blueprint.
- **Proof follows sketch**: N/A (known sorry per directive)
- **notes**: `\leanok` on statement only (proof `\leanok` absent — correct)

---

## Red flags

### Placeholder / suspect bodies
*(None in the Lean file beyond the two expected sorries in `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso`, which the directive explicitly pre-classifies as documented partials. Not re-classified here.)*

### Excuse-comments
*(None in the Lean file. The `-- STATUS`, `-- STRATEGY`, `-- iter-NNN PIVOT` etc. comments inside the `pushforward_spec_tilde_iso` proof body are accurate historical annotations on a proof that is now complete — not excuse-comments on wrong code.)*

### Axioms / Classical.choice on non-trivial claims
*(None. Both `pullback_spec_tilde_iso` and `pushforward_spec_tilde_iso` verify with only the three standard axioms. No project-local `axiom` declarations found in the file.)*

---

## Unreferenced declarations (informational)

| Declaration | Line | Status |
|---|---|---|
| `gammaPushforwardNatIso` | 664 | **Substantive** — no `\lean{...}` in blueprint; drives `pullback_spec_tilde_iso` as the nat iso that identifies the two right adjoints in the uniqueness-of-left-adjoints argument |

`gammaPushforwardNatIso` is explicitly named in both the Lean docstring for `pullback_spec_tilde_iso` (as the key right-adjoint natural iso) and implicitly in the blueprint's proof for `lem:pullback_spec_tilde_iso` ("The two right adjoints are identified by the natural isomorphism `gammaPushforwardNatIso`"). It is a substantive supporting declaration that should have its own `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` block in the blueprint. All other unlisted helpers are auxiliary let-bindings inside tactic proofs, not top-level declarations.

---

## Blueprint adequacy for this file

**Coverage**: 16/17 Lean declarations have a corresponding `\lean{...}` block in the blueprint. The one uncovered declaration is `gammaPushforwardNatIso` (substantive, flagged above).

**Proof-sketch depth**: **adequate** for all declarations except `lem:affine_base_change_pushforward` (see below).

**Hint precision**: **precise** — every `\lean{...}` tag names the correct declaration with the correct namespace.

**Generality**: **matches need** — all declarations are at the right level of generality for the Lean consumers.

---

### lem:affine_base_change_pushforward — blueprint adequacy issues

**Issue A — Stale `% NOTE:` comment (must-fix-this-iter).**

The blueprint contains the following comment inside the proof of `lem:affine_base_change_pushforward`:

> `% NOTE: Lean proof in progress. The locality reduction (lem:modules_isIso_iff_affineOpens) lands; the affine computation is reframed around full-faithfulness of the tilde functor... The **single Mathlib-absent ingredient** is lem:pushforward_spec_tilde_iso (next FlatBaseChange prover target); the closing algebra is TensorProduct.AlgebraTensorModule.cancelBaseChange...`

`pushforward_spec_tilde_iso` is **now proved** (no sorry, axiom-clean as of this iteration). This NOTE is actively misleading: a reader or plan agent will infer that closing `affineBaseChange_pushforward_iso` is now immediate (the "single" ingredient is done). That inference is **wrong** — two separate Mathlib-absent obligations remain, as documented in the Lean sorry comment (lines 712–742):

1. **The affine reduction** — reducing arbitrary (S, S', X, X') to (Spec R, Spec R', Spec A, Spec A') requires naturality/base-change compatibility of `pushforwardBaseChangeMap` with restriction to affine opens of S'; this compatibility is itself Mathlib-absent.
2. **The adjoint-mate ↔ `cancelBaseChange` identification** — transporting the abstract adjoint-mate through the four dictionary isos to match `TensorProduct.AlgebraTensorModule.cancelBaseChange`; the blueprint correctly describes this as "the sole nontrivial remaining obligation" in the main proof text.

The stale NOTE must be updated to (a) remove the claim that `pushforward_spec_tilde_iso` is the sole remaining ingredient, and (b) name the two actual remaining obligations.

**Issue B — Obligation 1 ("affine reduction") not previewed in the blueprint proof sketch (major).**

The directive asks whether "the chapter's proof sketch for `affineBaseChange_pushforward_iso` adequately previews the two named obligations." The blueprint preview of obligation 2 (adjoint-mate ↔ `cancelBaseChange`) is thorough and correct. However, obligation 1 (the affine reduction) is treated in a single sentence: "The statement is local on S and on S', so we may assume all schemes in sight are affine." This is presented as a standard triviality, but the Lean code (iter-242 sorry comment, lines 722–731) identifies it as a **separate Mathlib-absent build**: "The Stacks proof 'the statement is local on S and S'' reduces to S = Spec R… Carrying that reduction out in Lean requires the naturality / base-change compatibility of `pushforwardBaseChangeMap` with restriction to affine opens of S'… This base-change-of-the-base-change-map compatibility is itself not packaged in Mathlib." The blueprint should name this as a distinct named obligation alongside the `cancelBaseChange` identification.

---

### Recommended chapter-side actions

1. **(must-fix)** Remove the stale `% NOTE:` inside the proof of `lem:affine_base_change_pushforward`. Replace it with a note that names the two actual remaining Lean obligations: (1) affine reduction / base-change compatibility of `pushforwardBaseChangeMap`, and (2) abstract adjoint-mate ↔ `cancelBaseChange` identification. The old NOTE should not survive the current iteration.

2. **(major)** Add a `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` block to the blueprint, positioned in the "pullback companion" subsection immediately before `lem:pullback_spec_tilde_iso`. The block should describe its role as the naturality-in-module upgrade of `gammaPushforwardIso` and its use as the right-adjoint nat iso driving the uniqueness-of-left-adjoints argument for `pullback_spec_tilde_iso`.

3. **(major)** Add a prose paragraph to the proof sketch of `lem:affine_base_change_pushforward` naming "the affine reduction" as a separate Mathlib-absent obligation alongside the `cancelBaseChange` identification. Both are now open; the proof sketch should reflect that.

---

## Severity summary

| Finding | Severity |
|---|---|
| Stale `% NOTE:` in blueprint proof of `lem:affine_base_change_pushforward` claiming `pushforward_spec_tilde_iso` is "the single Mathlib-absent ingredient" (it is now proved; two other obligations remain) | **must-fix-this-iter** |
| `gammaPushforwardNatIso` has no `\lean{...}` block in the blueprint despite being the key supporting declaration for `pullback_spec_tilde_iso` | **major** |
| Obligation 1 (affine reduction) not previewed as a named Mathlib-absent obstacle in the blueprint proof sketch for `lem:affine_base_change_pushforward` | **major** |
| Minor: Lean docstring for `pullback_spec_tilde_iso` names `Adjunction.natIsoOfRightAdjointNatIso` as the Mathlib tool but code uses `conjugateIsoEquiv` | **minor** |

**Overall verdict**: The Lean file is in good health — all 17 declarations type-check, the two newly landed theorems (`pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`) verify axiom-clean with correct signatures, and the two expected sorries are accurately documented. The single must-fix finding is entirely on the blueprint side: a stale NOTE comment actively misrepresents the remaining work on `affineBaseChange_pushforward_iso`.
