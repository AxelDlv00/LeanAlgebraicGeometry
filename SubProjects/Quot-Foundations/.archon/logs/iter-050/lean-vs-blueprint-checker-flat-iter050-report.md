# Lean ↔ Blueprint Check Report

## Slug
flat-iter050

## Iteration
050

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration (new iter-050 additions)

### `\lean{AlgebraicGeometry.gf_localGenerators_restrict}` (chapter: `\lem:gf_localGenerators_restrict`)

- **Lean target exists**: yes (line 2489)
- **Signature matches**: partial

  Blueprint says: "For any open immersion D(g) ↪ Y the restricted family…generates F|_{D(g)}".  
  Lean says: `{Y V : X.Opens} (hVY : V ≤ Y)` — any open V ≤ Y, not just basic opens D(g).  
  The Lean is strictly more general; the blueprint describes only the usage context (basic opens). Not a correctness problem.

- **Proof follows sketch**: partial

  Blueprint proof sketch is at a high informal level ("section-restriction Γ(F,Y)→Γ(F,D(g))"). The actual Lean proof routes through `SheafOfModules.GeneratingSections.map` in two stages (Stage A: slice-to-geometric via `overRestrictEquiv`; Stage B: geometric pullback along the open immersion `X.homOfLE hVY`). The blueprint sketch is not wrong but does not describe the `GeneratingSections.map` transport engine used, which is entirely invisible to it.

- **notes**: No sorry, axiom-clean. Blueprint has `\leanok`.

---

### `\lean{AlgebraicGeometry.gf_finiteType_affine_finite_cover_generated}` (chapter: `\lem:gf_finiteType_affine_finite_cover_generated`)

- **Lean target exists**: yes (line 2525)
- **Signature matches**: partial — **hypothesis mismatch**

  Blueprint statement explicitly reads: "Let X be a scheme, **F a quasi-coherent sheaf of modules** of finite type…".  
  Lean signature: `(F : X.Modules) [F.IsFiniteType]` — no `[F.IsQuasicoherent]` hypothesis.  
  The Lean dropped the quasi-coherence hypothesis. The Lean is more general (and provably correct: the proof uses only `SheafOfModules.IsFiniteType.exists_localGeneratorsData` + seam-1a, neither of which requires QCoh). But the blueprint explicitly carries the hypothesis that Lean dropped.

- **Proof follows sketch**: yes (modulo the route above)
- **notes**: No sorry, axiom-clean. Blueprint has `\leanok`. Dropped `[F.IsQuasicoherent]` is a deliberate generalization confirmed in the Lean module-doc for `gf_localGenerators_restrict`.

---

### `\lean{SheafOfModules.GeneratingSections.map}` — **NO BLUEPRINT BLOCK**

- **Lean target exists**: yes (line 2438, `noncomputable def map`)
- **Signature matches**: N/A — no `\lean{...}` block exists in the chapter
- **Proof follows sketch**: N/A
- **notes**: This is the transport-engine definition — the core of seam-1a. Its doc-string explains it transports a (finite) generating family of M along any colimit-preserving functor F, given a unit-iso. The `hF : PreservesColimitsOfSize` argument is explicit (not an instance) for a documented reason (instance search does not fire through `Scheme.Modules` abbreviations). No sorry, correct.

---

### `\lean{SheafOfModules.GeneratingSections.map_I}` — **NO BLUEPRINT BLOCK**

