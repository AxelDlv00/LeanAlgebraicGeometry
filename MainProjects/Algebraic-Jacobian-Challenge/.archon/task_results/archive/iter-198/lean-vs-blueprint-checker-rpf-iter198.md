# Lean ↔ Blueprint Check Report

## Slug
rpf-iter198

## Iteration
198

## Files audited
- Lean: `AlgebraicJacobian/Picard/RelPicFunctor.lean`
- Blueprint: `blueprint/src/chapters/Picard_RelPicFunctor.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup}` (chapter: `lem:rel_pic_sharp_groupoid`)
- **Lean target exists**: yes (L235–269)
- **Signature matches**: yes — `AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))` matches the chapter's "quotient set inherits a canonical abelian-group structure"
- **Proof follows sketch**: no — body is `exact sorry`; blueprint proof describes the tensor-product construction via `QuotientAddGroup` on `π_T^* Pic(T) ≤ Pic(C×T)`, which is not realized
- **Notes**: acknowledged upstream gate (Scheme.Modules monoidal-structure gap, correctly described in the Gate annotation, iter-198 refresh). Statement `\leanok` is correct (sorry present); proof block has no `\leanok` (correct). Detailed TODO comment at L238–268 explains the intended construction.

### `\lean{AlgebraicGeometry.Scheme.PicSharp}` (chapter: `def:rel_pic_sharp`)
- **Lean target exists**: yes (L327–330)
- **Signature matches**: yes — `(Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1}` is the correct functor type; iter-199+ can swap the body without touching the signature
- **Proof follows sketch**: no — body is `(Functor.const _).obj (AddCommGrpCat.of PUnit.{u+2})`, the constant functor at the trivial group; chapter says `T ↦ Pic(C×_k T)/π_T^* Pic(T)` with the group structure of `addCommGroup`
- **Notes**: sorry-free but placeholder (axiom set: kernel triple only). Definition has `\leanok`; no separate proof block in blueprint (definition-style block). Excuse-comment at L313–326 explains the placeholder. Constant functor is NOT a reparameterization of `Pic^♯` — it collapses the mathematical content to the trivial group uniformly.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.functorial}` (chapter: `lem:rel_pic_sharp_functorial`)
- **Lean target exists**: yes (L372–377)
- **Signature matches**: yes — `Quotient (preimage_subgroup πC πT) →+ Quotient (preimage_subgroup πC πT')` correctly captures "AddMonoidHom between quotients"; iter-199+ can swap body without touching the signature
- **Proof follows sketch**: no — body is `0` (zero AddMonoidHom); chapter proof describes `g_C^* : Pic(C×T) → Pic(C×T')` preserving tensor products, descending to a group homomorphism on quotients
- **Notes**: inherits `sorryAx` from `addCommGroup` (the `Zero (Q →+ Q')` instance chains through the sorry-body `addCommGroup`); `lem:rel_pic_sharp_functorial` statement has `\leanok` (correct — sorry present via inheritance); proof block has no `\leanok` (correct). Excuse-comment at L360–371. Minor generalization: blueprint is `k`-scheme specific; Lean signature uses a general base scheme `S` — not a mismatch but a slight generalization of scope.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.presheaf}` (chapter: `thm:rel_pic_sharp_presheaf`)
- **Lean target exists**: yes (L421–424)
- **Signature matches**: yes — `(Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1}`; iter-199+ can swap body without signature edits
- **Proof follows sketch**: no — body is `PicSharp _C`, which is itself the constant-functor placeholder; chapter proof assembles `addCommGroup + PicSharp + functorial` into a functor satisfying identity/composition laws on `Quotient (preimage_subgroup ...)` data
- **Notes**: sorry-free (axiom set: kernel triple only, does not chain through `addCommGroup` at the body level). Statement `\leanok` present; proof block currently lacks `\leanok`. **Semantic laundering risk (see §Red flags)**: if sync_leanok's sorry counter sees 0 sorries for `presheaf`, it will add `\leanok` to the `thm:rel_pic_sharp_presheaf` proof block, claiming the proof is closed when the body is a placeholder. Excuse-comment at L409–415.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.etSheaf}` (chapter: `def:rel_pic_etale_sheafification`)
- **Lean target exists**: yes (L486–490)
- **Signature matches**: yes — `Sheaf J AddCommGrpCat.{u+1}` is correct; iter-199+ can swap body without signature edits
- **Proof follows sketch**: partial — body correctly applies `(presheafToSheaf J AddCommGrpCat).obj` to the presheaf, which is the right sheafification machinery; but the presheaf input is `PicSharp.presheaf _C` = the constant-functor placeholder, so the sheafification produces the sheafification of the trivial group, not `Pic^♯_{(C/k)ét}`
- **Notes**: sorry-free (kernel triple); no separate proof block in blueprint (definition-style block), so no proof `\leanok` risk. Definition `\leanok` present. Structurally most faithful of the five closures — the sheafification functor is wired correctly; only the input is wrong.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.etSheaf_group_structure}` (chapter: `thm:rel_pic_etale_sheaf_group_structure`)
- **Lean target exists**: yes (L539–544)
- **Signature matches**: partial / weakened — Lean type is `Nonempty (PicSharp.presheaf C ⟶ (PicSharp.etSheaf C J).obj)`; chapter prose describes "the canonical morphism `Pic^♯_{C/k} → Pic^♯_{(C/k)ét}` that is a homomorphism of group presheaves and exhibits the universal property of sheafification." The intended type is the morphism itself (or at least an explicit `→` type recording it as a group-presheaf morphism), not merely `Nonempty` of its existence; the universal-property content is entirely absent from the Lean type
- **Proof follows sketch**: no — body is `⟨0⟩` (zero natural transformation as existence witness); chapter proof describes the plus-construction commuting with the forgetful functor `AddCommGrpCat → Set`, yielding the canonical sheafification unit `toSheafify`
- **Notes**: sorry-free (kernel triple); theorem has `\leanok` on statement block; proof block currently lacks `\leanok`. **Semantic laundering risk (see §Red flags)**. Stale Lean file comment at L505–508 says "This statement does NOT have an explicit `\lean{...}` pin in the blueprint" — this is now incorrect; the blueprint added the pin (`\lean{AlgebraicGeometry.Scheme.PicSharp.etSheaf_group_structure}`) as part of the iter-198 rename from `etSheafUnit`. Excuse-comment at L525–538.

---

## Red flags

### Placeholder / suspect bodies

1. **`PicSharp.addCommGroup`** at L269: body is `exact sorry`; blueprint `lem:rel_pic_sharp_groupoid` claims a substantive abelian-group structure on `Quotient (preimage_subgroup πC πT)` via tensor product. Gate: Scheme.Modules monoidal structure missing from Mathlib at `b80f227`.

2. **`PicSharp`** at L330: body is `(Functor.const _).obj (AddCommGrpCat.of PUnit.{u+2})` — a constant functor at the trivial group. Blueprint `def:rel_pic_sharp` claims the functor `T ↦ Pic(C×_k T)/π_T^* Pic(T)`. Constant PUnit functor ≠ relative Picard functor; this collapses every stalk to the trivial group. Type is signature-preserving (`(Over k)^op ⥤ AddCommGrpCat`) so iter-199+ can substitute the correct body, but the present body is a structurally different mathematical object.

3. **`PicSharp.functorial`** at L377: body is `0` (zero AddMonoidHom). Blueprint `lem:rel_pic_sharp_functorial` claims the map descended from `g_C^* = (id_C ×_k g)^*`. Zero map is not the pullback-descended map.

4. **`PicSharp.presheaf`** at L424: body is `PicSharp _C`, re-exporting the constant-functor placeholder of (2). Blueprint `thm:rel_pic_sharp_presheaf` claims the actual bundled group-valued presheaf.

5. **`PicSharp.etSheaf`** at L490: applies the correct `presheafToSheaf J AddCommGrpCat` machinery to the wrong input (constant-functor placeholder). Output is the sheafification of the trivial group, not `Pic^♯_{(C/k)ét}`.

6. **`PicSharp.etSheaf_group_structure`** at L544: body `⟨0⟩` witnesses `Nonempty` via the zero morphism. The zero morphism is NOT the sheafification unit `toSheafify`; it is a trivially-valid existence witness with no mathematical content beyond "AddCommGrpCat has zero morphisms."

### Excuse-comments

- `RelPicFunctor.lean:313–326`: "iter-198 Lane RPF closure: the body is a `Functor.const`-style trivial functor at `AddCommGrpCat.of PUnit.{u+2}`" — explicit placeholder explanation for `PicSharp`.
- `RelPicFunctor.lean:360–371`: "iter-198 Lane RPF closure: the body is the zero AddMonoidHom" — explicit placeholder for `functorial`.
- `RelPicFunctor.lean:409–415`: "iter-198 Lane RPF closure: the body re-exports `PicSharp _C`" — explicit placeholder for `presheaf`.
- `RelPicFunctor.lean:525–538`: "iter-198 Lane RPF closure: we witness the `Nonempty` via the zero natural transformation" — explicit placeholder for `etSheaf_group_structure`.
- `RelPicFunctor.lean:505–508`: stale comment "This statement does NOT have an explicit `\lean{...}` pin in the blueprint" — blueprint now DOES have the pin (added iter-198 with the rename). Not an excuse-comment, but a factual error left over from pre-iter-198 state.

### Semantic laundering risk (not yet materialized)

`PicSharp.presheaf` and `PicSharp.etSheaf_group_structure` are sorry-free (axiom sets: `{propext, Classical.choice, Quot.sound}` — kernel only, no `sorryAx`). The chapter has `\begin{proof}...\end{proof}` blocks for both `thm:rel_pic_sharp_presheaf` (L273) and `thm:rel_pic_etale_sheaf_group_structure` (L407), neither of which currently has `\leanok`. **If sync_leanok's sorry count uses source-level sorry detection rather than transitive `#print axioms` analysis**, it will find 0 sorries in `presheaf` and `etSheaf_group_structure` and add `\leanok` to those proof blocks on the next sync. This would semantically launder — claiming the proofs are closed when the bodies are placeholder constructions that do not realize the chapter's intended mathematical content.

