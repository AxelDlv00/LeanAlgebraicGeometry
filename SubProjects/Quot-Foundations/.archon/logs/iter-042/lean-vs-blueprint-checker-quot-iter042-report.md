# Lean ↔ Blueprint Check Report

## Slug
quot-iter042

## Iteration
042

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean` (2445 lines)
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration (directive-named blocks)

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent}` (chapter: `lem:qcoh_affine_section_localization`)

- **Lean target exists**: yes — `theorem isLocalizedModule_basicOpen_of_isQuasicoherent` at line 2433 in namespace `AlgebraicGeometry.Scheme.Modules`; full qualified name matches the `\lean{...}` pin exactly.
- **Signature matches**: yes — "for a QC sheaf `M` on `Spec R` and `f : R`, the section restriction `Γ(M, ⊤) → Γ(M, D(f))` is `IsLocalizedModule (Submonoid.powers f)` over `R`" matches the blueprint prose and Lean type.
- **Proof follows sketch**: yes — blueprint says "gap1 (`isIso_fromTildeΓ_of_isQuasicoherent`) makes `M.fromTildeΓ` an iso, then `isLocalizedModule_restrict_of_isIso_fromTildeΓ` delivers all three fields". Lean body at lines 2438–2439 does exactly this: `haveI := isIso_fromTildeΓ_of_isQuasicoherent M; isLocalizedModule_restrict_of_isIso_fromTildeΓ M f`. Mathematical content matches.
- **`\leanok` status**: `\leanok` present on the block (line 2735 of blueprint); consistent with a closed proof.
- **notes**: no issues.

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` (chapter: `lem:qcoh_section_localization_basicOpen`)

- **Lean target exists**: no — no declaration named `isLocalizedModule_basicOpen` exists anywhere in `QuotScheme.lean`. The blueprint has an explicit `% NOTE` at lines 2482–2488 acknowledging this: "the pinned Lean decl … does NOT yet exist (general scheme X, arbitrary quasi-coherent F)." The block has no `\leanok` marker.
- **Signature matches**: N/A (absent).
- **Proof follows sketch**: N/A (absent).
- **notes**: correct state — gap2 is still open as expected. Blueprint acknowledgement is accurate.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent}` (chapter: `lem:qcoh_affine_isIso_fromTildeΓ`)

- **Lean target exists**: yes — line 2417, in `AlgebraicGeometry.Scheme.Modules`. `\leanok` present on the block (line 4216).
- **Signature matches**: yes — "QC sheaf on `Spec R` → `IsIso M.fromTildeΓ`" matches blueprint and Lean type.
- **Proof follows sketch**: yes — one-liner via `isIso_fromTildeΓ_of_isLocalizedModule_restrict` (line 2419–2420), consistent with the blueprint's "fed by `isLocalizedModule_basicOpen_descent` via the equivalence" description.
- **notes**: closed before iter-042; correctly marked in blueprint.

### 4 new helpers added in iter-042 (no blueprint blocks — expected coverage debt)

| Declaration | Line | Namespace | Blueprint block |
|---|---|---|---|
| `restrictₗ` | 2251 | `AlgebraicGeometry.Scheme.Modules` | absent |
| `restrictBasicOpenₗ` | 2267 | `AlgebraicGeometry.Scheme.Modules` | absent |
| `fromSpec_image_top_section_coherence` | 2288 | `AlgebraicGeometry.Scheme.Modules` | absent |
| `section_localization_hfr_aux_general` | 2321 | `AlgebraicGeometry.Scheme.Modules` | absent |

These are confirmed helpers (not private, no sorry, no excuse-comment). Per the directive, their absence from the blueprint is **expected coverage debt** and not a must-fix finding. Severity: **minor**.

---

## Red flags

### Placeholder / suspect bodies

The file contains four `:= sorry` bodies:

| Declaration | Line | Blueprint context |
|---|---|---|
| `hilbertPolynomial` | 126 | `def:hilbert_polynomial` block has `\leanok`; file header says "iter-177+: body fills once χ infrastructure is in scope; for the iter-176 file-skeleton the body is a typed sorry" |
| `QuotFunctor` | 165 | Same: iter-176 file-skeleton sorry, iter-177+ scope |
| `Grassmannian` | 201 | Same |
| `Grassmannian.representable` | 228 | `\leanok` on blueprint block; `% NOTE` at lines 5037–5041 calls it "a weakened existence skeleton" |