- **Lean target exists**: yes (line 2453, `@[simp] theorem map_I`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Body `rfl`. Trivially correct. Needed for downstream `IsFiniteType` inference in `gf_localGenerators_restrict`.

---

### `\lean{SheafOfModules.GeneratingSections.map_isFiniteType}` — **NO BLUEPRINT BLOCK**

- **Lean target exists**: yes (line 2462, `theorem map_isFiniteType`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Body `⟨inferInstanceAs (Finite σ.I)⟩`. One-liner, correct (index type is unchanged). No sorry.

---

## Red flags

None. No `:= sorry` in any of the five new declarations. The only sorry in the file is the intentional honest sorry in `genericFlatness` (line 2668), which is authorized by the `\leanok`-statement-only marker in `thm:generic_flatness` (meaning: declaration exists, proof not yet closed). The surrounding comment block (lines 2603–2668) documents both the correctness of the signature and the remaining G1/G3 gaps transparently.

No axioms, no suspect `Classical.choice` patterns, no excuse-comments on any new declaration.

---

## Unreferenced declarations (informational)

| Declaration | Line | Assessment |
|---|---|---|
| `SheafOfModules.GeneratingSections.map` | 2438 | **should be in blueprint** — substantive transport engine |
| `SheafOfModules.GeneratingSections.map_I` | 2453 | helper theorem, worth a `\lean{...}` mention in the engine block |
| `SheafOfModules.GeneratingSections.map_isFiniteType` | 2462 | helper, same engine block |
| `gf_finite_gen_iff_free_epi` | 2390 | has `\lean{...}` in `lem:gf_finite_gen_iff_free_epi` — covered |
| `pullbackModuleAddEquiv` / `finite_of_pullbackModuleAddEquiv` / etc. | ~1358 | covered by `lem:gf_pullback_module_transport` |

---

## Blueprint adequacy for this file

- **Coverage**: 2 of the 5 new iter-050 declarations have a `\lean{...}` block (`gf_localGenerators_restrict`, `gf_finiteType_affine_finite_cover_generated`). The 3 transport-engine declarations (`map`, `map_I`, `map_isFiniteType`) have no corresponding blueprint block.

- **Proof-sketch depth**: **under-specified** for the `\lem:gf_localGenerators_restrict` block. The blueprint proof sketch describes a stalk-level argument ("a family generating every stalk over Y generates every stalk over D(g)") — this is mathematically correct but does not reference the `GeneratingSections.map` functor at all. A prover relying on the sketch alone would not arrive at the two-stage transport route actually implemented.

- **Hint precision**: **loose** for `lem:gf_finiteType_affine_finite_cover_generated`. The `\lean{...}` name is correct, but the prose includes `[F.IsQuasicoherent]` that the Lean no longer requires. A prover following the blueprint would add a spurious hypothesis.

- **Generality**: **too narrow** on one point: `lem:gf_localGenerators_restrict` pins the restriction to basic opens D(g) inside Y, while the Lean lemma allows any V ≤ Y. The Lean is more general (and more reusable).

- **Recommended chapter-side actions**:

  1. **(major, must add)** Add a new subsubsection `\subsection{Transport engine for generating sections}` (or similar) after `sec:gf_nagata_machinery`, with three blueprint blocks:
     - `\lean{SheafOfModules.GeneratingSections.map}` — the functor-transport definition
     - `\lean{SheafOfModules.GeneratingSections.map_I}` — index-type stability
     - `\lean{SheafOfModules.GeneratingSections.map_isFiniteType}` — finite-type stability  
     Include a one-sentence informal statement for `map` (a finite generating family of M transports along a colimit-preserving functor with unit-iso, with index type preserved) and note the explicit `hF` design choice.

  2. **(major)** In `\lem:gf_finiteType_affine_finite_cover_generated`, remove "quasi-coherent" from the hypotheses: the Lean statement requires only `[F.IsFiniteType]` (no `[F.IsQuasicoherent]`), which is both correct and more general. Update the prose accordingly.

  3. **(minor)** In `\lem:gf_localGenerators_restrict`, replace "open immersion D(g) ↪ Y" with "any open V ≤ Y" to match the Lean generality, and update the proof sketch to mention the `GeneratingSections.map` engine (Stage A: slice-to-geometric via `overRestrictEquiv`; Stage B: geometric pullback along the open immersion).

---

## Severity summary

| Finding | Severity | Location |
|---|---|---|
| Three engine declarations (`map`, `map_I`, `map_isFiniteType`) have no `\lean{}` blueprint block | **major** | blueprint missing block |
| `lem:gf_finiteType_affine_finite_cover_generated` blueprint carries `[F.IsQuasicoherent]` that Lean dropped | **major** | blueprint too narrow |
| `lem:gf_localGenerators_restrict` blueprint proof sketch does not describe the `GeneratingSections.map` route | **minor** | blueprint under-specified |
| `lem:gf_localGenerators_restrict` says "D(g)" where Lean takes any V ≤ Y | **minor** | blueprint too narrow |

**No must-fix-this-iter items.** All five new Lean declarations are axiom-clean, correctly typed, and have no placeholder bodies. The Lean side is clean this iter. The two major findings are both blueprint-side adequacy failures requiring the blueprint-writing subagent.

**Overall verdict**: The five new iter-050 Lean declarations are correct and axiom-clean; the blueprint chapter needs two additions — a `GeneratingSections.map` engine block (3 declarations unreferenced) and removal of the spurious `[F.IsQuasicoherent]` hypothesis from `lem:gf_finiteType_affine_finite_cover_generated`.