Current state: proof blocks correctly lack `\leanok`. This finding is classified as **major** (imminent risk requiring a protective measure in iter-199, e.g., an explicit `% \notready` annotation or a mechanism to prevent sync_leanok from promoting these proof blocks).

### Type weakening

`PicSharp.etSheaf_group_structure` (L539–544): type is `Nonempty (presheaf C ⟶ (etSheaf C J).obj)`. The chapter `thm:rel_pic_etale_sheaf_group_structure` claims the canonical morphism with universal property (sheafification unit `toSheafify`). `Nonempty` captures only existence of SOME morphism — the canonical choice and the universal property are absent from the type. This is a signature weakening, not a signature-preserving placeholder. To restore the intended content, the type must change from `Nonempty (...)` to the actual morphism type (e.g., `presheaf C ⟶ (etSheaf C J).obj`, possibly with an additional universal-property statement), which requires iter-199 edits to both the type and the proof.

---

## Unreferenced declarations (informational)

The file's module docstring (L1–174) is not a declaration. All six substantive declarations are `\lean{...}`-referenced in the chapter:
- `PicSharp.addCommGroup` → `lem:rel_pic_sharp_groupoid`
- `PicSharp` → `def:rel_pic_sharp`
- `PicSharp.functorial` → `lem:rel_pic_sharp_functorial`
- `PicSharp.presheaf` → `thm:rel_pic_sharp_presheaf`
- `PicSharp.etSheaf` → `def:rel_pic_etale_sheafification`
- `PicSharp.etSheaf_group_structure` → `thm:rel_pic_etale_sheaf_group_structure`