These four are **blueprint-authorized file-skeleton stubs** explicitly documented as such in both the Lean docstrings and the blueprint `% NOTE` comments. They are NOT red flags under the checker rules: the blueprint does not claim a substantive proof, and the sorries are present-and-acknowledged.

### Signature weakening (carry-forward)

`Grassmannian.representable` (line 225): the Lean type is
```
∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)
```
while the blueprint prose (`thm:grassmannian_representable`) describes a full theorem including smoothness, properness, relative dimension `d(r-d)`, a tautological rank-`d` quotient, and the Plücker closed embedding. The blueprint `% NOTE` at lines 5037–5041 explicitly acknowledges: "The `\lean{}` pin points at a declaration that under-delivers the prose statement; it should be strengthened or split into a separate skeleton label."

This is a **pre-existing, blueprint-acknowledged** carry-forward from iter-176. Not introduced in iter-042.

**Severity: major** (the `\lean{...}` hint is technically wrong/imprecise relative to the prose, but the blueprint itself flags this).

### Excuse-comments

None found. The `TODO` references in the file (lines 758–871) are prospective fill-in notes for `overEquivalence` continuity facts already proved in those lines — not excuses for incomplete code.

### Axioms / Classical.choice on substantive claims

No `axiom` declarations found. No `Classical.choice` on suspect claims.

---

## Unreferenced declarations (informational)

Beyond the 4 explicitly-listed helpers above, several further non-private declarations in the file lack `\lean{...}` blueprint pins. Spot-checking confirms all substantive "story-level" declarations (all the `isLocalizedModule_*`, `gammaPullback*`, `overRestrict*`, `compositeBasicOpenImmersion*`, `section_localization_hfr_*`, `isIso_fromTildeΓ_*`, etc.) DO have blueprint pins — the complete cross-reference grep returned correct matches for every non-helper. The following are unreferenced but are structurally helpers/instances, not gap-level results:

- `overEquivalence_functor_isCocontinuous`, `overEquivalence_inverse_isCocontinuous`, `overEquivalence_inverse_isDenseSubsite`, `overEquivalence_functor_isContinuous`, `overEquivalence_inverse_isContinuous` — the blueprint pins the aggregate `overEquivalence_sheafCongr` result and the Mathlib `TopologicalSpace.Opens.overEquivalence`; these instance lemmas are sub-steps with their own `\lean{...}` pins confirmed at blueprint lines 2963–3026. ✓
- All `private` lemmas — correctly unreferenced.

No substantive unreferenced declarations that should have blueprint blocks were found, beyond the 4 expected helpers.

---

## Blueprint adequacy for this file

### Coverage

Approximately 60+ declarations in `QuotScheme.lean` are blueprint-referenced via `\lean{...}`. The 4 new helpers are the only unreferenced non-private declarations. **Coverage: adequate** (4 helpers as expected coverage debt).

### Proof-sketch depth for `lem:qcoh_section_localization_basicOpen` (gap2)

**Assessment: under-specified on the transport details.**

The blueprint proof sketch (lines 2523–2565) describes:
1. Push `M|_U` forward along `φ : U ≅ Spec Γ(X,U)` (gives QC `M'` on `Spec Γ(X,U)`).
2. Apply G1-core (`isLocalizedModule_basicOpen_of_isQuasicoherent`) to `M'`.
3. "Transport back across the iso on sections using the standard transfer of `IsLocalizedModule` along pre/post-composing linear equivalences."

The blueprint explicitly acknowledges step 3 is "the sole genuinely new piece the prover must supply on top of G1-core" and that "there is no Mathlib lemma performing this specific transport."

**What the blueprint does not describe (gaps for iter-043):**

- **The eqToHom bridge is unmentioned.** The actual obstruction in step 3 is that `hU.fromSpec ''ᵁ ⊤ = U` in `X.Opens` is only propositionally equal, requiring an explicit `eqToHom` coherence. The helper `fromSpec_image_top_section_coherence` (proved in iter-042) handles this: it identifies the ring iso `X.presheaf.map (eqToHom eT.symm)` with `(hU.fromSpec.appIso ⊤).hom ≫ (ΓSpecIso Γ(X,U)).hom`, yielding the `hf'` argument to `section_localization_hfr_aux_general`. The blueprint says nothing about this complication.

- **`section_localization_hfr_aux_general` already exists.** The blueprint describes the "new piece" as something the iter-043 prover must build. In fact, `section_localization_hfr_aux_general` (lines 2321–2384) is a fully proved general-scheme transport helper that reduces gap2 to: (a) show QC is preserved under pullback along `hU.fromSpec`, and (b) supply `f'` and `hf'` (the σ-coherence, where `fromSpec_image_top_section_coherence` helps). An iter-043 prover following only the blueprint would not know this helper exists and might re-implement the transport from scratch.

