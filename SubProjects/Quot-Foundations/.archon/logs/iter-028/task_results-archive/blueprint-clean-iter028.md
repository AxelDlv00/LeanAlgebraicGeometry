# Blueprint-clean report — iter-028

## Chapters reviewed

### `Cohomology_FlatBaseChange.tex` (writer: `fbc-reroute`)

**Leakage found and removed:**

1. **`lem:base_change_mate_codomain_read_legs` (statement body)**
   - Removed opening paragraph: `\emph{Live, via the inner-value route.} ... it is not dead code.`
   - Rephrased "the unit expansion and the eCancel telescoping fire against this read" → "the unit expansion and eCancel telescoping apply uniformly to this parametrised read."
   - Rephrased "dependent-motive wall" → "dependent-motive obstruction."

2. **`lem:base_change_mate_codomain_read_legs` (proof)**
   - Removed trailing sentence: "Because the leg-equality proofs are threaded through the dependent pushforward/pullback data, this parametrised form does not admit the leg elimination the downstream reindex needs; the direct domain-read route (...) supersedes it." (routing/status commentary).

3. **`lem:base_change_mate_unit_value` (statement)**
   - Removed `% LEAN SIGNATURE (elaboration-checked; ...)` block containing 16 lines of raw Lean type signatures (`letI`, `≫`, `≪≫`, `obj`, `hom`, etc.).

4. **`lem:base_change_mate_fstar_reindex_legs_unitExpand` (statement)**
   - Removed opening paragraph: `\emph{Live, via the inner-value route.} ... it is not dead code.`

5. **`lem:base_change_mate_fstar_reindex_legs_gammaDistribute` (statement)**
   - Removed opening paragraph: `\emph{Live, via the inner-value route.} ... it is not dead code.`

6. **`lem:base_change_mate_fstar_reindex_legs` (statement)**
   - Removed opening paragraph: `\emph{Live: the realization of Seam~A.} ... it carries the live inner-value obligation.`
   - Rephrased "is \emph{walled}" → "fails" in the "Why the legs must be parametrised" paragraph (mathematical content about dependent-motive obstruction retained).

7. **`lem:base_change_mate_fstar_reindex` (statement)**
   - Removed `% LEAN SIGNATURE (LHS elaboration-checked)` block (50 lines of raw Lean including `≫`, `obj`, `mapIso`, etc.).
   - Removed `% RECIPE` block with raw Lean identifier references (`pullback_fst_snd_specMap_tensor`, backtick syntax).
   - Removed `% DEAD END (avoid): naive \`rw\`/\`simp\`` tactic commentary.
   - Removed `\emph{Live: the concrete inner value.} ... it is not dead code, since it carries the inner-value obligation.`
   - Retained: `This is the literal-leg instantiation of the leg-parametrised engine Lemma~\ref{lem:base_change_mate_fstar_reindex_legs}.` (clean mathematical characterization).

8. **`% --- The three one-cancellation atoms ...` (comment)**
   - Removed "(iter-024 fbc-ecancel)" iteration reference.
   - Removed "Signatures below were drafted against, and elaboration-checked at, the live goal state of `base_change_mate_inner_value_eq` after its step-(ii) Γ-collapse." (proof-process narrative).

9. **`lem:base_change_mate_inner_eCancel_eUnit` (statement + proof)**
   - Removed `% LEAN SIGNATURE` block (raw Lean theorem signature + tactic commentary).
   - Removed "A single instance-resolution step." from proof (tactic description, not mathematics).

10. **`lem:base_change_mate_inner_eCancel_pushforwardComp` (statement)**
    - Removed `% LEAN SIGNATURE` block (raw Lean theorem signature + `rfl`/`map_id` tactic commentary).

11. **`lem:base_change_mate_inner_eCancel_pullbackComp` (statement)**
    - Removed `% LEAN SIGNATURE` block (raw Lean theorem signature with `letI`, `pullbackSpecIso`, `includeLeftRingHom` syntax + `hom_inv_id_app` tactic).

**Kept (confirmed legitimate mathematics):**
- All "dependent-motive obstruction" / "propositional vs definitional leg equality" language throughout.
- All `% SOURCE QUOTE` blocks (Stacks citations) — verified intact.
- All `\leanok`, `\mathlibok`, `\lean{}`, `\uses{}`, `\label{}` machinery.
- All `% LEAN INTERNAL` comment blocks (structural blueprint engineering notes, not prose leakage).
- The `% --- Seam A ---` structural comment (contains mathematical proof structure, no raw Lean syntax; "WALLED" is colloquial but not a tactic command).
- The full "Why the legs must be parametrised" paragraph (rephrased "walled" → "fails").
- `lem:base_change_mate_inner_eCancel_assemble` — clean, no leakage found.
- `lem:base_change_mate_inner_value_eq` — clean, no leakage found.

---

### `Picard_QuotScheme.tex` (writer: `quot-routef`)

**Result: CLEAN.** Reviewed:
- G1-core proof body (`lem:qcoh_affine_section_localization`): mathematically clean, Route-F sketch with no bare Lean tactics.
- G1-assemble subsection (lemmas `lem:bijective_comp_of_localizations`, `lem:isIso_sheaf_of_isIso_app_basicOpen`, `lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict`, `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`): all clean.
- 12 `\mathlibok` anchors: all properly placed (Mathlib dependency lemmas in `\mathlibok` blocks, project-original lemmas in plain `\leanok` or unmarked blocks).
- Stacks 01HA `% SOURCE QUOTE` block: intact and verified verbatim.
- Hilbert–Serre induction section (subquotient datum, ker/coker constructors, base-case finiteness, induction): all clean.
- Predicates section (`def:modules_annihilator`, `def:schematic_support`, `def:has_proper_support`, `def:is_locally_free_of_rank`): clean, Nitsure SOURCE QUOTEs intact.

No edits made.

---

### `Picard_GrassmannianCells.tex` (writer: `gr-glue`)

**Result: CLEAN.** Reviewed:
- "Scheme-level glue-data layer" section: scheme-theoretic construction paragraphs, pullback isomorphisms, cocycle conditions — all mathematically clean.
- `def:gr_glued_scheme` construction paragraph: clean.
- Nitsure `% SOURCE QUOTE` for `lem:gr_cocycle` and `def:gr_glued_scheme`: intact.
- `% LEAN SIGNATURE` comments found only in earlier (pre-writer) sections, outside the `gr-glue` writer's scope.

No edits made.

---

## SOURCE QUOTE validation

All `% SOURCE QUOTE` blocks checked:
- **Stacks, Cohomology of Schemes, "Affine base change"**: multiple quotes present and verbatim (covering "We use Schemes, Lemma...", "Thus we see that the lemma boils down to the equality").
- **Stacks, tag 01HA** (QuotScheme): present and verbatim.
- **Stacks, tag 00K1** (Hilbert–Serre base case): present and verbatim.
- **Nitsure, §1** (QuotScheme and GrassmannianCells): present and verbatim.

No missing or misquoted SOURCE QUOTE blocks found.

---

## Summary

All Lean-syntax leakage removed from prose of `Cohomology_FlatBaseChange.tex` (11 edits: 5 `% LEAN SIGNATURE` blocks, 4 "Live/dead code" narrative paragraphs, 1 "% RECIPE/% DEAD END" block, 1 comment-header cleanup). Mathematical content — including the "dependent-motive obstruction" language — retained and rephrased where needed. `Picard_QuotScheme.tex` and `Picard_GrassmannianCells.tex` confirmed clean with no edits required.