No unreferenced substantive declarations. Coverage 6/6.

---

## Blueprint adequacy for this file

- **Coverage**: 6/6 Lean declarations have a `\lean{...}` block in the chapter. No unreferenced declarations. Full coverage.

- **Proof-sketch depth**: adequate. The chapter provides mathematically complete proof sketches for all lemma/theorem blocks: the tensor-product abelian-group structure argument (`lem:rel_pic_sharp_groupoid`), the group-hom naturality via `g_C^*` preserving tensor products (`lem:rel_pic_sharp_functorial`), the functor assembly (`thm:rel_pic_sharp_presheaf`), and the plus-construction argument for the sheafification unit (`thm:rel_pic_etale_sheaf_group_structure`). These sketches are detailed enough for a prover to formalize once the `addCommGroup` upstream gate is closed.

- **Hint precision**: precise. All `\lean{...}` pins name the correct Lean identifiers. The iter-198 rename from `etSheafUnit` to `etSheaf_group_structure` is correctly reflected. The `\lean{AlgebraicGeometry.Scheme.PicSharp}` pin correctly identifies the noncomputable def.

- **Gate annotation accuracy**: the Gate annotation (iter-198 refresh, blueprint L529–582) correctly identifies:
  - `LineBundle.OnProduct` carrier: **closed** in iter-188 ✓ (no stale reference to the old gate)
  - Actual residual gate: `Scheme.Modules` monoidal-structure gap at Mathlib `b80f227` ✓
  - Five placeholder closures: explicitly acknowledged ✓

