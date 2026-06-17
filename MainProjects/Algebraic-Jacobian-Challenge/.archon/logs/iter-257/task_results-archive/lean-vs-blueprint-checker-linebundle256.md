# Lean ↔ Blueprint Check Report

## Slug
linebundle256

## Iteration
256

## Files audited
- Lean: `AlgebraicJacobian/Picard/LineBundleCoherence.lean`
- Blueprint: `blueprint/src/chapters/Picard_LineBundleCoherence.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.exists_trivializing_cover}` (lem:lbc_trivializing_cover)

- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.exists_trivializing_cover` at line 96.
- **Signature matches**: yes. Blueprint: index set I, affine opens covering X, isos M|_{U_i} ≅ 𝒪_{U_i}. Lean: `∃ (I : Type u) (U : I → X.Opens), (∀ i, IsAffineOpen (U i)) ∧ iSup U = ⊤ ∧ ∀ i, Nonempty (M.restrict (U i).ι ≅ SheafOfModules.unit (U i : Scheme).ringCatSheaf)`. Matches exactly; `iSup U = ⊤` is the correct Lean encoding of "covers X."
- **Proof follows sketch**: N/A (body is `sorry`).
- **notes**: Blueprint proof says take I := X (underlying points), which fits inside `Type u` since `X : Scheme.{u}`. The blueprint's `\leanok` on the statement block is correct (sorry stub exists).

---

### `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.chartPresentation}` (lem:lbc_chart_presentation)

- **Lean target exists**: yes — `IsLocallyTrivial.chartPresentation` at line 116, `noncomputable def`.
- **Signature matches**: partial. Blueprint: "the restriction M|_{U_i} admits the trivial **finite** free presentation." Lean return type is `(M.over U).Presentation`, which is the bare `SheafOfModules.Presentation` structure — it does NOT carry `Presentation.IsFinite`. The word "finite" in the blueprint is NOT reflected in the return type. Hover confirms `M.over U : SheafOfModules (Sheaf.over X.ringCatSheaf U)`, so the type is syntactically correct but semantically weaker than the blueprint claim.
- **Proof follows sketch**: N/A (body is `sorry`).
- **notes**: The Mathlib API (Quasicoherent.lean lines 44–62) shows `Presentation` and `Presentation.IsFinite` are distinct: the latter is a separate typeclass. `isFinitePresentation` needs `(chartPresentation M U e).IsFinite` to build `QuasicoherentData.IsFinitePresentation`. This is NOT carried in the return type and NO separate named declaration pins it. See §"Missing 6th decl" below for severity. Additionally, the blueprint's proof block has a misplaced `\leanok` at tex line 187 (inside `\begin{proof}…`) claiming the body is sorry-free; the Lean body is `sorry`. This is a policy violation / factual error.

---

### `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.isFinitePresentation}` (thm:lbc_isFinitePresentation)

- **Lean target exists**: yes — line 130, `theorem`.
- **Signature matches**: yes. Hover confirms `M.IsFinitePresentation` resolves to `SheafOfModules.IsFinitePresentation M` (Quasicoherent.lean), which requires the three slice-site instances. The file compiles with no errors, so the instances resolve from `import Mathlib`. Statement matches blueprint.
- **Proof follows sketch**: N/A (body is `sorry`).
- **notes**: Blueprint proof sketch says "feed to `SheafOfModules.IsFinitePresentation.mk`." Mathlib's actual constructor is the class field `exists_quasicoherentData`; the anonymous constructor `⟨⟨σ, hσ⟩⟩` is used in practice. The sketch is directionally correct but the Lean path will differ slightly from the "`.mk`" phrasing.

---

### `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.isFiniteType}` (cor:lbc_isFiniteType)

- **Lean target exists**: yes — line 139, `theorem`.
- **Signature matches**: partial. Blueprint corollary claims **both** `M.IsFiniteType` AND `M.IsQuasicoherent`. The Lean only states `M.IsFiniteType`. However: from Quasicoherent.lean lines 271–281, `IsFinitePresentation → IsQuasicoherent` and `IsFinitePresentation → IsFiniteType` are both **automatic Mathlib instances**. `IsQuasicoherent` is therefore automatically inferred from `hM.isFinitePresentation` without needing a named theorem. The `isFiniteType` named theorem is needed because it is not trivially expressible as a one-liner in consumer proof contexts. The omission of `isQuasicoherent` as a separate named declaration is defensible.
- **Proof follows sketch**: N/A (body is `sorry`).
- **notes**: The docstring references `SheafOfModules.instIsFiniteTypeOfIsFinitePresentation` and `SheafOfModules.instIsQuasicoherentOfIsFinitePresentation` as named instances, but Mathlib uses anonymous instances for these; the auto-generated names differ. This is a docstring inaccuracy (non-blocking).

---

### `\lean{AlgebraicGeometry.Scheme.LineBundle.IsLocallyTrivial.chart_free_rank_one}` (lem:lbc_rank_flat)

- **Lean target exists**: yes — line 153, `theorem`.
- **Signature matches**: yes (given the Mathlib limitation acknowledged in the blueprint). Lean: `∃ U : X.Opens, x ∈ U ∧ IsAffineOpen U ∧ Nonempty (M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf)`. Blueprint acknowledges "Mathlib has no `SheafOfModules`-level locally-free / flat / rank predicate," so the iso M|_U ≅ 𝒪_U is the best available statement. The Lean statement is essentially the definition of `IsLocallyTrivial` applied at a point — proof will be `exact hM x` or `hM x`.
- **Proof follows sketch**: N/A (body is `sorry`).
- **notes**: This theorem is a trivial unwrapping of `IsLocallyTrivial M` at a point. The blueprint's statement says it records "rank one and flatness"; both follow from the iso but are not stated in the type. This is acknowledged and acceptable.

---

## Red flags

### Misplaced `\leanok` — proof block

**`lem:lbc_chart_presentation` — blueprint tex line 187**: The `\leanok` marker appears inside `\begin{proof}…\end{proof}` for `chartPresentation`. Per project convention (CLAUDE.md), a proof-block `\leanok` means "proof closed, no `sorry`." The Lean body is `sorry`. This marker is factually wrong.

Since `\leanok` is supposed to be managed exclusively by `sync_leanok` (CLAUDE.md: "Agents must NOT add or remove `\leanok` themselves"), this marker was likely placed manually by the plan agent when writing the new chapter, violating the policy.

**Effect**: If `sync_leanok` trusts an existing proof-block `\leanok` and doesn't recheck it, the marker would incorrectly persist, misleading downstream planning. If `sync_leanok` always rewrites from scratch, this marker would be removed on the next run. Either way, a manual cleanup is safer.

### Placeholder bodies — all 5 declarations

All 5 declarations have `sorry` bodies. This is expected for an iter-256 file-skeleton; the comment header says "bodies are iter-257+ work." This is NOT a red flag per project convention for file-skeleton iterations.

---

## Unreferenced declarations (informational)

None. The file has exactly 5 named declarations, all 5 are `\lean{...}`-referenced by the blueprint.

---

## Blueprint adequacy for this file

- **Coverage**: 5/5 Lean declarations have a `\lean{...}` block. No unreferenced declarations.
- **Proof-sketch depth**: **under-specified** for `isFinitePresentation`. The main gap is the finiteness bridge (see below). Other sketches are adequate.
- **Hint precision**: **loose** for `chartPresentation`. The return type `(M.over U).Presentation` is correct Lean but does not reflect that the presentation must be finite to be used by `isFinitePresentation`. The prover will face a type-level finiteness gap.
- **Generality**: matches need.

### The missing finiteness bridge (critical path for iter-257)

`QuasicoherentData.IsFinitePresentation` (Quasicoherent.lean line 235–236) requires:
```
isFinite_presentation (i : q.I) : (q.presentation i).IsFinite := by infer_instance
```
where `q.presentation i` is the result of `chartPresentation`. Since `chartPresentation` returns a bare `Presentation` (not a bundled finite-presentation), `isFinitePresentation` needs `(chartPresentation M U e).IsFinite` to build the `QuasicoherentData.IsFinitePresentation` field.

The Mathlib API provides a route: `Presentation.ofIsIso` (Quasicoherent.lean lines 132–136) transports a presentation along an iso, and there is a Mathlib instance (lines 139–142) that `ofIsIso` preserves `IsFinite` when the source presentation is finite. So if `chartPresentation` is implemented as:
1. Take the canonical finite presentation of `SheafOfModules.unit (U : Scheme).ringCatSheaf` (some `unit.somePresentation` with `IsFinite`)
2. Transport it via `Presentation.ofIsIso e.hom`

then `(chartPresentation M U e).IsFinite` is automatically inferred by Lean's typeclass system with no separate lemma needed.

**The blueprint does not say any of this.** It says "transport the presentation along the trivialisation" but does not name `Presentation.ofIsIso`, does not confirm the unit's presentation is finite, and does not clarify that typeclass inference will close `IsFinite` automatically. A prover reading only the blueprint could implement `chartPresentation` in a way that makes `(chartPresentation M U e).IsFinite` neither automatic nor obviously provable, causing `isFinitePresentation` to fail.

The prover's concern about a "missing 6th decl" is valid IF `chartPresentation` is not implemented via the `ofIsIso` route. The blueprint should resolve this ambiguity before iter-257.

**Recommended chapter actions**:
1. Remove the false proof-block `\leanok` at tex line 187. (Policy violation; factually wrong.)
2. In the proof sketch of `lem:lbc_chart_presentation`, name the Mathlib lemma: "Use `Presentation.ofIsIso e.hom` applied to the canonical presentation of `SheafOfModules.unit`. The Mathlib instance `(ofIsIso f σ).IsFinite` automatically infers `IsFinite` for the result when `σ.IsFinite` holds for the unit's presentation."
3. In the proof sketch of `thm:lbc_isFinitePresentation`, note: "The `IsFinite` typeclass for each `chartPresentation` result is inferred automatically via the Mathlib instance; no separate lemma is needed."
4. In `cor:lbc_isFiniteType`'s prose, soften the claim about `IsQuasicoherent`: note that it follows from `isFinitePresentation` via a Mathlib instance (no separate named theorem needed).
5. Confirm that the canonical presentation of `SheafOfModules.unit R` is finite, or cite the Mathlib declaration that makes this an instance.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| False proof-block `\leanok` on `lem:lbc_chart_presentation` (tex line 187) | **must-fix-this-iter** |
| Blueprint adequacy: `isFinitePresentation` proof sketch does not clarify how `chartPresentation`'s `Presentation.IsFinite` is established; prover-facing ambiguity on whether a 6th decl is needed | **must-fix-this-iter** |
| `chartPresentation` return type `(M.over U).Presentation` does not carry `IsFinite`; blueprint claims a "finite free presentation" | **major** (fixable via implementation guidance) |
| `isFiniteType` Lean signature covers only `IsFiniteType`, not `IsQuasicoherent` as blueprint corollary claims; `IsQuasicoherent` is a Mathlib instance, so no separate declaration is strictly needed | **minor** |
| Docstring references non-existent named instances `instIsFiniteTypeOfIsFinitePresentation` / `instIsQuasicoherentOfIsFinitePresentation` | **minor** |

**Overall verdict**: The 5-declaration skeleton is syntactically correct and typechecks, but the blueprint chapter has one false `\leanok` marker and is under-specified on the finiteness path that `isFinitePresentation` requires — the prover will hit a type-level blocker next iter without clarification from the blueprint-writing subagent.
