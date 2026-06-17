# Lean ↔ Blueprint Check Report

## Slug
qcoh-iter029

## Iteration
029

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant block: `lem:qcoh_iso_tilde_sections` at L3425–3471; 01I8-gap prose at L580–592 within `def:qcoh_sections_localized`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections}` (chapter: `lem:qcoh_iso_tilde_sections`)

- **Lean target exists**: yes — `noncomputable def qcoh_iso_tilde_sections` at Lean:62
- **Signature matches**: **partial** — the block's informal statement is the *unconditional*
  quasi-coherent result ("for quasi-coherent F, F ≅ M~"), whereas the Lean declaration carries
  the *conditional* hypothesis `[IsIso F.fromTildeΓ]` in place of `[IsQuasicoherent F]`.
  The conditional hypothesis is strictly more restrictive: `[IsQuasicoherent F]` would imply
  `[IsIso F.fromTildeΓ]` once the 01I8 instance is available, but that instance is the stated
  remaining gap. So the Lean proves a weaker result than the block's prose claims.
- **Proof follows sketch**: partial — the proof block prose (L3465–3470) describes the
  unconditional proof ("the counit ... is an isomorphism for quasi-coherent F") and the full
  tilde-Γ equivalence, while the actual Lean body is just `(asIso F.fromTildeΓ).symm` — a
  one-liner that is correct *given* the `[IsIso ...]` hypothesis but does not carry out the
  blueprint's quasi-coherent argument.
- **notes**:
  - The `% NOTE` at blueprint L3432–3439 correctly and completely discloses the divergence:
    it states that `\leanok` certifies the conditional decl, not the qcoh statement, and names
    the single remaining blocker (01I8 instance, ~few-hundred LOC).
  - `\leanok` appears at both the statement block (L3427) and the proof block (L3464). Per the
    marker vocabulary, the statement-block `\leanok` means the named declaration is formalized
    with no sorry — correct for the conditional decl (body `(asIso F.fromTildeΓ).symm`, no
    sorry). The proof-block `\leanok` means the proof is closed with no sorry — also correct for
    the conditional proof. Neither marker overclaims the unconditional result; the NOTE is the
    semantic guard.
  - Directive question: "confirm the `\leanok` (sync-added) is on the conditional decl, not the
    qcoh statement." **Confirmed.** The only `\lean{...}` in the block points to
    `AlgebraicGeometry.qcoh_iso_tilde_sections`, which is the conditional declaration. There is
    no separate Lean declaration for the unconditional qcoh statement, so the `\leanok` cannot
    be on a non-existent decl. The NOTE makes this explicit.

---

## Red flags

None of the standard red-flag categories apply:

- **No placeholder / sorry bodies**: all four declarations in the file have legitimate non-sorry
  bodies (`(asIso F.fromTildeΓ).symm` ×2, `rfl` ×2).
- **No excuse-comments**: the Lean docstrings and the `## Handoff` section accurately document
  what is proven and what remains; they do not say "this is wrong but works" or "placeholder
  until fixed."
- **No `axiom` declarations**.
- **No `Classical.choice _` on non-trivial claims**.