- **Type adequacy concern**: the chapter's description of `thm:rel_pic_etale_sheaf_group_structure` implies the full sheafification unit with universal property, but the Lean encoding section (L503–527) only describes the type as `Nonempty (...)`. The blueprint prose and the Lean encoding section are internally inconsistent: the theorem statement block says "canonical morphism... is a homomorphism of group presheaves" (which implies a richer type), while the Lean encoding says this is a `Nonempty`. The blueprint should be updated to either (a) weaken the stated type to match `Nonempty (...)` and add a separate stronger declaration for the universal property, or (b) upgrade the Lean type to the full morphism type.

- **Generality**: matches need for 5 of 6 declarations. `PicSharp.functorial` uses a more general base scheme `S` (rather than `Spec k`) — a harmless strengthening, not a gap.

- **Recommended chapter-side actions**:
  1. Resolve the internal inconsistency in `thm:rel_pic_etale_sheaf_group_structure`: either (a) change the `\begin{theorem}` statement to explicitly say the Lean type is `Nonempty (...)` (existence of SOME morphism, not the canonical one), or (b) add a separate stronger theorem for the universal property once the upstream gate is closed.
  2. After `addCommGroup` is filled: add a `% NOTE: iter-NNN — placeholder proof blocks below ready for \leanok once presheaf and etSheaf_group_structure bodies are replaced` comment near the proof blocks to guard against premature `\leanok` addition by sync_leanok.

---

## Severity summary

### Must-fix-this-iter

1. **`PicSharp.addCommGroup`** (L269): `exact sorry` body on a substantive instance declaration. Gate: Scheme.Modules monoidal gap (upstream Mathlib). Excuse-comment present. Blocks all five downstream declarations.

2. **`PicSharp`** (L330): constant-functor-at-PUnit body. Blueprint claims functor `T ↦ Quotient (preimage_subgroup ...)`. Constant functor at PUnit collapses every stalk to the trivial group — a structurally different mathematical object, not a sorry-placeholder of the intended one. Excuse-comment present.

3. **`PicSharp.functorial`** (L377): zero-AddMonoidHom body. Blueprint claims the pullback-descended group homomorphism. Zero map ≠ pullback map. Inherits `sorryAx`. Excuse-comment present.

4. **`PicSharp.presheaf`** (L424): re-exports constant-functor placeholder. Blueprint claims the bundled group-valued presheaf. Excuse-comment present.

5. **`PicSharp.etSheaf`** (L490): sheafification applied to wrong (trivial-group) presheaf. Blueprint claims sheafification of the actual Picard presheaf. Structurally partial but semantically wrong.

6. **`PicSharp.etSheaf_group_structure`** (L539–544): type weakened from the sheafification unit (with universal property) to `Nonempty (...)` of SOME morphism. Body is the zero morphism. Both the type and the body deviate from the chapter's stated claim. Excuse-comment present.

### Major

7. **Semantic laundering risk**: `PicSharp.presheaf` and `PicSharp.etSheaf_group_structure` are sorry-free (no `sorryAx`). If sync_leanok uses source-level sorry counting, it will add `\leanok` to the proof blocks of `thm:rel_pic_sharp_presheaf` (blueprint L273) and `thm:rel_pic_etale_sheaf_group_structure` (blueprint L407) on the next sync run, falsely indicating closed proofs. Currently no `\leanok` on those proof blocks — but protective action needed before next sync.

8. **Stale Lean comment** at L505–508: "This statement does NOT have an explicit `\lean{...}` pin in the blueprint" — incorrect since iter-198 added the pin. Should be removed to avoid misleading future provers.

### Minor

9. **`PicSharp.functorial` scope generalization**: Lean signature uses general base scheme `S` while the rest of the file and the chapter are specialized to `Spec k`. Not wrong, but creates a conceptual discontinuity when the placeholders are eventually replaced and the functor laws are assembled.

10. **Blueprint internal inconsistency** in `thm:rel_pic_etale_sheaf_group_structure`: the theorem statement prose says "canonical morphism... homomorphism of group presheaves" (implying a richer type) while the Lean encoding section describes `Nonempty`. Needs blueprint-side resolution.

---

**Overall verdict**: 6 declarations checked, all 6 are must-fix-this-iter due to placeholder/sorry/weakened-type bodies; additionally 1 major semantic-laundering risk and 1 major stale comment; the blueprint is mathematically adequate and its Gate annotation correctly identifies the upstream blocker, but `thm:rel_pic_etale_sheaf_group_structure` carries a type-weakening mismatch that iter-199+ must repair in both the Lean type and the blueprint prose.
