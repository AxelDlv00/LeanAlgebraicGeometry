# Lean ↔ Blueprint Check Report

## Slug
dualinv254

## Iteration
254

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
  (focus: `lem:dual_restrict_iso`, `lem:dual_unit_iso`, `lem:dual_isLocallyTrivial`,
  `lem:scheme_modules_hom_local_section`, `lem:sheafofmodules_hom_of_local_compat`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `lem:dual_restrict_iso`)
- **Lean target exists**: yes (line 230)
- **Signature matches**: yes — `(dual M).restrict f ≅ dual (M.restrict f)` for `f : Y ⟶ X` an open immersion, natural in `M`. Matches the blueprint's "canonical isomorphism (dual M)|_f ≃ dual(M|_f)".
- **Proof follows sketch**: partial — Steps 1–3 (`restrictFunctorIsoPullback` ≪≫ `sheafificationCompPullback` ≪≫ `sheafification.mapIso`) plus H1 (`pushforwardPushforwardAdj`∘`leftAdjointUniq`) are assembled and compile. Step 4 ("close `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`") has one `sorry` at line 256. The blueprint's `\leanok` on the statement block (but NOT on the proof block) is correct.
- **Notes**: Step 4 is the acknowledged open residual from iter-251. No new sorry introduced this iteration. The two-leg (A: slice-site Hom base-change; B: ground-ring reconciliation via `restrictScalarsRingIsoDualEquiv`) description in the blueprint proof (lines 5513–5567) accurately describes what Step 4 must build.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `lem:dual_unit_iso`)
- **Lean target exists**: yes (line 274)
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`. Matches the blueprint's `dual O_Y ≅ O_Y`.
- **Proof follows sketch**: yes — sheafifies `presheafDualUnitIso` (= `dualUnitIsoGen`) via `sheafification.mapIso`, then appends the sheafification counit. The blueprint's sketch ("sheafify the evaluation-at-1 isomorphism Hom(1,1)≅1") is faithfully implemented via the inline presheaf-level `dualUnitIsoGen` + `sheafificationAdjunction.counit`.
- **Notes**: `dual_unit_iso` appears axiom-clean (no `sorry` in it or its local dependencies `presheafDualUnitIso`/`dualUnitIsoGen`). The blueprint's proof block has no `\leanok` — this is a `sync_leanok` artifact (not a manual must-fix), since `dual_unit_iso` is actually fully proved.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `lem:dual_isLocallyTrivial`)
- **Lean target exists**: yes (line 332)
- **Signature matches**: yes — `LineBundle.IsLocallyTrivial L → LineBundle.IsLocallyTrivial (dual L)`. Matches the blueprint exactly.
- **Proof follows sketch**: yes — three-step chain at line 341: `dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso`. Matches blueprint's Steps 1–3 exactly. Transitively sorry-bearing via `dual_restrict_iso`.
- **Notes**: `\leanok` on the statement block is correct (transitive sorry). No sorry directly in this declaration.

### `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` (chapter: `lem:scheme_modules_hom_local_section`)
- **Lean target exists**: yes (line 355)
- **Signature matches**: yes — produces an element of `(presheafHom M.val.presheaf N.val.presheaf).obj (op (U i))` from a local morphism `f i`. The blueprint's description matches.
- **Proof follows sketch**: yes — the `app` field is the eqToHom-conjugated triple composite; the `naturality` field uses `Subsingleton.elim` on the thin poset. The blueprint's proof ("thin poset naturality automatic by Subsingleton.elim") is exactly what the Lean does.
- **Notes**: No sorry. The `\leanok` on statement block is correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `lem:sheafofmodules_hom_of_local_compat`)
- **Lean target exists**: yes (line 512)
- **Signature matches**: yes — see **critical analysis of `hf` below**.
- **Proof follows sketch**: partial
  - Sub-step (a): ✓ closed at lines 543–559 via `exact hf i j W.left _ _`
  - Sub-step (b): ✓ assembled at line 563 (`topSectionToHom (hsup ▸ (hglue hcompat).choose)`)
  - Sub-step (c) sectionwise linearity: sorry at line 636 — one acknowledged residual (open-immersion ring-bridge: transporting the `X`-scalar through `(U i).ι.appIso` to invoke `f i`-linearity).
  - Sub-step (d) restriction recovery: implicit in the `hconn` lemma (lines 582–600), used to reduce (c) to local linearity.
- **Notes**: `\leanok` on statement block is correct. The sub-step decomposition (a–d) + Step (ii) promotion via `homMk` matches the blueprint precisely.

---

## Critical analysis: `hf` compatibility hypothesis (the iter-254 re-sign)

**Directive question**: does the blueprint still describe the old `HEq` form? If so, flag blueprint→Lean mismatch.

**Finding: No mismatch. The blueprint correctly describes the sectionwise form.**

Blueprint lines 5847–5874 (proof of `lem:sheafofmodules_hom_of_local_compat`):
- Lines 5848–5856: explicitly states the sectionwise hypothesis — "for all i, j and every open V with V ⊆ Ui and V ⊆ Uj, the two section maps (fi).app(V) and (fj).app(V) agree as morphisms in the fixed abelian-group hom-type M(V)→N(V)".
- Lines 5861–5874: explicitly rejects the old HEq/pullback-images form — "these two morphisms do not live in a common type at all...no HEq-elimination applies...no caller can produce such a datum in the first place".

The Lean's `hf` (lines 515–521) is the full eqToHom-conjugated form:
```
M.val.presheaf.map(eqToHom(image_preimage_of_le (U i) hVi).symm) ≫
  ((PresheafOfModules.toPresheaf _).map (f i).val).app(op((U i).ι ⁻¹ᵁ V)) ≫
  N.val.presheaf.map(eqToHom(image_preimage_of_le (U i) hVi))