The `% NOTE` in the blueprint is a technical disclosure note (appropriate content for the review
agent's `% NOTE:` marker), not a Lean-side excuse-comment.

---

## Unreferenced declarations (informational)

The following three declarations in the Lean file have no `\lean{...}` block in the blueprint:

| Declaration | Kind | Blueprint coverage |
|---|---|---|
| `qcoh_iso_tilde_sections_of_presentation` (Lean:71) | `noncomputable def` | **none** — the `% NOTE` at L3438–3439 names this decl and flags coverage debt |
| `qcoh_iso_tilde_sections_hom` (Lean:78) | `@[simp] lemma` | **none** — mechanical simp helper |
| `qcoh_iso_tilde_sections_inv` (Lean:84) | `@[simp] lemma` | **none** — mechanical simp helper |

`qcoh_iso_tilde_sections_of_presentation` is semantically significant: it is the *presentation-form discharge* that connects the presentation-based Mathlib path
(`isIso_fromTildeΓ_of_presentation`) to the conditional iso without needing the 01I8 instance. It
is the immediately-usable form of the conditional theorem and deserves its own block. The two
`@[simp]` helpers are genuinely auxiliary.

---

## Blueprint adequacy for this file

**Coverage**: 1/4 Lean declarations have a `\lean{...}` block. Among the 3 unreferenced:
1 substantive (flagged above), 2 minor helpers (acceptable).

**Proof-sketch depth**: **under-specified** — the proof block at L3462–3471 sketches the
*unconditional* quasi-coherent proof (invoking the tilde-Γ equivalence for quasi-coherent F),
but the actual Lean proof for the conditional decl is a one-liner conditioned on the `IsIso`
hypothesis. A reader of the blueprint sketch who does not read the NOTE would expect a non-trivial
proof assembling the equivalence, and would be surprised to find `(asIso F.fromTildeΓ).symm`.
The NOTE corrects this but the proof prose and the actual proof are conceptually misaligned.

**01I8 gap account accuracy (blueprint L580–592 vs Lean `## Handoff`)**:

| Item | Blueprint (L580–592) | Lean `## Handoff` (Lean:108–121) |
|---|---|---|
| Gap identification | "Globalising local presentation data on Spec R — Tag 01I8 — is the one genuine gap" | Same: 01I8 instance `[IsQuasicoherent F] → IsIso F.fromTildeΓ` |
| Mathlib gradient | mentions `isIso_fromTildeΓ_of_presentation` as the available handle | same |
| Sub-step 1 | not documented | global generation: produce `F.GeneratingSections` from `QuasicoherentData` via partition-of-unity / Spec R compactness |
| Sub-step 2 | not documented | kernel of `free I ⟶ F` is qcoh ⟹ globally generated ⟹ `F.Presentation` |
| Sub-step 3 | not documented | feed `F.Presentation` to `isIso_fromTildeΓ_of_presentation` |

The blueprint's 01I8 description is *accurate* at the high level (correct identification of the
gap, correct Mathlib reference) but omits the 3-step decomposition that the Lean `## Handoff`
documents. A blueprint-writing subagent should backfill this decomposition into the
`lem:qcoh_iso_tilde_sections` block or a new `subsec:01I8_gap` so future provers have a roadmap.

The prose at L580–592 lives within the `def:qcoh_sections_localized` block (not within
`lem:qcoh_iso_tilde_sections`), so the NOTE's reference "see prose L580–592" sends the reader
to a different block's notes. This is accurate (the prose is there) but means the canonical
documentation of the 01I8 decomposition is spread across two locations: the NOTE in
`lem:qcoh_iso_tilde_sections` and the body of the Lean `## Handoff`. Neither is wrong, but the
duplication could be consolidated in the blueprint.

**Hint precision**: **precise** — `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections}` uniquely
identifies the conditional decl; no ambiguity in the Lean namespace.

**Generality**: matches need for the conditional form; `qcoh_iso_tilde_sections_of_presentation`
handles a strictly useful sub-case that the blueprint doesn't cover.

**Recommended chapter-side actions**:
1. Add a `\begin{lemma}...\end{lemma}` block for `qcoh_iso_tilde_sections_of_presentation` with
   `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation}`, recording that it
   discharges `[IsIso F.fromTildeΓ]` via `isIso_fromTildeΓ_of_presentation` when a global
   `F.Presentation` is available. Mark `\leanok`.
2. In the `lem:qcoh_iso_tilde_sections` proof block, replace or supplement the
   unconditional-proof sketch with a short note: "the current Lean proof is the conditional form
   `[IsIso F.fromTildeΓ] → F ≅ M~` (body: `(asIso F.fromTildeΓ).symm`); the unconditional proof
   follows the sketch once the 01I8 instance is available." This avoids misleading a reader who
   reads the proof block without seeing the NOTE in the statement block.
3. Optionally consolidate the 3-step 01I8 decomposition from the Lean `## Handoff` into a
   `\subsection` or remark block near `lem:qcoh_iso_tilde_sections`, so the roadmap is in the
   blueprint rather than only in the Lean comments.

---

## Severity summary

| Finding | Severity |
|---|---|
| Signature mismatch: `lem:qcoh_iso_tilde_sections` informal statement is unconditional; Lean decl is conditional `[IsIso F.fromTildeΓ]`. Correctly disclosed by `% NOTE`; not fixable this iter (requires 01I8 instance). | **major** |
| `qcoh_iso_tilde_sections_of_presentation` lacks a blueprint block (the NOTE flags it as coverage debt). | **major** |
| Proof block prose describes the unconditional proof; actual Lean body is the one-liner conditional proof. NOTE corrects this, but prose-vs-Lean mismatch remains. | **major** |
| Lean `## Handoff` 3-step decomposition is not reflected in the blueprint chapter. | **minor** |
| `qcoh_iso_tilde_sections_hom` and `_inv` lack blueprint blocks. | **minor** |

**Overall verdict**: the conditional decl is axiom-clean and correctly formed; the divergence
from the block's informal quasi-coherent statement is fully disclosed by the `% NOTE`; `\leanok`
is correctly placed on the conditional decl. No must-fix-this-iter findings. Three major coverage
and proof-prose issues warrant blueprint chapter updates in the next plan iteration.
