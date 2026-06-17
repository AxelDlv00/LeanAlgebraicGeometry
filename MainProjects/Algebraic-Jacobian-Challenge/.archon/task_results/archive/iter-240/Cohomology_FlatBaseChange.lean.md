# Cohomology/FlatBaseChange.lean

## `pushforward_spec_tilde_iso` — the `hloc` discharge (was L572, now the `hsq` naturality square)

### Attempt (iter-240): `algebraize` pivot + `of_linearEquiv` transport — PARTIAL (large verified scaffold; one residual)

**Approach (per objectives / `analogies/fbc-qc.md`):** discharge the `hloc` obligation
(`IsLocalizedModule (powers a) ρ`, where `ρ` is the structure-sheaf restriction `Γ(N,⊤) → Γ(N,D a)`
of `N = (Spec φ)_* (M^~)`) by transporting a localization across the open-indexed comparison isos
`gammaPushforwardIsoAt`.

**What LANDED and is verified (axiom-clean, compiles):**
1. **`algebraize [φ.hom]`** runs at the sorry and installs `Algebra ↑R ↑R'` (= `φ.hom.toAlgebra`). The
   `Module.compHom` letI mechanism is confirmed DEAD; `algebraize` is the right one.
2. **`hGloc`** — `IsLocalizedModule (powers a) (σmor.hom.restrictScalars R)` via
   `@IsLocalizedModule.powers_restrictScalars` applied with **explicit** instance args
   (`mTop`/`mDa` = `Module R` on the bare section carriers, re-exposed from the
   `(restrictScalars φ.hom).obj` bundled instances by `inferInstanceAs`; `tTop`/`tDa` = the
   `IsScalarTower` instances). Ordinary TC does NOT auto-pick `mTop`; the `@`-application with the
   instances passed positionally is required. `Algebra.algebraMapSubmonoid_powers` + `himg` convert
   `powers (φ a)` ↔ `algebraMapSubmonoid R' (powers a)`, fed `tildeRestriction_isLocalizedModule M (φ a)`.
3. **Structural exposures `hρ'`, `hσ'`** — BOTH hold **by `rfl`**:
   - `σmor = (restrictScalars gsR').map tForget`
   - `ρ = (restrictScalars gsR).map ((restrictScalars pushTop).map tForget)`
   where `tForget` is the `forgetToSheafModuleCat` restriction of `tilde M` over the **preimage** opens
   (`(Spec.map φ)⁻¹ D(a) = D(φ a)` and `⁻¹ ⊤ = ⊤` are both `rfl`,
   `AlgebraicGeometry.SpecMap_preimage_basicOpen`). This confirms the `modulesSpecToSheaf`/pushforward
   peeling through `restrictScalars` is definitional — a key de-risking fact.
4. **`hG`**: `IsLocalizedModule (powers a) Gmor.hom := hGloc` (defeq; `Gmor = (restrictScalars φ.hom).map σmor`).
5. **`key` + transport**: `ρ.hom = e₂.symm ∘ₗ (Gmor.hom ∘ₗ e₁)` (from the square `hsq` via `Iso.eq_comp_inv`
   + `rw [hρ]; rfl`), then `IsLocalizedModule.of_linearEquiv_right` + `of_linearEquiv` close the goal.
   **This whole tail compiles** given `hsq`.
6. **`nat1`** — `ModuleCat.restrictScalarsComp'App_inv_naturality (gsR) (pushTop) _ rfl tForget`,
   the EXACT first of the three naturality squares, typechecks in context.

**The ONE residual = `hsq`** : `ρ ≫ e₂.hom = e₁.hom ≫ Gmor`, the **naturality in the open** of
`gammaPushforwardIsoAt`. After `rw [he₁,he₂,hGmor,hρ',hσ']; simp only [gammaPushforwardIsoAt, Iso.trans_hom,
Iso.symm_hom]` it is, term-for-term, the composite of THREE squares:
  (1) `nat1` (inv-naturality of the `gsR`/`pushTop` `restrictScalarsComp'App`),
  (2) `eqToHom`-naturality for `hcomp : pushTop ∘ gsR = gsR' ∘ φ`,
  (3) `restrictScalarsComp'App_hom_naturality` for `φ`/`gsR'`.

### Dead-end warning (the residual's blocker — for the next prover)

