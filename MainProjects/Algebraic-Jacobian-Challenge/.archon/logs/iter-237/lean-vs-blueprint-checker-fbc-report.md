# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
237

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes (line 76)
- **Signature matches**: yes — `pushforwardBaseChangeMap (comm : g' ≫ f = f' ≫ g) (F : X.Modules) : pullback g (pushforward f F) ⟶ pushforward f' (pullback g' F)`, exactly as described.
- **Proof follows sketch**: yes — adjunction transpose of the unit-composite route described in the chapter.
- **notes**: Statement block has `\leanok`. Proof block has `\leanok`. Both correct (no sorry).

---

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (lem:modules_isIso_iff_stalk)
- **Lean target exists**: yes (line 99)
- **Signature matches**: yes — `φ : M ⟶ N` is iso iff stalk functor map is iso at each `x`.
- **Proof follows sketch**: yes — forward direction by functor functoriality; converse packages as `TopCat.Sheaf` morphisms, applies stalkwise criterion, then reflects through the forgetful functor.
- **notes**: Statement and proof both carry `\leanok`. Correct (no sorry).

---

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (lem:modules_isIso_of_isBasis)
- **Lean target exists**: yes (line 125)
- **Signature matches**: yes — takes `IsBasis (Set.range B)`, a morphism iso on each basic open, concludes isomorphism.
- **Proof follows sketch**: yes — reduces to stalkwise bijectivity via `isIso_iff_isIso_stalkFunctor_map`; injectivity from `stalkFunctor_map_injective_of_isBasis`; surjectivity from `germ_exist_of_isBasis`.
- **notes**: Statement and proof both carry `\leanok`. Correct (no sorry).

---

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — iso iff iso on every affine open.
- **Proof follows sketch**: yes — specialises `isIso_of_isIso_app_of_isBasis` to `X.affineOpens` using `isBasis_affineOpens`.
- **notes**: Statement and proof both carry `\leanok`. Correct (no sorry).

---

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes (line 265)
- **Signature matches**: yes — `gs_R.hom ≫ (Spec.map φ).appTop = φ ≫ gs_{R'}.hom`.
- **Proof follows sketch**: yes — uses `ΓSpecIso_inv_naturality` after identifying `globalSectionsIso.hom` with `ΓSpecIso.inv`.
- **notes**: Statement and proof both carry `\leanok`. Correct (no sorry).

---

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (lem:gammaPushforwardIso)
- **Lean target exists**: yes (line 285)
- **Signature matches**: yes — `Γ((Spec φ)_* N) ≅ restr_φ (Γ N)` for any `N : (Spec R').Modules`.
- **Proof follows sketch**: yes — element-free route (b): both sides peel by `rfl` to restriction-of-scalars towers; reconciled by `restrictScalarsComp'App` × 2 and `eqToIso` from `globalSectionsIso_hom_comp_specMap_appTop`.
- **notes**: Statement and proof both carry `\leanok`. Correct (no sorry).

---

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (lem:gammaPushforwardTildeIso)
- **Lean target exists**: yes (line 310)
- **Signature matches**: yes — `Γ((Spec φ)_* M~) ≅ restr_φ M`.
- **Proof follows sketch**: yes — specialises `gammaPushforwardIso` to `N = tilde M` and composes with `tilde.toTildeΓNatIso.app M`.
- **notes**: Statement and proof both carry `\leanok`. Correct (no sorry).

---

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: **NO** — this exact declaration does NOT exist anywhere in the file. The file contains only the conditional version `AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule` (line 395).
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A (declaration absent)
- **notes**: **DANGLING PIN.** The blueprint's `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` points to a nonexistent declaration. The iter-237 work built only the conditional version (taking `hloc` as a hypothesis). The statement block has no `\leanok` (correctly unformalized), but the stale `\lean{}` target name will confuse `sync_leanok` and misrepresent the actual formalization state. The plan agent must either (a) update the `\lean{}` pin to `pushforward_spec_tilde_iso_of_isLocalizedModule` (the decl actually built) and add a `% NOTE:` that the unconditional form is the final target, or (b) leave the pin pointing to the intended target name and add a `% NOTE:` explaining that the current formalization is the conditional version. **See recommendation below.**

---

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (lem:affine_base_change_pushforward)
- **Lean target exists**: yes (line 446)
- **Signature matches**: yes — `affineBaseChange_pushforward_iso (h : IsPullback …) [IsAffineHom f] (F : X.Modules) [F.IsQuasicoherent] : IsIso (pushforwardBaseChangeMap …)`.
- **Proof follows sketch**: partial — the body starts `rw [Modules.isIso_iff_isIso_app_affineOpens]` (matching the "First reduction" step), then `sorry` defers the affine computation.
- **notes**: Statement has `\leanok` (correct: declaration exists with sorry). Proof block has **no** `\leanok` (correct: proof is incomplete). Honest sorry representation. ✓

---

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (thm:flat_base_change_pushforward)
- **Lean target exists**: yes (line 479)
- **Signature matches**: yes — `flatBaseChange_pushforward_isIso (h : IsPullback …) [Flat g] [QuasiCompact f] [QuasiSeparated f] (F : X.Modules) [F.IsQuasicoherent] : IsIso (pushforwardBaseChangeMap …)`.
- **Proof follows sketch**: partial — the body contains an extensive `-- Proof strategy` comment narrating the Stacks 02KH argument, then `sorry`. The comment is accurate documentation, not an excuse comment.
- **notes**: Statement has `\leanok` (correct: declaration exists with sorry). Proof block has **no** `\leanok` (correct: proof is incomplete). Honest sorry representation. ✓

