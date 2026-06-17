# Lean Audit Report

## Slug
ts227

## Iteration
227

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 3 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L691** — `isLocallyInjective_whiskerLeft_of_W`: body is `sorry`. Honestly marked. The 30-line body comment (L659–690) accurately names the two residual gaps (d.1-bridge `Opens.grothendieckTopology W`-criterion, d.2 stalk-⊗ commutation) and is consistent with the current known-blockers record. No issue.
  - **L2096** — `exists_tensorObj_inverse`: body is `sorry`. Honestly marked. The docstring + body comment (L2049–2095) accurately enumerates the two remaining bridges: C (`dual_isLocallyTrivial` via `(dual M).restrict f ≅ dual (M.restrict f)`) and A (`homOfLocalCompat` SheafOfModules morphism descent), and correctly describes B (`isIso_of_isIso_restrict`) as already closed. The "FORBIDDEN sheafify-the-presheaf-eval shortcut … DEAD END" warning is consistent with the project memory. No issue.
  - **L2142** — `addCommGroup_via_tensorObj`: body is `sorry`. Honestly marked. Docstring says "iter-202 Lane TS scaffold: typed `sorry`" — this is honest documentation, not an excuse-comment; the closure target is stated precisely. No issue.
  - **Outdated comment — L2070** (body of `exists_tensorObj_inverse`): "mirroring the CLOSED `tensorObj_isLocallyTrivial` **at L1912**". `tensorObj_isLocallyTrivial` currently starts at approximately L1962 (off by ~50 lines). Stale line reference. (Minor.)
  - **Outdated comment — L103–113** (section header `RestrictScalarsRingIsoTensor`): "this ring-iso strong upgrade is absent and is the documented 'REAL bottom gap' (H2) of `tensorObj_restrict_iso`". `tensorObj_restrict_iso` is closed axiom-clean since iter-217 (confirmed at L1848–1849 in the file). The phrase "absent … REAL bottom gap" describes the pre-closure Mathlib state. The `restrictScalarsRingIsoTensorEquiv` / `restrictScalars_isIso_μ` that fill it appear immediately below in the same section, so "absent" can only mean "absent from Mathlib" — but a reader scanning the section header after the closure could be confused. (Minor.)
  - **Outdated comment — L36–95** (module Status block): The block correctly lists three blueprint-pinned declarations and three residual `sorry` bodies, and is otherwise accurate. It does not mention the iter-227 additions `restrictScalarsRingIsoDualEquiv`, `homMk`, `toPresheaf_map_homMk`. These are helper lemmas (not blueprint-pinned), so omission is understandable, but the Status block last updated at iter-224 is incrementally stale. (Minor.)

---

## New declarations — detailed verdict

### `restrictScalarsRingIsoDualEquiv` (~L306–338)

**Genuine. No sorry / admit / stub / maxHeartbeats.**

LSP hover confirms: `restrictScalarsRingIsoDualEquiv.{u} {R S : Type u} [CommRing R] [CommRing S] (e : R ≃+* S) (M : Type u) [AddCommGroup M] [Module S M] : (M →ₗ[S] S) ≃ₗ[R] M →ₗ[R] R`

**Statement matches docstring**: the docstring says "the `R`-linear equivalence `restrictScalars_e (M →ₗ[S] S) ≃ₗ[R] (restrictScalars_e M →ₗ[R] R)`, `φ ↦ e.symm ∘ φ`." The hover type is exactly `(M →ₗ[S] S) ≃ₗ[R] M →ₗ[R] R` (with `R`-module structures on `M →ₗ[S] S` and `M` base-changed via `e` through `letI`). ✓

**Proof correctness**: The `LinearEquiv.ofLinear` construction is explicit:
- Forward `toFun`: `φ ↦ (m ↦ e.symm (φ m))`. `R`-linearity: for `r : R`, `e.symm (φ(r•m)) = e.symm(e(r) • φ m) = e.symm(e(r)) • e.symm(φ m) = r • e.symm(φ m)`. Closed by `rw [hsmulM, map_smul, smul_eq_mul, map_mul, e.symm_apply_apply]`. ✓
- Inverse `invFun`: `ψ ↦ (m ↦ e (ψ m))`. `S`-linearity: for `s : S`, `e(ψ(s•m)) = e(ψ((e.symm s)•m)) = e((e.symm s) • ψ m) = e(e.symm s) • e(ψ m) = s • e(ψ m)`. The proof uses `hsmulM` and `e.apply_symm_apply`. ✓
- `left_inv` / `right_inv`: `e.apply_symm_apply` / `e.symm_apply_apply`. ✓
- `map_add'` / `map_smul'` (for the outer `LinearEquiv` module map over `M →ₗ[S] S`): closed by `simp`+`rw` chains using `map_mul`+`e.symm_apply_apply`. ✓

