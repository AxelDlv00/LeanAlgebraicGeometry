# Blueprint Writer Directive — Picard_TensorObjSubstrate.tex

## Chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (the ONLY file you edit).

## Context (read these first)
- `analogies/ts219dual.md` — the mathlib-analogist ts219 finding: the ⊗-inverse needs a sheaf
  internal-hom of 𝒪_X-modules; Mathlib-absent at presheaf+sheaf+categorical level; CONTRAVARIANT
  (so NOT a tensorObj-style "build presheaf then sheafify" mirror); ~6–12 iter / ~300–500 LOC build.
  Decision 1 (presheaf slice/end internal-hom → eval → sheaf condition) is the smaller constructive
  route; Decision 3 (`Pseudofunctor.IsStack` descent) the most principled/largest.
- `informal/exists_tensorObj_inverse.md` — the iter-218 source-derived blocker report with the
  precise goal signature and the two candidate primitives.
- The chapter itself (2309 lines as of iter-218).

## Task — four edits, all confined to this chapter

### EDIT 1 [MUST-FIX] — `lem:tensorobj_inverse_invertible` proof prose is misleading
The proof block (around lines 1606–1659) currently describes constructing
`L⁻¹ := ℋom_{𝒪_X}(L, 𝒪_X)` and the evaluation as if they are executable steps. They are NOT:
the internal-hom/dual object is Mathlib-absent (no `MonoidalClosed`/internal-hom for
`PresheafOfModules`/`SheafOfModules`; no object-level descent). Rewrite the proof prose to:
- Open with an explicit **INFRASTRUCTURE-BLOCKED** note: the construction depends on a sheaf
  internal-hom of 𝒪_X-modules that does not exist in Mathlib (analogist ts219), so the Lean body
  is `sorry` pending the dual infra block (EDIT 4 below).
- Change tense from "we construct" to "the mathematical route is …; this is realized once the
  internal-hom infrastructure of §(new dual section) lands."
- Keep the mathematical content (dual = `ℋom(L,𝒪_X)`, contraction = evaluation = local left-unitor,
  local-iso ⇒ global via the CLOSED `tensorObj_restrict_iso`) — that content is correct; only the
  framing must stop pretending the object is constructible today.
- Cross-reference the new dual section (EDIT 4) as the prerequisite.

### EDIT 2 [MAJOR] — `lem:tensorobj_assoc_iso` proof route mismatch
The blueprint proof (around lines 1425–1493) describes building the associator by gluing local isos
through `tensorObj_restrict_iso` "with no whiskering." But the CURRENT Lean proof uses the whiskering
route (`W_whiskerLeft/Right_of_W` → `isLocallyInjective_whiskerLeft_of_W`, which is `sorry`), so
`tensorObj_assoc_iso` transitively depends on a sorry. Add a clearly-marked note to the proof block:
- The CURRENT Lean implementation uses the route-(d) whiskering composite and is therefore NOT
  axiom-clean (transitive `sorry` via `isLocallyInjective_whiskerLeft_of_W`).
- The gluing route the blueprint describes is the INTENDED sorry-free realization, but it requires
  **morphism-level descent for `SheafOfModules`** (glue local isos into a global one) — the same
  descent-infrastructure family the dual block needs. So the assoc re-route + the deletion of the
  vestigial whiskering/stalk apparatus is DEFERRED together with the dual block, not available now.

### EDIT 3 [MINOR] — retract inaccurate "removed in iter-218" wording
The `% SUPERSEDED route … Lean declaration removed in iter-218` comments are inaccurate: the
declarations (`isLocallyInjective_whiskerLeft_of_W` (sorry), `W_whiskerLeft/Right_of_W`,
`isIso_sheafification_map_of_W`, the stalk lemmas) are STILL in the Lean file and
`tensorObj_assoc_iso` still calls them. Change the wording to "% SUPERSEDED route … pending deletion
once the assoc re-route (morphism descent) lands; declaration still present and still backing the
current `tensorObj_assoc_iso` proof."

### EDIT 4 [NEW SECTION — the forward-looking content] — decompose the dual infra block
Add a new section to the chapter, "Sheaf internal-hom of 𝒪_X-modules (the ⊗-inverse infrastructure)",
that decomposes the Decision-1 build into named, individually-formalizable sub-steps so a prover can
take them one at a time. Use the analogist recipe (`analogies/ts219dual.md`). Write a definition/lemma
block for each sub-step with `\label{}` and a `\lean{}` pin naming the INTENDED Lean declaration
(planner-chosen names below), `\uses{}` edges to the existing closed pieces, and a rigorous prose
sketch. Do NOT add `\leanok`/`\mathlibok` markers (those are managed by sync_leanok / review).

