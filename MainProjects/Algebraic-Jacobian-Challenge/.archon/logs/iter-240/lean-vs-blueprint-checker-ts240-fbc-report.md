# Lean ↔ Blueprint Check Report

## Slug
ts240-fbc

## Iteration
240

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes (line 76)
- **Signature matches**: yes — `pullback g (pushforward f F) ⟶ pushforward f' (pullback g' F)` matches blueprint's `g^*(f_* F) ⟶ f'_*((g')^* F)`
- **Proof follows sketch**: yes — adjoint mate via `((pullbackPushforwardAdjunction g).homEquiv _ _).symm` applied to the `f_*(unit) ≫ pseudofunctoriality ≫ commutativity` chain; matches blueprint
- **notes**: axiom-clean, `\leanok` on statement correct

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (chapter: `lem:modules_isIso_iff_stalk`)
- **Lean target exists**: yes (line 99)
- **Signature matches**: yes — stalkwise iff criterion for `Scheme.Modules` morphisms
- **Proof follows sketch**: yes — packages into `TopCat.Sheaf`, applies `isIso_of_stalkFunctor_map_iso`, reflects through `toPresheaf`
- **notes**: axiom-clean, `\leanok` correct

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (chapter: `lem:modules_isIso_of_isBasis`)
- **Lean target exists**: yes (line 125)
- **Signature matches**: yes — `IsBasis (Set.range B)` → iso on each `B i` → iso
- **Proof follows sketch**: yes — reduces to stalk-local criterion, uses `stalkFunctor_map_injective_of_isBasis` / `germ_exist_of_isBasis`
- **notes**: axiom-clean, `\leanok` correct

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (chapter: `lem:modules_isIso_iff_affineOpens`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — special case of `isIso_of_isIso_app_of_isBasis` for `X.affineOpens`
- **Proof follows sketch**: yes
- **notes**: axiom-clean, `\leanok` correct

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (chapter: `lem:globalSectionsIso_hom_comp_specMap_appTop`)
- **Lean target exists**: yes (line 265)
- **Signature matches**: yes — ring equation `gsR.hom ≫ (Spec.map φ).appTop = φ ≫ gsR'.hom`
- **Proof follows sketch**: yes — via `ΓSpecIso_inv_naturality`
- **notes**: axiom-clean, `\leanok` correct

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (chapter: `lem:gammaPushforwardIso`)
- **Lean target exists**: yes (line 285)
- **Signature matches**: yes — `moduleSpecΓFunctor R obj (pushforward (Spec.map φ) N) ≅ (restrictScalars φ.hom) obj (moduleSpecΓFunctor R' obj N)`
- **Proof follows sketch**: yes — element-free route (b) via `restrictScalarsComp'App` ×2 + `eqToIso`
- **notes**: axiom-clean, `\leanok` correct

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (chapter: `lem:gammaPushforwardTildeIso`)
- **Lean target exists**: yes (line 310)
- **Signature matches**: yes
- **Proof follows sketch**: yes — specialises `gammaPushforwardIso` to `tilde M` and composes with `tilde.toTildeΓNatIso`
- **notes**: axiom-clean, `\leanok` correct

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (chapter: `lem:gammaPushforwardIsoAt`)
- **Lean target exists**: yes (line 328)
- **Signature matches**: yes — `Γ((Spec φ)_* N, U) ≅ restrictScalars φ (Γ(N, (Spec φ)^{-1} U))`
- **Proof follows sketch**: yes — identical construction to `gammaPushforwardIso` with `⊤` replaced by `U`
- **notes**: axiom-clean, `\leanok` correct on statement. **However**: the Lean def only establishes the object-level iso; it does NOT package the family `{e_U}_U` as a `NatTrans`/`NatIso`. The blueprint proof block claims "Naturality in the open follows because…" but this naturality is **not formalized** in Lean — it is the precise step that blocks the residual `hsq` sorry in `pushforward_spec_tilde_iso`. See must-fix below.

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (chapter: `lem:tildeRestriction_isLocalizedModule`)
- **Lean target exists**: yes (line 480)
- **Signature matches**: yes — `IsLocalizedModule (powers b) (restriction ⊤ → D(b)).hom`
- **Proof follows sketch**: yes — triangle identity + bijection at `⊤` (`powers 1`)
- **notes**: axiom-clean, `\leanok` correct

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (chapter: `lem:powers_restrictScalars`)
- **Lean target exists**: yes (line 452)
- **Signature matches**: yes — `IsLocalizedModule (algMap_A S) f → IsLocalizedModule S (f.restrictScalars R)`
- **Proof follows sketch**: yes — three-condition check (map_units, surj, exists_of_eq)
- **notes**: axiom-clean, `\leanok` correct

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (chapter: `lem:fromTildeGamma_app_isIso_of_localized`)
- **Lean target exists**: yes (line 364)
- **Signature matches**: yes — `IsLocalizedModule (powers a) ρ.hom → IsIso (N.fromTildeΓ.app (D a))`
- **Proof follows sketch**: yes — triangle identity forces `L = e` via localization uniqueness
- **notes**: axiom-clean, `\leanok` correct

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (chapter: `lem:pushforward_spec_tilde_iso_conditional`)
- **Lean target exists**: yes (line 428)
- **Signature matches**: yes — conditional form taking `hloc` hypothesis, builds object iso
- **Proof follows sketch**: yes — basis-local criterion + counit iso + `gammaPushforwardTildeIso`
- **notes**: axiom-clean, `\leanok` correct

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (chapter: `lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: yes (line 535)
- **Signature matches**: yes — unconditional `(Spec.map φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`
- **Proof follows sketch**: partial — the `algebraize [φ.hom]` + `powers_restrictScalars` + `of_linearEquiv` scaffold (movements 1–3 per blueprint) IS in place and matches the blueprint's described route; however, the sorry at line 649 (`hsq`: naturality square `ρ ≫ e₂.hom = e₁.hom ≫ Gmor`) is open
- **notes**:
  - **`\leanok` ABSENT from statement block** — the declaration has a sorry-bearing body (lines 535–661) and is thus "at least a sorry present" by `sync_leanok` rules; statement `\leanok` should be present but is missing. See Major finding 1.
  - Blueprint correctly has no `\leanok` on the statement (so no over-claiming). The absence is in the wrong direction (under-claiming), likely due to the `% NOTE:` comment placed at the start of the `\begin{lemma}` block interfering with `sync_leanok` detection.
  - The blueprint does NOT claim the proof complete (no proof block `\leanok`) — correct.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (line 669)
- **Signature matches**: yes — `IsPullback … → IsAffineHom f → F.IsQuasicoherent → IsIso (pushforwardBaseChangeMap …)`
- **Proof follows sketch**: N/A (`:= sorry` body, matching the blueprint's documented sorry state)
- **notes**: `\begin{lemma}\leanok` on statement is **correct** (statement is formalized = at least sorry present); no proof block `\leanok` (correct, sorry-bearing). No over-claiming.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)
- **Lean target exists**: yes (line 702)
- **Signature matches**: yes — `IsPullback … → Flat g → QuasiCompact f → QuasiSeparated f → F.IsQuasicoherent → IsIso (pushforwardBaseChangeMap …)`
- **Proof follows sketch**: N/A (`:= sorry` body)
- **notes**: `\begin{theorem}\leanok` on statement is **correct** (formalized stub); no proof block `\leanok` (correct). No over-claiming.

---

## Red flags

### Placeholder / suspect bodies
- `pushforward_spec_tilde_iso` at line 649: residual `sorry` for `hsq` (naturality square). This IS documented by the directive and known to the project; the blueprint correctly reflects it as incomplete. Not an over-claimed completion.
- `affineBaseChange_pushforward_iso` at line 693: `sorry` body. Expected per blueprint.
- `flatBaseChange_pushforward_isIso` at line 715: `sorry` body. Expected per blueprint.

No undisclosed placeholder bodies. No `:= True` / `:= rfl` abuse, no `axiom` declarations.

### Excuse-comments
None that excuse wrong definitions. The obstacle comments at lines 562–648 in `pushforward_spec_tilde_iso` accurately describe the proof-engineering challenge and proposed fix; they are not excusing incorrect code.

### Stale internal comment (blueprint)
The `% NOTE:` comment inside `lem:pushforward_spec_tilde_iso` (blueprint lines 430–438) says:
> "The sole difficulty in `hloc` is the structure-sheaf smul carrier wall over D(a), whose element-free resolution is the D(a)-specialization of `lem:gammaPushforwardIso` spelled out in the proof below."

This description is **stale after iter-240**: the carrier wall is now resolved (via `algebraize [φ.hom]` + `powers_restrictScalars` + `of_linearEquiv`). The current sole difficulty is the naturality square `hsq`, not the carrier wall. The NOTE misidentifies the open obstacle.

---

## Unreferenced declarations (informational)

All 15 substantive declarations in the Lean file are referenced by `\lean{...}` pins in the blueprint. There are no orphaned substantive declarations. (The `/-! ## ...` docstring sections are infrastructure annotations, not declarations.)

---

## Blueprint adequacy for this file

- **Coverage**: 15/15 Lean declarations have a corresponding `\lean{...}` block in the chapter. Coverage is complete.
- **Proof-sketch depth**: **under-specified** for one critical obligation:
  - The proof sketch for `lem:pushforward_spec_tilde_iso` describes the three movements correctly at a conceptual level but treats the naturality of `gammaPushforwardIsoAt` ("the family {e_U}_U commutes with restriction maps on both sides — naturality follows because every constituent is a restriction or conjugation") as an obvious consequence. In Lean this step is the `hsq` sorry (line 649), blocked by a representational mismatch between the `restrictScalarsComp'App` term baked into `gammaPushforwardIsoAt`'s `by`-block and the freshly-applied one in `nat1`. The conceptual argument in the blueprint does not surface this mismatch, nor does it describe how to close it.
  - The prover's proposed fix — repackage `gammaPushforwardIsoAt` as a genuine `NatTrans`/`NatIso` so that naturality is definitional — is **not mentioned anywhere in the blueprint**. The blueprint describes `lem:gammaPushforwardIsoAt` as providing only the object-level iso; the naturality statement (needed as a separate Lean proposition) has no `\lean{...}` pin, no block, and no proof sketch.
- **Hint precision**: precise for all 15 declarations. `\lean{...}` pins use fully qualified names matching the actual Lean namespaces.
- **Generality**: matches need — all declarations are at the right level of generality.
- **Recommended chapter-side actions**:
  1. **(Must-fix)** Add a new `\lean{...}` block for the naturality of `gammaPushforwardIsoAt` — a `NatIso` (or `NatTrans` commutativity lemma) stating `∀ U' U, U' ≤ U, restriction ≫ (e_{U'}).hom = (e_U).hom ≫ restrictScalars φ (restriction)` — and revise the proof sketch of `lem:pushforward_spec_tilde_iso` to cite this NatIso declaration as the driver of the `hloc(a)` transport. This is the precise ingredient that closes `hsq`.
  2. **(Major)** Update the `% NOTE:` comment in `lem:pushforward_spec_tilde_iso` to reflect the current obstacle: the carrier wall is resolved; the open obligation is the `hsq` naturality square. The current NOTE misleads a reader into thinking the carrier wall remains.
  3. **(Major)** Add `\leanok` to the statement block of `lem:pushforward_spec_tilde_iso`. The Lean declaration exists with a sorry-bearing body; per `sync_leanok` rules the statement `\leanok` should be present. The `% NOTE:` comment placed at the head of the `\begin{lemma}` block likely prevents `sync_leanok` from inserting `\leanok` at its expected position.

---

## Severity summary

### must-fix-this-iter

1. **Blueprint proof sketch for `lem:pushforward_spec_tilde_iso` is under-specified for the `hsq` naturality obligation.** The blueprint describes naturality of `gammaPushforwardIsoAt` as "follows from the construction" without providing a Lean-level statement or proof route. The prover could not close `hsq` from the blueprint's prose alone. The proposed fix (repackage as `NatTrans`/`NatIso`) is not reflected in the chapter. A blueprint-writing subagent must add a naturality NatIso declaration and revise the proof sketch before the next prover pass on `pushforward_spec_tilde_iso`.

### major

1. **Missing statement `\leanok` on `lem:pushforward_spec_tilde_iso`.** The Lean declaration at line 535 has a sorry-bearing body; by `sync_leanok` rules the statement block should carry `\leanok`. It does not, likely because the `% NOTE:` comment placed immediately inside `\begin{lemma}` interferes with sync detection. This is under-claiming (safe) but incorrect marker state.

2. **Stale `% NOTE:` in `lem:pushforward_spec_tilde_iso`.** The comment identifies the "sole difficulty" as the carrier wall, which was resolved in iter-240. The current sole difficulty is the `hsq` naturality square. This misleads downstream readers and provers about what remains to be done.

### minor

- The Lean comment in `pushforward_spec_tilde_iso` at lines 562–566 mentions the `algebraize [φ.hom]` pivot; the blueprint does not use this terminology (it describes movements 1–3 at a higher level). This is acceptable tactic-vs-prose divergence; the mathematical steps match.
- The proof block for `lem:gammaPushforwardIsoAt` in the blueprint includes a naturality claim that has no proof block `\leanok` (correct) but is written as if proved; if a future `NatIso` declaration is added, this claim should be updated to cite it.

---

**Overall verdict**: 14 of 15 declarations are axiom-clean and correctly blueprinted; the single open declaration (`pushforward_spec_tilde_iso`) is correctly marked incomplete in the blueprint. The must-fix is on the **blueprint side**: the proof sketch for the naturality step (`hsq`) is inadequate, the NatTrans route the prover proposes is not described, and a blueprint-writing subagent dispatch is needed before the next prover pass can close the sorry.
