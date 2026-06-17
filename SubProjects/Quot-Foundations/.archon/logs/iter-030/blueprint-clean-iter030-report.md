# Blueprint-clean Report — iter-030

## Scope covered
Two chapters: `Cohomology_FlatBaseChange.tex` (L1677–1930) and `Picard_QuotScheme.tex` (L2462–3230).

## Changes made

### Cohomology_FlatBaseChange.tex (3 edits)

1. **`lem:base_change_mate_fstar_reindex_legs_link_distribute` statement (L1712–1713)**
   Removed Lean elaboration/typeclass language: "Both sides are freshly elaborated, so the instance
   diamond is absent." — this referred to Lean's typeclass elaboration engine. The sentence was
   redundant (the `% ---` comment block above already explains it to provers at the meta level) and
   does not belong in the typeset statement body.

2. **`lem:base_change_mate_fstar_reindex_legs` statement — "Why the legs must be parametrised" block**
   Removed Lean-specific phrases: "closed construction whose type bakes in the leg",
   "dependent-motive obstruction", "that identification definitional", "unblocks".
   Replaced with mathematically precise type-theoretic language: "type-indexed construction in the
   leg", "transporting the unit expansion across this propositional leg-equality therefore fails",
   "makes the identification available by reflexivity", "enables the unit expansion".
   The mathematically essential propositional-vs-definitional distinction was retained.

3. **`lem:base_change_mate_fstar_reindex_legs` proof — closing sentence**
   Removed Lean proof-state language: "goal's locked composite", "object-presentation and
   associativity diamond is crossed", "separately elaborated links", "rewriting in place".
   Replaced with: "A single coherence identification then aligns the assembled composite with ρ;
   this is the only point at which the ambient associativity ambiguity is crossed, which is exactly
   why the telescoping is cut into separately stated steps."

### Picard_QuotScheme.tex (5 edits)

4. **`lem:modules_restrictFunctor_mathlib` statement**
   Removed project-history narrative: "it does exist, contrary to the impression that no such functor
   is available." This is project-evolution commentary, not mathematics.

5. **`lem:modules_restrictFunctorIsoPullback_mathlib` statement**
   Removed Lean-specific term "better-defeq": "the better-defeq restriction" → "the restriction
   functor". "Defeq" (definitional equality) is a Lean implementation concept inappropriate in
   typeset prose.

6. **`lem:quasicoherentData_bind_mathlib` statement**
   Replaced Lean typeclass names `IsRightAdjoint`/`HasSheafify` in prose with:
   "slice-site adjointness and sheafification typeclass synthesis". These class names appeared as
   bare Lean identifiers in the typeset body.

7. **`lem:isLocalizedModule_tilde_restrict` proof**
   Replaced Lean API names `tilde.toOpen` and `IsLocalizedModule.of_linearEquiv_right` with
   mathematical descriptions: "canonical map N → Γ(Ñ, D(f))", "the global-sections map N → Γ(Ñ, ⊤)
   is an isomorphism", "Mathlib's transfer lemma for localization along a linear equivalence".

8. **`lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` proof**
   Replaced `\mathrm{of\_linearEquiv}` / `\mathrm{of\_linearEquiv\_right}` with:
   "pre- and post-composing by the linear equivalences induced by the components of ψ".

9. **`lem:qcoh_affine_section_localization` (G1-core) — missing `% SOURCE QUOTE:`**
   Added the required `% SOURCE QUOTE:` block with verbatim text from Stacks
   `lemma-invert-f-sections` (references/stacks-properties.tex, L2152–2170), affine case
   X = Spec R, X_f = D(f). Also updated the `(read from ...)` parenthetical in the `% SOURCE:`
   line to point to `stacks-properties.tex, L2152--2170` (replacing the vague dual-file reference).

## Source quote validation

| Block | SOURCE present | SOURCE QUOTE present | Status |
|---|---|---|---|
| `lem:section_localization_descent` | ✓ stacks-properties.tex L2152–2170 | ✓ (was already present) | OK |
| `lem:qcoh_affine_isIso_fromTildeΓ` (gap1) | ✓ stacks-schemes.tex L1279–1284 | ✓ (was already present) | OK |
| `lem:qcoh_affine_section_localization` (G1-core) | ✓ stacks-properties.tex tag 01HA | ✓ **added this iter** | OK |
| `lem:isLocalizedModule_tilde_restrict` | ✓ stacks-schemes.tex lemma-spec-sheaves item (4) | ✓ (was already present) | OK |
| `lem:qcoh_section_localization_basicOpen` | ✓ stacks-schemes.tex lemma-spec-sheaves | ✓ (was already present) | OK |
| Mathlib anchors (`\mathlibok`) | N/A (Lean decl, no external reference) | N/A | OK |
| FBC link sub-lemmas (L1–L5) | N/A (internal, no external citation) | N/A | OK |

## Items NOT changed

- `\leanok` markers: untouched (deterministic sync owns them).
- `\mathlibok` markers: untouched.
- `\uses{}` edges: untouched.
- `% NOTE:` comments: preserved as-is (including architectural notes with Lean identifiers,
  project-evolution notes, and `set_option ...` hints — the directive says to keep `% NOTE:` comments).
- `% ---` separator comment blocks (e.g., L1677–1689 in FBC explaining the 5-link decomposition
  rationale): preserved as-is — these are comment-level meta-notes to provers, not typeset prose bodies.

## No retrievals needed
All required source text was already present in `references/stacks-properties.tex`
and `references/stacks-schemes.tex`. No `reference-retriever` spawn was necessary.