Sub-steps to write (each its own block):
1. **`def:presheaf_internal_hom`** — the presheaf-level internal hom
   `\lean{PresheafOfModules.internalHom}` (planner name): `ℋom(M,N)(U) := ModuleCat.of (R.obj U) (M|_U ⟶ N|_U)`
   built via the open-immersion restriction, with the slice/end structure. Prose must explain the
   CONTRAVARIANCE issue (why this is not a covariant presheaf to sheafify, and how the slice formula
   `M|_U ⟶ N|_U` resolves it). `\uses{def:scheme_modules_tensorobj}`.
2. **`def:presheaf_dual`** — the dual `ℋom(M, unit)` specialised to target the structure presheaf,
   `\lean{PresheafOfModules.dual}`. `\uses{def:presheaf_internal_hom}`.
3. **`lem:internal_hom_eval`** — the evaluation/contraction `M ⊗ ℋom(M,unit) ⟶ unit` (counit of the
   internal-hom adjunction), `\lean{PresheafOfModules.internalHomEval}`. `\uses{def:presheaf_dual, def:scheme_modules_tensorobj}`.
4. **`lem:internal_hom_isSheaf`** — `ℋom(M,N)` satisfies the sheaf condition when `N` is a sheaf, so it
   descends to a `SheafOfModules`; define the sheaf-level dual `\lean{AlgebraicGeometry.Scheme.Modules.dual}`.
   `\uses{def:presheaf_dual, lem:internal_hom_eval}`.
5. **`lem:dual_isLocallyTrivial`** — the dual of a locally-trivial module is locally-trivial (dual of
   free rank-one is free rank-one; internal hom commutes with open-immersion restriction).
   `\uses{lem:internal_hom_isSheaf, lem:tensorobj_restrict_iso}`.
6. State explicitly how these discharge `lem:tensorobj_inverse_invertible` (EDIT 1): `Linv := dual L`,
   `eval` is a local iso (= left unitor on the trivialising cover) ⇒ global iso by the CLOSED
   `tensorObj_restrict_iso` + `tensorObj_unit_iso`. Add the `\uses` edge from
   `lem:tensorobj_inverse_invertible` to `lem:dual_isLocallyTrivial` + `lem:internal_hom_eval`.

Also note the ALTERNATIVE route (Decision 3, `Pseudofunctor.IsStack` object descent) in one short
remark as a fallback if Decision 1 bottoms out — do NOT write full sub-steps for it.

## Citation discipline
The internal hom / sheaf-Hom `ℋom_{𝒪_X}(F,G)` and the duality `L ⊗ L^∨ ≅ 𝒪_X` for invertible sheaves
are standard. Provide a `% SOURCE:` + verbatim `% SOURCE QUOTE:` for the internal-hom/dual definition.
The Stacks project "Sheaves of Modules" chapter (sheaf Hom; tag area 01CM) or Hartshorne II.5 are the
canonical sources. If you do NOT already have a local file under `references/` you have read for this,
dispatch a `reference-retriever` child (your write-domain authorizes `references/**`) to fetch the
Stacks "Sheaves of Modules" chapter (or Hartshorne II.5), then quote it verbatim. If retrieval fails,
mark the new blocks `% SOURCE: <pointer> (verbatim text not yet retrieved)` and present the
construction as project-bespoke — do NOT fabricate a quote. The build-DECOMPOSITION itself (which
sub-steps, what each leans on) is the project's plan from `analogies/ts219dual.md` and needs no external
source.

## Out of scope
- Do NOT touch any other chapter.
- Do NOT add `\leanok` or `\mathlibok` markers anywhere.
- Do NOT remove the existing `lem:tensorobj_*` blocks; only edit prose/notes per EDITs 1–3 and ADD the
  new section per EDIT 4.
- Do NOT write Lean tactic code; prose + signatures only.

## Report
List exactly what you changed per EDIT, the new `\label{}`/`\lean{}` pins you added, any
reference-retriever child you dispatched, and any "Strategy-modifying findings" if the prose surfaced
a structural issue.