**No erw abuse**, no instance diamond, no fragile `rfl`. The `hsmulM` helper (`r • m = e r • m` by `rfl`) is definitionally correct because `Module.compHom M e.toRingHom` defines the `R`-action to be `e r • m`.

**Docstring claim "H2′ ingredient of the C-bridge"**: The declaration is new algebra (dual analogue of the tensor `restrictScalarsRingIsoTensorEquiv`), and the claim is forward-looking (the C-bridge itself is still open). The phrasing is accurate: this IS the H2′ ingredient; the C-bridge is not closed yet.

---

### `AlgebraicGeometry.Scheme.Modules.homMk` (~L2034–2039)

**Genuine. No sorry / admit / stub.**

LSP hover confirms signature: `homMk {X : Scheme} {M N : X.Modules} (g : M.val.presheaf ⟶ N.val.presheaf) (hg : sectionwise linearity) : M ⟶ N`.

**Statement matches docstring**: "promote an `Ab`-presheaf morphism to a module morphism." ✓

**Implementation**: `⟨PresheafOfModules.homMk (M₁ := M.val) (M₂ := N.val) g hg⟩`. Wraps the Mathlib declaration `PresheafOfModules.homMk` (confirmed present in `Mathlib.Algebra.Category.ModuleCat.Presheaf`). The wrapper is a one-liner constructor. ✓

**Linearity hypothesis type**: Mathlib's `PresheafOfModules.homMk` expects `(ConcreteCategory.hom (φ.app X)) (r • m) = r • ...`; the wrapper uses `(g.app V).hom (r • m) = r • ...`. For `AddCommGrpCat`, `AddCommGrpCat.Hom.hom = ConcreteCategory.hom` (confirmed by LSP hover showing `AddCommGrpCat.Hom.hom`). The types are compatible. ✓

---

### `AlgebraicGeometry.Scheme.Modules.toPresheaf_map_homMk` (~L2042–2047)

**Genuine. No sorry / admit / stub.**

LSP hover confirms: `(toPresheaf X).map (homMk g hg) = g`.

**Proof is `rfl`**: Definitionally valid — `homMk g hg` constructs a `SheafOfModules.Hom` whose underlying presheaf natural transformation is `PresheafOfModules.homMk g hg`, and `PresheafOfModules.homMk g hg`'s underlying natural transformation is definitionally `g`. `toPresheaf` extracts it, giving `g` by `rfl`. Lean accepted this (no errors). ✓

**`@[simp]` tag**: Appropriate — this is a canonical unfolding of `homMk` for the presheaf component. ✓

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `TensorObjSubstrate.lean:2070` — stale line reference: `"at L1912"` inside the `exists_tensorObj_inverse` body comment, but `tensorObj_isLocallyTrivial` starts at approximately L1962 (~50 lines off). No correctness impact; the name is correct.
- `TensorObjSubstrate.lean:103–113` — section header says the ring-iso strong upgrade "is absent and is the documented 'REAL bottom gap' (H2) of `tensorObj_restrict_iso`". The gap was filled by the immediately-following code; `tensorObj_restrict_iso` has been axiom-clean since iter-217. "Absent" can only mean "absent from Mathlib" (still true), but "REAL bottom gap" language is stale for a gap that is now closed. Low confusion risk but worth a pass when updating the Status block.
- `TensorObjSubstrate.lean:36–95` (Status block) — does not mention the iter-227 additions `restrictScalarsRingIsoDualEquiv`, `homMk`, `toPresheaf_map_homMk`. These are helper lemmas (not blueprint-pinned), so the omission is not wrong, but the block is incrementally stale (last full update at iter-224).

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3 (stale line number, stale section-header "absent" language, Status block not updated for iter-227 additions)
- **excuse-comments**: 0

Overall verdict: File is in good shape — the three new declarations are genuine, axiom-clean, and their statements match their docstrings; the three remaining `sorry` bodies are honestly marked with accurate commentary; no suspect proofs or bad practices introduced.