- **Direction mismatch.** The blueprint says "push `M|_U` forward along `φ : U → Spec Γ(X,U)`"; the Lean infrastructure uses pullback along `hU.fromSpec : Spec Γ(X,U) → X` (the same isomorphism in the reverse direction). For an isomorphism these are equivalent but the mismatch could confuse a prover navigating between blueprint and code.

- **QC-preserved-under-pullback-along-fromSpec is adequately described** in the blueprint ("M is QC; QC is preserved by pullback/pushforward along an isomorphism; M' is QC; apply gap1"). This is the piece the iter-043 prover will need to supply as `hP1 : IsIso (fromTildeΓ ((pullback hU.fromSpec).obj M))`, derivable from `IsQuasicoherent` + `isIso_fromTildeΓ_of_isQuasicoherent`. The blueprint correctly identifies this piece.

### Hint precision

For all `\lean{...}` pins referencing declarations in `QuotScheme.lean`: **precise** — every non-absent pin was verified to match the qualified name of the Lean declaration exactly.

One exception: `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` points at a declaration whose Lean type is weaker than the prose (see Signature weakening above). Hint is technically **wrong** relative to the full prose statement, but the blueprint's own `% NOTE` flags this explicitly.

### Generality

**Matches need** for the gap1/G1-core/gap2 cluster. No parallel API was written to work around an under-general blueprint definition.

### Recommended chapter-side actions

1. **(major, needed for iter-043)** Add a note to `lem:qcoh_section_localization_basicOpen`'s proof body: `section_localization_hfr_aux_general` (proved in iter-042) already performs the "new" transport step, so gap2 reduces to (a) showing the pullback of a QC sheaf along `hU.fromSpec` is QC (or equivalently that `fromTildeΓ` is iso for the pullback), and (b) supplying `f'` and `hf'` via `fromSpec_image_top_section_coherence`. Update the proof sketch to use pullback notation (`hU.fromSpec`) rather than pushforward along `φ`, to match the Lean infrastructure.

2. **(major, needed for iter-043)** Name the eqToHom bridge in the proof sketch: "the identity `hU.fromSpec ''ᵁ ⊤ = U` requires an explicit coherence lemma (`fromSpec_image_top_section_coherence`) matching the ring iso to the `eqToHom` transport; supply the precise `hf'` from this."

3. **(major, carry-forward)** The `\lean{...}` pin for `thm:grassmannian_representable` points at a weakened statement. Either (a) strengthen the Lean declaration to match the prose (add smoothness, properness, dim `d(r-d)`, tautological quotient, Plücker embedding as separate conjuncts or a data structure), or (b) split the blueprint block into a "skeleton existence" sub-lemma with a separate `\lean{...}` pin and a "full Grassmannian" theorem with a future pin. The current blueprint `% NOTE` already recommends this.

4. **(minor)** Add `\lean{...}` blueprint blocks for the 4 new helpers added in iter-042 (`restrictₗ`, `restrictBasicOpenₗ`, `fromSpec_image_top_section_coherence`, `section_localization_hfr_aux_general`). These are now load-bearing infrastructure for the gap2 proof path.

---

## Severity summary

| Finding | Severity |
|---|---|
| G1-core `\lean{...}` pin matches landed decl | ✓ no issue |
| gap1 `\lean{...}` pin matches decl | ✓ no issue |
| gap2 absent, blueprint-acknowledged | ✓ no issue |
| 4 new helpers: no blueprint blocks | minor (expected coverage debt) |
| `Grassmannian.representable` Lean type weaker than prose | **major** (pre-existing, blueprint-acknowledged) |
| Blueprint `lem:qcoh_section_localization_basicOpen`: eqToHom bridge unmentioned | **major** (blocks clean iter-043 navigation) |
| Blueprint `lem:qcoh_section_localization_basicOpen`: `section_localization_hfr_aux_general` not reflected | **major** (iter-043 prover might duplicate done work) |

**Overall verdict:** The G1-core `\lean{...}` pin is correct and the landed declaration matches exactly; no must-fix issues on the iter-042 work. Two major blueprint-side findings — the gap2 proof sketch doesn't describe the eqToHom bridge and doesn't reflect the already-proved `section_localization_hfr_aux_general` helper — will impede iter-043 unless the blueprint is updated before provers start on gap2.