---

## Red flags

### Placeholder / suspect bodies
- `affineBaseChange_pushforward_iso` at line 470: body is `:= sorry`. **Blueprint correctly reflects this** — statement block carries `\leanok` (declaration exists), proof block has no `\leanok` (proof incomplete). No misrepresentation.
- `flatBaseChange_pushforward_isIso` at line 492: body is `:= sorry`. Same: blueprint correctly reflects this.

### Excuse-comments
None. The inline comments explaining the proof strategy and deferral in `affineBaseChange_pushforward_iso` (lines 456–469) and `flatBaseChange_pushforward_isIso` (lines 483–491) are accurate proof-strategy documentation, not "wrong but works for now" disclaimers.

### Axioms / Classical.choice on non-trivial claims
None found.

---

## Unreferenced declarations (informational)

The following three declarations in the Lean file have no corresponding `\lean{...}` pin in the blueprint:

| Declaration | Line | Nature | Blueprint coverage |
|---|---|---|---|
| `AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule` | 331 | standalone `lemma`, substantive proof | None |
| `AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule` | 395 | `noncomputable def`, axiom-clean, conditional version of the main lemma | None (pinned name is the unconditional form) |
| `AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars` | 419 | standalone `lemma`, axiom-clean ring-change helper | None |

These are not mere internal helpers — each is:
1. **`fromTildeΓ_app_isIso_of_isLocalizedModule`**: isolates the section-level engine of `pushforward_spec_tilde_iso`. Without a `\lean{}` pin it is invisible to `sync_leanok` and to future provers inheriting this chapter.
2. **`pushforward_spec_tilde_iso_of_isLocalizedModule`**: the actual formalized conditional version of the main `lem:pushforward_spec_tilde_iso`. This IS what was built this iteration and it is the direct formalisation of the "route iii" blueprint prose, modulo the `hloc` hypothesis. Not having it pinned means the iteration's main prover output is untracked.
3. **`IsLocalizedModule.powers_restrictScalars`**: the ring-change lemma for the `hloc` hypothesis; the blueprint prose for `lem:pushforward_spec_tilde_iso` describes its mathematical content (localizing `restr_φ M` at `a` = localizing `M` at `φ a`) but gives it no Lean name.

---

## Blueprint adequacy for this file

- **Coverage**: 7/10 blueprint `\lean{...}` pins resolve to existing declarations. 1 pin is dangling (`pushforward_spec_tilde_iso`). 2 pins resolve to existing declarations with sorry-bodies (`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`). Additionally, 3 substantive Lean declarations are wholly untracked.
- **Proof-sketch depth**: **adequate** for the formalized declarations (decls 1–7 above). The route-iii prose for `lem:pushforward_spec_tilde_iso` describes the approach correctly (basis-local criterion on basic opens, `IsLocalizedModule` argument at each `D(a)`) but does not name the intermediate lemmas `fromTildeΓ_app_isIso_of_isLocalizedModule` or `IsLocalizedModule.powers_restrictScalars`. A future prover reading the blueprint prose alone could discover the route, but would have to independently name and state these helpers.
- **Hint precision**: **loose** on one entry: `lem:pushforward_spec_tilde_iso` has `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` but the actual built decl is `…_of_isLocalizedModule`. The other nine pins are precise.
- **Generality**: matches need — no parallel API required.
- **Recommended chapter-side actions** (for plan agent / blueprint-writing subagent):
  1. **Fix the dangling pin** on `lem:pushforward_spec_tilde_iso`: either (a) update `\lean{…}` to `AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule` with a `% NOTE: conditional form; unconditional form is the final target`, or (b) keep the target name and add `% NOTE: current formalization is pushforward_spec_tilde_iso_of_isLocalizedModule (conditional on hloc); unconditional form deferred`.
  2. **Add `\lean{}` pin for `fromTildeΓ_app_isIso_of_isLocalizedModule`** — add a short `\begin{lemma}` block (or a `\begin{remark}` with a `\lean{}` hint) in the route-iii subsection of `lem:pushforward_spec_tilde_iso`.
  3. **Add `\lean{}` pin for `IsLocalizedModule.powers_restrictScalars`** — the prose already describes its mathematical content; add `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` at the corresponding point.
  4. **Add `\lean{}` pin for `pushforward_spec_tilde_iso_of_isLocalizedModule`** — either as a subordinate lemma block or in a `% NOTE:` on the proof of `lem:pushforward_spec_tilde_iso`.

---

## Severity summary

| Finding | Severity |
|---|---|
| Dangling `\lean{}` pin: `pushforward_spec_tilde_iso` → nonexistent declaration (the actual decl is `…_of_isLocalizedModule`) | **major** |
| 3 unreferenced substantive declarations (`fromTildeΓ_app_isIso_of_isLocalizedModule`, `pushforward_spec_tilde_iso_of_isLocalizedModule`, `IsLocalizedModule.powers_restrictScalars`) | **major** |
| 2 sorry-bodies in `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso` | informational — blueprint correctly reflects these with `\leanok` on statement only, no `\leanok` on proof |

**Overall verdict**: 7 of 10 blueprint pins resolve correctly to axiom-clean declarations; 1 pin is dangling (the unconditional `pushforward_spec_tilde_iso` was not built, only the conditional `…_of_isLocalizedModule`), and 3 substantive axiom-clean helpers built this iteration carry no blueprint pin — the plan agent should add pins and a `% NOTE:` to track the conditional form and the outstanding `hloc` obligation.