Every rewrite mechanism (`rw [nat1]`, `rw [reassoc_of% nat1]`, `simp only [..._inv_naturality_assoc]`,
`slice_lhs`, `conv_lhs => rw [← Category.assoc]`, `set X ... ; rw [← Category.assoc X, nat1]`) **FAILS to
unify** the `restrictScalarsComp'App _ _ _ _ _ .inv` subterm in the unfolded goal against `nat1`'s LHS,
**even though they print identically and `nat1` typechecks**. The `set X` route got closest (it folds the
first factor) but `nat1` (created before `set`) then also gets folded by `set`, and the subsequent rewrite
still fails — strongly suggesting a **representational/universe-level discrepancy** between the App that
`gammaPushforwardIsoAt` bakes in (it is built inside a `by`-block with `set`s) and a freshly-applied
`restrictScalarsComp'App`. NOTE: `lean_diagnostic_messages` over a line *range* can be STALE/partial — it
reported "no errors" for a range that excluded the failing `rw` line; always confirm with `lake env lean`.

### Concrete next steps (ranked)

1. **Repackage `gammaPushforwardIsoAt` as a genuine `NatIso`** (component-wise via `NatIso.ofComponents`
   of the per-open iso). Then naturality in the open is the `naturality` field / `NatTrans.naturality`,
   definitional — sidestepping the `App.inv` rewrite-matching entirely. `gammaPushforwardIsoAt` lives in
   THIS file, so it can be refactored; its only consumers (`gammaPushforwardTildeIso`,
   `pushforward_spec_tilde_iso_of_isLocalizedModule`) use only `.app U`, which `NatIso` provides.
2. **Mathlib bump (#37189, `isIso_fromTildeΓ_pushforward`)** — the recorded HARD reversing-signal step;
   collapses the whole def to ~3 lines. The current pin (`b80f227`) lacks `IsLocalizing`,
   `isLocalizing_pushforward_of_isLocalizing`, `pushforwardCompModulesSpecToSheafIso`,
   `isIso_fromTildeΓ_pushforward` (verified absent via `lean_local_search`).
3. Element-wise close of `hsq` (the App `.hom`/`.inv` ARE identity on elements:
   `restrictScalarsComp'App_hom_apply`/`_inv_apply`) — blocked previously on (a) breaking
   `ModuleCat.Hom.hom (f ≫ g) x` into element form, and (b) an `eqToHom`-applied-to-element identity
   lemma (the `eqToHom` is between equal-carrier `restrictScalars` objects, so it IS the identity, but no
   off-the-shelf `ModuleCat.eqToHom_apply` was found).

`flatBaseChange_pushforward_isIso` (L702) and `affineBaseChange_pushforward_iso` (L669) left untouched
(documented; the latter additionally needs the pullback/`cancelBaseChange` dictionary, independent of this brick).

## Summary

- **Sorry count: 3 → 3** (no net drop). The L572 `hloc` sorry is REPLACED by ~70 lines of verified proof
  reducing it to a single `sorry` (`hsq`, the `gammaPushforwardIsoAt` open-naturality square).
- Closed: none fully. Still open: `pushforward_spec_tilde_iso` (now via `hsq`), `affineBaseChange_pushforward_iso`,
  `flatBaseChange_pushforward_isIso`.
- Adjacent sorries (`affineBaseChange`, `flatBaseChange`) NOT attempted (out of scope this iter / documented gaps).
- File compiles cleanly (`lake env lean` ✓, no errors, no new axioms).

## Why I stopped

**Partial progress (measurable code).** I did NOT just decompose into commented sorries — I added a large
genuinely-verified proof: `algebraize` works (the iter-objective pivot, confirmed), `powers_restrictScalars`
applies via the `@`-explicit-instance + `inferInstanceAs` carrier-wall workaround (`hGloc`/`hG`), the
structural exposures `hρ'`/`hσ'` are `rfl` (confirming the pushforward/`modulesSpecToSheaf` peeling is
definitional — a strong de-risking result), and the full `of_linearEquiv` transport (`key` + the two
`of_linearEquiv` calls) compiles given `hsq`. `nat1` (the exact inv-naturality equation) typechecks.

The single remaining `sorry` (`hsq`) is a pure naturality square whose 3-lemma decomposition is identified
and partially in hand (`nat1`), blocked by a Lean rewrite-matching pathology (the `restrictScalarsComp'App`
from a tactic-built def won't unify with a fresh application despite printing identically — likely
universe/representational). I attempted ~15 distinct tactic forms (rw/simp/slice/conv/reassoc/explicit
construction/element-wise); all fail at the same unification. The documented fix (repackage
`gammaPushforwardIsoAt` as a `NatIso`, making naturality definitional) is a clean next step, as is the
Mathlib bump. I restored the file to a clean compiling state after a mid-attempt break.