= [same with j]
```

This agrees with the blueprint's description. The blueprint's phrase at line 5886 — "the sectionwise hypothesis equates the two middle terms (fi).app and (fj).app directly" — is an informal shorthand meaning "after conjugating both sides to M(V)→N(V) by eqToHom, the results agree"; the Lean's `hf` IS this full conjugated equality, which is the canonical way to compare things in the fixed type M(V)→N(V). The blueprint does not claim the hypothesis is a bare app-equality without eqToHom (that would be ill-typed since app components live at V' = ι⁻¹V, not V). **No blueprint→Lean mismatch on `hf`.**

**Minor imprecision in blueprint proof (line 5886)**: The phrase "equates the two middle terms...directly" could be misread as suggesting a simpler hypothesis `(fi).app(V') = (fj).app(V')` (in different types). The Lean's `hf` correctly includes the eqToHom conjugation on both sides; the blueprint should clarify that by "equates the middle terms" it means "in the fixed type M(V)→N(V) via the eqToHom conjugates". This is **minor** — a potential source of confusion for a future prover, not a current blocking issue.

---

## Red flags

### Placeholder / suspect bodies
- `dual_restrict_iso` at line 256: `:= sorry` for Step 4 — **acknowledged residual** documented in the module docstring and the lemma planner-strategy block. Blueprint's statement `\leanok` (no proof `\leanok`) is consistent. Not a new placeholder.
- `homOfLocalCompat` at line 636: `:= sorry` for sub-step (c) ring-bridge — **acknowledged residual**. Blueprint's statement `\leanok` (no proof `\leanok`) is consistent. The comment describes exactly what remains (open-immersion ring-bridge via `appIso`). Not a new placeholder.

### Excuse-comments
None found. The `sorry`-bearing comments describe genuine mathematical gaps with precise statements of what remains; they are not "this is wrong but works for now"-style excuses.

### Axioms / Classical.choice on non-trivial claims
None found.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` reference in the blueprint:

| Declaration | Location | Assessment |
|---|---|---|
| `PresheafOfModules.unitDualSectionEquiv` | line 63 | Core sectionwise equiv for `dualUnitIsoGen`; the blueprint's proof sketch for `lem:dual_unit_iso` refers to the idea ("evaluation at 1 / scalar-multiplication inverse") but does not pin the Lean name. Borderline — could add a sub-lemma entry. |
| `PresheafOfModules.dualUnitIsoGen` | line 105 | The presheaf-level `dual 𝟙_ ≅ 𝟙_`; the blueprint mentions "the presheaf-level evaluation-at-1 isomorphism Hom(1,1)≅1" without a Lean name. Warrants a `\lean{}` entry as an intermediate lemma. |
| `presheafDualUnitIso` | line 263 | Thin wrapper specialising `dualUnitIsoGen` to a scheme's presheaf; purely local bookkeeping. Acceptable as unlisted helper. |
| `topSectionToHom` | line 412 | Converts a `presheafHom` top-section into a morphism; blueprint mentions `presheafHomSectionsEquiv` / `sheafHomSectionsEquiv` as the route but does not pin this wrapper. Acceptable as unlisted helper; blueprint adequacy note below. |
| `topSectionToHom_app` | line 425 | Component lemma for `topSectionToHom`; a supporting sub-lemma. Acceptable as unlisted helper. |
| `image_preimage_of_le` | line 436 | Standalone infrastructure lemma: `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V` for `V ≤ W`. Blueprint's proof mentions "the down-set identity ι(ι⁻¹V) = V" (lines 5441–5444 and 5814–5816) without a `\lean{}` pin. This lemma is used critically in `homLocalSection` and `homOfLocalCompat`. Borderline — adding a small note or `\lean{}` hint would help future provers. |

---

## Blueprint adequacy for this file

- **Coverage**: 5 of 12 Lean declarations have a `\lean{...}` block in the chapter. The 7 unreferenced declarations are either thin wrappers (`presheafDualUnitIso`) or supporting sub-lemmas (`topSectionToHom`, `topSectionToHom_app`, `image_preimage_of_le`, `unitDualSectionEquiv`). One borderline case: `dualUnitIsoGen` (the presheaf-level dual-unit isomorphism) is substantive enough to warrant a blueprint sub-lemma entry.
- **Proof-sketch depth**: **adequate** for the major declarations. The proofs of `dual_restrict_iso` (Steps 1–4), `dual_isLocallyTrivial` (three-step chain), and `homOfLocalCompat` (sub-steps a–d + Step ii) are described with enough detail to guide formalization. The description of `homOfLocalCompat`'s sub-step (c) as "mechanical" slightly undersells the genuine ring-bridge work still open (the `appIso`-transport of scalars across the open immersion), but this does not constitute an adequacy failure.
- **Hint precision**: **precise** — all `\lean{...}` hints name the correct Lean declarations.
- **Generality**: **matches need** — no narrowing or widening issues observed.
- **Recommended chapter-side actions** (non-blocking):
  - Add a sub-lemma entry for `PresheafOfModules.dualUnitIsoGen` under `lem:dual_unit_iso`, giving it a `\lean{}` pin.
  - Add a brief `\lean{AlgebraicGeometry.Scheme.Modules.image_preimage_of_le}` note or inline remark in the `lem:scheme_modules_hom_local_section` proof (where "the down-set identity ι(ι⁻¹V) = V" is cited) to pin the infrastructure lemma.
  - Clarify blueprint proof line 5886 ("equates the two middle terms directly") to say "equates the two eqToHom-conjugated composites in the fixed type M(V)→N(V)", avoiding the ambiguity about whether eqToHom is or is not in the hypothesis.
  - Trigger `sync_leanok` for the proof block of `lem:dual_unit_iso` — `dual_unit_iso` is axiom-clean but the proof block is missing `\leanok`.

---

## Severity summary

- **must-fix-this-iter**: **none**
- **major**: none
- **minor**:
  - Blueprint proof line 5886 imprecision on "equates the middle terms directly" (could mislead a future prover about whether eqToHom is in `hf`).
  - `dualUnitIsoGen` is a substantive presheaf-level iso with no blueprint `\lean{}` pin; blueprint for `lem:dual_unit_iso` is slightly thin on the presheaf component.
  - `image_preimage_of_le` is a standalone infrastructure lemma cited implicitly but not pinned.
  - `lem:dual_unit_iso` proof block missing `\leanok` (sync artifact, not manual error).

**Overall verdict**: The Lean file and blueprint are consistent — the re-signed `hf` sectionwise form matches what the blueprint describes, both the acknowledgement that `HEq` fails and the correct sectionwise formulation; sub-step (a) is confirmed closed; one sorry remains in `homOfLocalCompat` sub-step (c) (ring-bridge, correctly documented) and one in `dual_restrict_iso` Step 4 (unchanged from prior iter); no must-fix items.
