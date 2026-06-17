# Reference Retriever Report

## Slug
stacks-constructions

## Status
COMPLETE — chapter `.tex` downloaded and verified; all five directive tags
located in source; pointer file written with deep contents map.

## Sources fetched

- **Stacks Project ch.27 "Constructions of Schemes"** —
  `https://raw.githubusercontent.com/stacks/stacks-project/master/constructions.tex`
  → downloaded `references/stacks-constructions.tex` (186080 bytes, 5168
  lines, plain `.tex` opening with `\input{preamble}` on L1 and
  `\title{Constructions of Schemes}` on L7) — pointer
  `references/stacks-constructions.md`.

- **Stacks Project `tags/tags` file** (lookup only, not saved long-term) —
  `https://raw.githubusercontent.com/stacks/stacks-project/master/tags/tags`
  → fetched to `/tmp/stacks-tags.txt` and grep'd to resolve each directive
  tag to its `\label{...}` plus to identify the adjacent tags 01LM / 01LP /
  01LT flagged in the pointer's caveats. Not registered as a separate
  reference; cross-checked in this same session.

## Tag → label → location summary (full table in `stacks-constructions.md`)

| Tag | Label | Line(s) in `stacks-constructions.tex` |
| --- | --- | --- |
| 01LL | `section-spec-via-glueing` (SECTION) | L309–310 |
| 01LO | `lemma-transitive-spec` (transitivity, NOT affine case) | L363–379 |
| 01LQ | `section-spec` (SECTION) | L427–428 |
| 01LR | `equation-spec` (EQUATION defining functor `F`) | L460–465 |
| 01LS | `lemma-spec-base-change` (base-change of `F`) | L467–489 |

Adjacent tags surfaced for the writer's likely real quote targets:

| Tag | Label | What it actually is | Line(s) |
| --- | --- | --- | --- |
| 01LM | `situation-relative-spec` | quasi-coherent `𝒪_S`-algebra setup | L312–318 |
| 01LP | `lemma-glue-relative-spec` | existence of `π : Spec_S(𝒜) → S` | L381–414 |
| 01LT | `lemma-spec-affine` | `S = Spec R` ⇒ `F ≅ Spec(Γ(S, 𝒜))` (the actual affine base case) | L491–545 |
| (no tag inline) | `definition-relative-spec` | named definition + universal map | L641–656 |
| (no tag inline) | `lemma-spec-properties` | (1) affine over affine; (2) **base change**; (3) universal map iso | L662–691 |

## Index updates
- `references/summary.md` — appended 1 entry: `stacks-constructions` (new
  row added directly after the existing `stacks-coherent` row; no existing
  rows touched).

## Notes for Dispatcher

The directive's mapping `tag → functional role` is partly inaccurate against
the source. The pointer file's "Caveats" section spells this out at length;
the headline mismatches the writer should know **before quoting** are:

1. **01LL is a section label, not a definition.** The likely intended
   "definition of a quasi-coherent sheaf of algebras" is either the
   `\begin{situation}` block at tag **01LM** (L312–318) or the named
   `\begin{definition}` `definition-relative-spec` at L641–656 (no inline
   tag visible). If the writer's `% SOURCE QUOTE:` block is meant to define
   what's being constructed, 01LL alone won't carry that content.

2. **01LO is the transitivity lemma, not the affine base case.** The
   affine-case lemma (`S = Spec R ⇒ F` is representable by
   `Spec(Γ(S, 𝒜))`) the directive describes is `lemma-spec-affine`, tag
   **01LT** at L491–545.

3. **01LR is the equation defining the functor `F`, not a functoriality /
   adjunction lemma.** The "universal map" / adjunction content is in
   `definition-relative-spec` (L650–655) and part (3) of
   `lemma-spec-properties` (L662–691, neither has a visible inline tag).

Tags 01LQ (section heading "Relative spectrum as a functor") and 01LS
(base change of `F`) match the directive cleanly.

If the planner re-issues this directive, recommend swapping the named tag
set to `{01LM, 01LP, 01LT, 01LS, definition-relative-spec,
lemma-spec-properties}` for a cleaner match to the six quote blocks the
chapter actually needs. All of these are already located + line-mapped in
the pointer file, so no second download is needed.

No pre-existing `references/` entry needed modification. The Stacks `tags/tags`
file used here is the same source `stacks-varieties.md` / `stacks-algebra.md`
/ `stacks-coherent.md` / `stacks-fields.md` were already cross-checked
against, so no provenance regression.
