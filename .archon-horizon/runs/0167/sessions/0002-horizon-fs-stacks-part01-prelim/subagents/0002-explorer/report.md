Read-only scan complete; I sent parent conversation `I-2038`.

Best candidates are chapter 5 wrappers in a new `StacksPart01Lib/Topology.lean`:

- `IsCompact.image` (`Mathlib/Topology/Compactness/Compact.lean:121`) for Stacks `topology-lemma-image-quasi-compact` part (1): `hX.image hf`.
- `IsCompact.of_isClosed_subset` (`:103`) for closed subsets of compact sets.
- `IsClosed.isCompact` (`:853`) under `[CompactSpace X]`.
- `t2_iff_isClosed_diagonal` (`Mathlib/Topology/Separation/Hausdorff.lean:163`) exactly matches Stacks `topology-lemma-Hausdorff`: `T2Space X ↔ IsClosed (diagonal X)`.

The quasi-compact-map/retrocompact part and composition of quasi-compact maps require project-local definitions. Chapter 3 is foundational prose; chapter 4 Yoneda/representability requires substantial custom category setup. No source files were edited.
